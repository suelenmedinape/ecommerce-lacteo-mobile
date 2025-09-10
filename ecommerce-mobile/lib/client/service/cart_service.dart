import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../all/service/user_logado.dart';
import '../models/cart.dart';

class CartService extends ChangeNotifier {
  final url = 'http://localhost:8080/cart';
  List<CartItem> cartItems = [];

  Future<bool> addToCart(int quantity, int productId) async {
    final token = await getToken();
    final data = {"productId": productId, "quantity": quantity};

    final response = await http.post(
      Uri.parse('$url/add'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      await listCartItems(); // atualiza a lista local
      return true;
    } else {
      print("Erro ao adicionar: ${response.statusCode} - ${response.body}");
      return false;
    }
  }

  Future<void> listCartItems() async {
    final token = await getToken();

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      cartItems = data.map((json) => CartItem.fromJson(json)).toList();
      notifyListeners(); // ✅ atualiza a UI
    } else {
      print("Erro ao listar: ${response.statusCode} - ${response.body}");
      cartItems = [];
      notifyListeners();
    }
  }

  Future<bool> updateCart(int quantity, int productId) async {
    final token = await getToken();
    final data = {"productId": productId, "quantity": quantity};

    final response = await http.put(
      Uri.parse('$url/update'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      await listCartItems(); // atualiza a lista local
      return true;
    } else {
      print("Erro ao atualizar: ${response.statusCode} - ${response.body}");
      return false;
    }
  }

  Future<bool> removeToCart(int productId) async {
    final token = await getToken();

    final response = await http.delete(
      Uri.parse('$url/$productId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      await listCartItems();
      return true;
    } else {
      print("Erro ao atualizar: ${response.statusCode} - ${response.body}");
      return false;
    }
  }

  Future<String?> buyItemsCart(int productId) async {
    final token = await getToken();

    final response = await http.post(
      Uri.parse('$url/buy'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      await listCartItems();
      return null; // null significa que não houve erro
    } else {
      final data = jsonDecode(response.body);
      if (data != null && data['message'] != null) {
        return data['message']; // retorna a mensagem do backend
      } else {
        return "Erro desconhecido";
      }
    }
  }
}
