import 'dart:typed_data'; // Importante para os bytes da imagem
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ProductUploadTestScreen extends StatefulWidget {
  const ProductUploadTestScreen({super.key});

  @override
  State<ProductUploadTestScreen> createState() => _ProductUploadTestScreenState();
}

class _ProductUploadTestScreenState extends State<ProductUploadTestScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  XFile? _selectedImageXFile;
  Uint8List? _selectedImageBytes;
  
  bool _isLoading = false;
  String _statusMessage = 'Aguardando ação...';

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final imageBytes = await image.readAsBytes();
      setState(() {
        _selectedImageXFile = image;
        _selectedImageBytes = imageBytes;
        _statusMessage = 'Imagem selecionada!';
      });
    }
  }

  Future<void> _uploadImageToStorage() async {
    if (_selectedImageXFile == null || _selectedImageBytes == null) {
      setState(() { _statusMessage = 'ERRO: Por favor, selecione uma imagem primeiro.'; });
      return;
    }

    setState(() { _isLoading = true; _statusMessage = 'Enviando imagem para o Storage...'; });

    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('Usuário não está logado.');

      final imageExtension = _selectedImageXFile!.name.split('.').last.toLowerCase();
      final fileName = '${const Uuid().v4()}.$imageExtension';
      final filePath = 'produtos/$fileName';
      
      await supabase.storage.from('arquivos').uploadBinary(
            filePath,
            _selectedImageBytes!,
            fileOptions: FileOptions(
              cacheControl: '3600', 
              upsert: false,
              contentType: 'image/$imageExtension',
            ),
          );

      final publicUrl = supabase.storage.from('arquivos').getPublicUrl(filePath);
      setState(() { _isLoading = false; _statusMessage = 'SUCESSO! Upload permitido.\nURL: $publicUrl'; });

    } on StorageException catch (error) {
      setState(() { _isLoading = false; _statusMessage = 'ERRO! Upload bloqueado.\nDetalhes: ${error.message}'; });
    } catch (error) {
      setState(() { _isLoading = false; _statusMessage = 'ERRO Inesperado: $error'; });
    }
}

  @override
  Widget build(BuildContext context) {
    final userEmail = supabase.auth.currentUser?.email ?? 'Ninguém logado';

    return Scaffold(
      appBar: AppBar(title: const Text('Tela de Teste de Upload')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Logado como: $userEmail', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Container(
                height: 200,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                // MUDANÇA 3: Usamos Image.memory para exibir a imagem a partir dos bytes
                child: _selectedImageBytes != null
                    ? Image.memory(_selectedImageBytes!, fit: BoxFit.cover)
                    : const Center(child: Text('Nenhuma imagem selecionada')),
              ),
              const SizedBox(height: 20),
              // ... o resto da UI continua igual ...
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('1. Selecionar Imagem'),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _uploadImageToStorage,
                icon: const Icon(Icons.cloud_upload),
                label: const Text('2. Enviar Imagem para o Storage'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              const SizedBox(height: 30),
              if (_isLoading) const Center(child: CircularProgressIndicator()),
              Text(_statusMessage, textAlign: TextAlign.center, style: TextStyle(color: _statusMessage.startsWith('ERRO') ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}