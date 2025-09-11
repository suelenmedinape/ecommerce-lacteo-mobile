import 'dart:convert';
import 'package:ecommerce/client/models/client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../all/service/user_logado.dart';

class ClientService extends ChangeNotifier {
  final url = 'http://localhost:8080/my';
  Client? client; // agora usamos o model
  bool loading = false;

  // Carregar detalhes do cliente
  Future<void> clientDetail() async {
    loading = true;
    notifyListeners();

    final token = await getToken();
    if (token == null) {
      loading = false;
      notifyListeners();
      return;
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
    } else {
      client = null;
    }

    loading = false;
    notifyListeners();
  }

  // Atualizar detalhes
  Future<bool> updateDetailsClient(Map<String, dynamic> data) async {
    final token = await getToken();
    if (token == null) {
      print("Erro de autenticação: Token não encontrado.");
      return false;
    }

    loading = true;
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse('$url/details'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // *** A CORREÇÃO ESTÁ AQUI ***
        // O backend retornou sucesso (2xx), mas com corpo vazio.
        // Não tentamos mais fazer o jsonDecode. Apenas confirmamos o sucesso.

        // Opcional: Para manter o app atualizado, você pode chamar um método
        // para buscar os dados do cliente novamente ou atualizar localmente.
        // Por agora, vamos apenas finalizar a operação.

        print("Dados atualizados com sucesso no backend!");
        loading = false;
        notifyListeners();
        return true;
      } else {
        // A API retornou um código de erro (4xx, 5xx)
        print("Erro ao atualizar: ${response.statusCode} - ${response.body}");
        loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      // Ocorreu um erro na requisição (ex: sem internet)
      print("Uma exceção ocorreu: $e");
      loading = false;
      notifyListeners();
      return false;
    }
  }
}
