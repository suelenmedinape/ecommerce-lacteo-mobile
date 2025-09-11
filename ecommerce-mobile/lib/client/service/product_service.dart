
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../all/service/responses.dart';
import '../models/products.dart';

class ProductService extends ChangeNotifier {
  final url = 'http://localhost:8080/products';

  Future<ApiResponse<List<ProductList>>> listProducts() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final products =
            data.map((json) => ProductList.fromJson(json)).toList();
        return ApiResponse(data: products);
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return ApiResponse(
            errorMessage: responseData['message'] ?? 'Erro ao carregar produtos.');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Falha na comunicação com o servidor.');
    }
  }

  Future<ApiResponse<List<String>>> listCategory() async {
    try {
      final response = await http.get(Uri.parse('$url/list-categories'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final categories = data.map((e) => e.toString()).toList();
        return ApiResponse(data: categories);
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return ApiResponse(
            errorMessage: responseData['message'] ?? 'Erro ao carregar categorias.');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Falha na comunicação com o servidor.');
    }
  }

  Future<ApiResponse<List<ProductList>>> listByCategory(String category) async {
    try {
      final response = await http.get(Uri.parse('$url/list?category=$category'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final products =
            data.map((json) => ProductList.fromJson(json)).toList();
        return ApiResponse(data: products);
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return ApiResponse(
            errorMessage: responseData['message'] ?? 'Erro ao carregar produtos.');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Falha na comunicação com o servidor.');
    }
  }
}