import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  final supabase = Supabase.instance.client;
  final String backendUrl =
      'http://localhost:8080/auth/register';

  bool _loading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    AuthResponse?
    supabaseResponse; 
    try {
      supabaseResponse = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } catch (e) {
      print('ERRO NO SUPABASE: $e'); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registrar no Supabase: $e')),
      );
      setState(() {
        _loading = false;
      });
      return;
    }

    if (supabaseResponse.user != null) {
      final supabaseId = supabaseResponse.user!.id;
      final userData = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'supabaseId': supabaseId,
      };

      print('Enviando dados para backend: $backendUrl');
      print(jsonEncode(userData));

      try {
        final backendResponse = await http.post(
          Uri.parse(backendUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userData),
        );

        print('Status code do backend: ${backendResponse.statusCode}');
        print('Body do backend: ${backendResponse.body}');

        if (backendResponse.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cadastro realizado com sucesso!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro do backend: ${backendResponse.body}')),
          );
        }
      } catch (e) {

        print(
          'ERRO DE CONEXÃO COM O BACKEND: $e',
        ); 

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro de conexão: Verifique a rede ou o servidor.'),
          ),
        );
      }
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Informe o email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) => value!.length < 8
                    ? 'Senha deve ter ao menos 8 caracteres'
                    : null,
              ),
              SizedBox(height: 20),
              _loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _register,
                      child: Text('Registrar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
