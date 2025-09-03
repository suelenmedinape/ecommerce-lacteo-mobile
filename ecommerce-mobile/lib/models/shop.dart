import 'package:ecommerce/models/product.dart';
import 'package:flutter/material.dart';

class Shop extends ChangeNotifier{
  
  // product for sale
  final List<Product> _shop = [
    Product(name: 'Produto 1', price: 25.00, description: 'Description product 1... mode description...', imagePath: 'https://acdn-us.mitiendanube.com/stores/001/795/764/products/whatsapp-image-2025-03-25-at-16-11-13-1-ff7d2f9191654130d117429304740207-1024-1024.jpeg'),
    Product(name: 'Produto 2', price: 99.00, description: 'Description product 2', imagePath: 'https://s2-g1.glbimg.com/DIdsMSmQXjUtoaQTKD5RrrPMhww=/1200x/smart/filters:cover():strip_icc()/i.s3.glbimg.com/v1/AUTH_59edd422c0c84a879bd37670ae4f538a/internal_photos/bs/2019/N/m/aQXLbLRrulZz0VJa4ZZA/foto2.jpg'),
    Product(name: 'Produto 3', price: 10.00, description: 'Description product 3', imagePath: 'https://24127.cdn.simplo7.net/static/24127/sku/delicias-de-minas-requeijao-e-manteiga-manteiga-de-leite-da-roca-artesanal-500g-p-1738453955995.jpg'),
    Product(name: 'Produto 4', price: 5.00, description: 'Description product 4', imagePath: 'https://revistamaisleite.com.br/wp-content/uploads/2024/01/Iogurte-grego-e-saudavel-e-facil-de-fazer-em-casa.jpg')
  ];

  // user cart
  final List<Product> _cart = [];

  // get product list
  List<Product> get shop => _shop;

  // get user cart
  List<Product> get cart => _cart;

  // add item from cart
  void addToCart(Product item) {
    _cart.add(item);
    notifyListeners();
  }

  // remove item from cart
  void removeFromCart(Product item) {
    _cart.remove(item);
    notifyListeners();
  }
}