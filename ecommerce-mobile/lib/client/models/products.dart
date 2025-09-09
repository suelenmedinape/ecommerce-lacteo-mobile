
class ProductList {
  final int id;
  final String productName;
  final double price;
  final int quantity;
  final String categories;

  ProductList({
    required this.id,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.categories,
  });

  // Construtor para converter de JSON -> Product
  factory ProductList.fromJson(Map<String, dynamic> json) {
    return ProductList(
      id: json['id'],
      productName: json['productName'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      categories: json['categories'],
    );
  }
}
