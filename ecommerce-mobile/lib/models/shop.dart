import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/service/cart_service.dart';
import 'package:flutter/material.dart';

import '../service/product_service.dart';
import 'cart.dart';

class Shop extends ChangeNotifier {
  final ProductService productService = ProductService();
  final CartService cartService = CartService();

  List<Product> _shop = [];
  List<Product> get shop => _shop;

  List<Product> _cart = [];
  List<Product> get cart => _cart;

  Future<void> fetchProducts() async {
    _shop = await productService.listarProdutos();
    notifyListeners();
  }

  // adicionar item ao carrinho
  Future<void> addToCart(Product product, int quantity) async {
    final cartItem = Cart(id: product.id, quantity: quantity);

    // adiciona localmente
    _cart.add(product);
    notifyListeners();

    // envia para a API
    await cartService.addToCart(cartItem);
  }

  void removeFromCart(Product item) {
    _cart.remove(item);
    notifyListeners();
  }
}
