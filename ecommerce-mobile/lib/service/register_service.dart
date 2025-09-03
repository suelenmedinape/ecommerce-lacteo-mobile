import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterService extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  final supabase = Supabase.instance.client;
  final String backendUrl = "http://localhost:8080/auth/register";

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required GlobalKey<FormState> formKey,
    required BuildContext context,
  }) async {
    if (!formKey.currentState!.validate()) return;

    _loading = true;
    notifyListeners();

    try {
      // 1. Registrar no Supabase
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception("Erro ao registrar no Supabase");
      }

      // 2. Enviar para o backend
      final userData = {
        "name": name,
        "email": email,
        "supabaseId": response.user!.id,
      };

      final backendResponse = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );

      if (backendResponse.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cadastro realizado com sucesso!")),
        );
        Navigator.pushNamed(context, '/login_page');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro do backend: ${backendResponse.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro no registro: $e")),
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
