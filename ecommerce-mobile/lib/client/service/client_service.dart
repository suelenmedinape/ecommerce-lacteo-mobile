import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../all/service/user_logado.dart';

class ClientService extends ChangeNotifier {
  final url = 'http://localhost:8080/my';
  Map<String, dynamic>? client;
  bool loading = false;

  Future<void> clientDetails() async {
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
      client = jsonDecode(response.body);
    } else {
      client = null;
    }

    loading = false;
    notifyListeners();
  }

  Future<bool> updateDetailsClient(Map<String, dynamic> object) async {
    final token = await getToken();

    if (token == null) return false;

    loading = true;
    notifyListeners();

    final response = await http.put(
      Uri.parse('$url/details'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(object),
    );

    if (response.statusCode == 200) {
      client = object; // atualiza cache local
      loading = false;
      notifyListeners();
      return true;
    } else {
      print("Erro ao atualizar: ${response.statusCode} - ${response.body}");
      loading = false;
      notifyListeners();
      return false;
    }
  }
}
