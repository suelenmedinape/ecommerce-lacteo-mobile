import 'dart:convert';
import 'package:ecommerce/all/service/user_logado.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'responses.dart';

class RegisterService extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  final LoginService loginService = LoginService();

  final supabase = Supabase.instance.client;
  final String backendUrl = "http://localhost:8080/auth/register";

  // ---> ASSINATURA ATUALIZADA
  Future<ApiResponse<bool>> register({
    required String name,
    required String email,
    required String password,
    required GlobalKey<FormState> formKey,
    required BuildContext context,
  }) async {
    // ---> ADICIONADO retorno para validação
    if (!formKey.currentState!.validate()) {
      return ApiResponse(
        errorMessage: "Por favor, preencha os campos corretamente.",
      );
    }

    _loading = true;
    notifyListeners();

    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception("Erro ao registrar no Supabase");
      }

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

      final responseData = jsonDecode(backendResponse.body);

      if (backendResponse.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Cadastro realizado com sucesso! Realizando login...",
            ),
          ),
        );
        await loginService.login(
          email: email,
          password: password,
          formKey: formKey,
          context: context,
        );
        // ---> ADICIONADO retorno de sucesso
        return ApiResponse(
          data: true,
          successMessage:
              responseData['message'] ?? "Cadastro realizado com sucesso!",
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message'] ?? "Erro ao finalizar cadastro.",
            ),
          ),
        );
        // ---> ADICIONADO retorno de erro do backend
        return ApiResponse(
          errorMessage:
              responseData['message'] ?? "Erro desconhecido do servidor.",
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro no registro: $e")));
      // ---> ADICIONADO retorno de erro da exceção
      return ApiResponse(errorMessage: "Erro no registro: $e");
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

  // ---> ASSINATURA ATUALIZADA
  Future<ApiResponse<bool>> login({
    required String email,
    required String password,
    required GlobalKey<FormState> formKey,
    required BuildContext context,
  }) async {
    // ---> ADICIONADO retorno para validação
    if (!formKey.currentState!.validate()) {
      return ApiResponse(
        errorMessage: "Por favor, preencha os campos corretamente.",
      );
    }

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
      Navigator.pushNamed(context, '/shop_pages');

      // ---> ADICIONADO retorno de sucesso
      return ApiResponse(data: true);
    } catch (e) {
      // Melhorando a mensagem de erro para o usuário
      String errorMessage = "Ocorreu um erro inesperado.";
      if (e is AuthException) {
        errorMessage = "E-mail ou senha inválidos.";
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));

      // ---> ADICIONADO retorno de erro da exceção
      return ApiResponse(errorMessage: errorMessage);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ---> ASSINATURA ATUALIZADA
  Future<ApiResponse<bool>> logoutSupa(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signOut();
      await logout(); // Sua função local de logout

      // ---> ADICIONADO retorno de sucesso
      return ApiResponse(data: true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao sair: $e")));

      // ---> ADICIONADO retorno de erro da exceção
      return ApiResponse(errorMessage: "Erro ao sair: $e");
    }
  }
}
