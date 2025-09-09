import 'dart:convert';
import 'package:ecommerce/all/service/user_logado.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterService extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  final LoginService loginService = LoginService();

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
          const SnackBar(
            content: Text("Cadastro realizado com sucesso realizando login!"),
          ),
        );

        await loginService.login(
          email: email,
          password: password,
          formKey: formKey,
          context: context,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro do backend: ${backendResponse.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro no registro: $e")));
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

class LoginService extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  final supabase = Supabase.instance.client;

  Future<void> login({
    required String email,
    required String password,
    required GlobalKey<FormState> formKey,
    required BuildContext context,
  }) async {
    if (!formKey.currentState!.validate()) return;

    _loading = true;
    notifyListeners();

    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception("Erro ao entrar no Supabase");
      }

      final accessToken = response.session?.accessToken;

      await salvarLogin(accessToken!);
      /*if (getRole() == 'ROLE_ADMIN') {
        Navigator.pushNamed(context, '/productor_page');
      } else {*/
      Navigator.pushNamed(context, '/shop_pages');
      //}
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro no registro: $e")));
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // logout()
  Future<void> logoutSupa(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signOut();
      await logout();

    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao sair: $e")));
    }
  }
}
