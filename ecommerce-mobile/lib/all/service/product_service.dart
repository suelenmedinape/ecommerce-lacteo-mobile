import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../client/models/products.dart';
import 'responses.dart';

class ProductService extends ChangeNotifier {
  final url = 'http://localhost:8080/dashboard/products/best-sellers';

  Future<ApiResponse<List<ProductList>>> listProductsBestSellers() async {
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
}
