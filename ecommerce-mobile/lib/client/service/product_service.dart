
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/products.dart';

class ProductService {
  final url = 'http://localhost:8080/products';

  Future<List<ProductList>> listProducts() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => ProductList.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar produtos');
    }
  }

  Future<List<String>> listCategory() async {
    final response = await http.get(Uri.parse('$url/list-categories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception('Erro ao carregar categorias');
    }
  }

  Future<List<ProductList>> listByCategory(category) async {
    final response = await http.get(Uri.parse('$url/list?category=$category'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => ProductList.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar produtos');
    }
  }
}