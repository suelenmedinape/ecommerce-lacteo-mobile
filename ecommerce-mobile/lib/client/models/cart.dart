import 'products.dart';

class CartItem {
  final int id;
  late final int quantity;
  final double unitPrice;
  final double totalPrice;
  final ProductList product;

  CartItem({
    required this.id,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      quantity: json['quantity'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      product: ProductList.fromJson(json['product']),
    );
  }
}
