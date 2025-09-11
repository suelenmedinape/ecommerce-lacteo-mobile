import 'package:ecommerce/all/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../all/components/my_button.dart';
import '../service/client_service.dart';

import 'package:provider/provider.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final cpfController = TextEditingController();
  final streetController = TextEditingController();
  final numberController = TextEditingController();
  final cityController = TextEditingController();
  final neighborhoodController = TextEditingController();
  final stateController = TextEditingController();

  // 1. Declare a variável como um membro da classe State.
  // Inicia como `false` por padrão.
  bool _isEditingAddress = false;
  bool _isDataInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Usamos didChangeDependencies porque ele é chamado depois do initState
    // e nos dá acesso seguro ao context. É o lugar ideal para usar ModalRoute.
    // O `_isDataInitialized` previne que este código rode múltiplas vezes.
    if (!_isDataInitialized) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      
      // Verifica se o argumento é um booleano e se é true.
      if (arguments is bool && arguments == true) {
        setState(() {
          _isEditingAddress = true;
        });
        // Se estiver editando, busca os dados para preencher o formulário.
        _loadClientData();
      }
      _isDataInitialized = true;
    }
  }

  // Método para carregar os dados do cliente e preencher os campos
  Future<void> _loadClientData() async {
    final clientService = context.read<ClientService>();
    
    // Se o cliente ainda não foi carregado, carrega agora.
    if (clientService.client == null) {
      await clientService.clientDetail();
    }

    final clientData = clientService.client;
    if (clientData != null && mounted) { // `mounted` verifica se o widget ainda está na tela
      nameController.text = clientData.name;
      phoneController.text = clientData.phone ?? '';
      cpfController.text = clientData.cpf ?? '';
      
      if (clientData.address != null) {
        streetController.text = clientData.address!.street;
        numberController.text = clientData.address!.number;
        cityController.text = clientData.address!.city;
        neighborhoodController.text = clientData.address!.neighborhood;
        stateController.text = clientData.address!.state;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientService = context.watch<ClientService>();
    
    // Define o título da página dinamicamente
    final pageTitle = _isEditingAddress ? "Editar Meus Dados" : "Adicionar Novo Endereço";

    if (clientService.loading && _isEditingAddress && clientService.client == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 50),
              SvgPicture.asset(
                'assets/icons/cow-auth.svg',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 50),
              MyTextFormField(
                controller: nameController,
                hintText: "Nome",
                obscureText: false,
              ),
              const SizedBox(height: 15),
              MyTextFormField(
                controller: phoneController,
                hintText: "Telefone",
                obscureText: false,
              ),
              // ... resto dos seus TextFormFields
              const SizedBox(height: 15),
              MyTextFormField(
                controller: cpfController,
                hintText: "CPF",
                obscureText: false,
              ),
              const SizedBox(height: 15),
              MyTextFormField(
                controller: streetController,
                hintText: "Rua",
                obscureText: false,
              ),
              const SizedBox(height: 15),
              MyTextFormField(
                controller: numberController,
                hintText: "Número",
                obscureText: false,
              ),
              const SizedBox(height: 15),
              MyTextFormField(
                controller: cityController,
                hintText: "Cidade",
                obscureText: false,
              ),
              const SizedBox(height: 15),
              MyTextFormField(
                controller: neighborhoodController,
                hintText: "Bairro",
                obscureText: false,
              ),
              const SizedBox(height: 15),
              MyTextFormField(
                controller: stateController,
                hintText: "Estado",
                obscureText: false,
              ),
              const SizedBox(height: 20),

              MyButtonAuth(
                textButtonName: "Salvar",
                loading: clientService.loading,
                onTap: () async {
                  final clientData = {
                    "name": nameController.text,
                    "phone": phoneController.text,
                    "cpf": cpfController.text,
                    "address": {
                      "street": streetController.text,
                      "number": numberController.text,
                      "city": cityController.text,
                      "neighborhood": neighborhoodController.text,
                      "state": stateController.text,
                    },
                  };

                  final success = await clientService.updateDetailsClient(clientData);

                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Dados salvos com sucesso!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // 3. Padrão recomendado: Em vez de empurrar uma nova rota,
                    // simplesmente volte para a tela anterior.
                    // Isso torna seu componente muito mais reutilizável.
                    Navigator.pop(context);
                  } else if (mounted) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Ocorreu um erro ao salvar."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}