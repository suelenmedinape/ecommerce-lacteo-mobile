import 'dart:convert';

import 'package:ecommerce/models/product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String url = "http://localhost:8080/products";

  Future<List<Product>> listarProdutos() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar produtos: ${response.statusCode}');
    }
  }
}
