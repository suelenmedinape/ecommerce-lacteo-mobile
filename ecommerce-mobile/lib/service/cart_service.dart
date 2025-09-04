import 'dart:convert';
import 'package:ecommerce/service/user_logado.dart';
import 'package:http/http.dart' as http;
import '../models/cart.dart';

class CartService {
  final String url = 'http://localhost:8080/cart';

  Future<void> addToCart(Cart cart) async {
    final token = await getToken();
    print(jsonEncode({'productId': cart.id, 'quantity': cart.quantity}));
    print('-----------TOKEN--------------\n$token');
    final response = await http.post(
      Uri.parse('$url/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'productId': cart.id, 'quantity': cart.quantity}),
    );

    if (response.statusCode == 200) {
      print("✅ Produto adicionado ao carrinho: ${response.body}");
    } else {
      print("❌ Erro ao adicionar produto: ${response.statusCode}");
    }
  }
}
