import 'dart:convert';
import 'package:ecommerce/client/models/client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../all/service/responses.dart';
import '../../all/service/user_logado.dart';

class ClientService extends ChangeNotifier {
  final url = 'http://localhost:8080/my';
  Client? client;
  bool loading = false;

  Future<ApiResponse<bool>> clientDetail() async {
    loading = true;
    notifyListeners();

    try {
      final token = await getToken();
      if (token == null) {
        loading = false;
        notifyListeners();
        return ApiResponse(errorMessage: "Usuário não autenticado.");
      }

      final response = await http.get(
        Uri.parse('$url/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        client = Client.fromJson(data);
        loading = false;
        notifyListeners();
        return ApiResponse(data: true);
      } else {
        client = null;
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        loading = false;
        notifyListeners();
        return ApiResponse(
            errorMessage: responseData['message'] ?? 'Falha ao carregar perfil.');
      }
    } catch (e) {
      client = null;
      loading = false;
      notifyListeners();
      return ApiResponse(errorMessage: "Erro de conexão ao buscar perfil.");
    }
  }

  Future<ApiResponse<bool>> updateDetailsClient(
      Map<String, dynamic> data) async {
    loading = true;
    notifyListeners();

    try {
      final token = await getToken();
      if (token == null) {
        loading = false;
        notifyListeners();
        return ApiResponse(
            errorMessage: "Erro de autenticação: Token não encontrado.");
      }

      final response = await http.put(
        Uri.parse('$url/details'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        loading = false;
        notifyListeners();
        return ApiResponse(
            data: true, successMessage: "Dados atualizados com sucesso!");
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        loading = false;
        notifyListeners();
        return ApiResponse(
            errorMessage: responseData['message'] ?? 'Erro ao atualizar dados.');
      }
    } catch (e) {
      loading = false;
      notifyListeners();
      return ApiResponse(errorMessage: 'Falha na comunicação com o servidor.');
    }
  }
}