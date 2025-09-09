import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../client/models/products.dart';

class ProductService extends ChangeNotifier {
  final url = 'http://localhost:8080/dashboard/products/best-sellers';

  Future<List<ProductList>> listProductsBestSellers() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => ProductList.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar produtos');
    }
  }
}
