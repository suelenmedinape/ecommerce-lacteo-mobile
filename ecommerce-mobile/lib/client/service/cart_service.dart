import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../all/service/responses.dart';
import '../../all/service/user_logado.dart';
import '../models/cart.dart';

class CartService extends ChangeNotifier {
  final url = 'http://localhost:8080/cart';
  List<CartItem> cartItems = [];

  Future<ApiResponse<bool>> addToCart(int quantity, int productId) async {
    try {
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

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await listCartItems();
        return ApiResponse(
          data: true,
          successMessage:
              responseData['message'] ?? 'Produto Adicionado ao Carrinho!',
        );
      } else {
        return ApiResponse(
          errorMessage:
              responseData['message'] ?? 'Ocorreu um erro desconhecido.',
        );
      }
    } catch (e) {
      return ApiResponse(
        errorMessage: 'Não foi possível conectar ao servidor. Tente novamente.',
      );
    }
  }

  Future<ApiResponse<bool>> listCartItems() async {
    try {
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
        notifyListeners();
        return ApiResponse(
          data: true,
        ); // Sinaliza que a operação foi um sucesso
      } else {
        final responseData = jsonDecode(response.body);
        cartItems = [];
        notifyListeners();
        return ApiResponse(
          errorMessage:
              responseData['message'] ?? 'Falha ao carregar o carrinho.',
        );
      }
    } catch (e) {
      cartItems = [];
      notifyListeners();
      return ApiResponse(
        errorMessage: 'Erro de conexão ao carregar o carrinho.',
      );
    }
  }

  Future<ApiResponse<bool>> updateCart(int quantity, int productId) async {
    try {
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

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await listCartItems();
        return ApiResponse(
          data: true,
          successMessage:
              responseData['message'] ?? 'Carrinho Atualizado com Sucesso!',
        );
      } else {
        return ApiResponse(
          errorMessage:
              responseData['message'] ?? 'Ocorreu um erro desconhecido.',
        );
      }
    } catch (e) {
      return ApiResponse(
        errorMessage: 'Não foi possível conectar ao servidor. Tente novamente.',
      );
    }
  }

  Future<ApiResponse<bool>> removeToCart(int productId) async {
    try {
      final token = await getToken();

      final response = await http.delete(
        Uri.parse('$url/$productId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await listCartItems();
        return ApiResponse(
          data: true,
          successMessage: responseData['message'] ?? 'Produto removido!',
        );
      } else {
        return ApiResponse(
          errorMessage:
              responseData['message'] ?? 'Ocorreu um erro desconhecido.',
        );
      }
    } catch (e) {
      return ApiResponse(
        errorMessage: 'Não foi possível conectar ao servidor. Tente novamente.',
      );
    }
  }

  Future<ApiResponse<bool>> buyItemsCart() async {
    try {
      final token = await getToken();

      final response = await http.post(
        Uri.parse('$url/buy'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      Map<String, dynamic>? responseData;
      try {
        responseData = jsonDecode(response.body);
      } catch (_) {
        responseData = null; // caso o backend não mande JSON
      }

      if (response.statusCode == 200) {
        await listCartItems();
        return ApiResponse(
          data: true,
          successMessage:
              responseData?['message'] ?? 'Compra realizada com sucesso!',
        );
      } else {
        return ApiResponse(
          errorMessage:
              responseData?['message'] ?? 'Não foi possível concluir a compra.',
        );
      }
    } catch (e) {
      return ApiResponse(
        errorMessage: 'Falha na comunicação com o servidor: $e',
      );
    }
  }
}
