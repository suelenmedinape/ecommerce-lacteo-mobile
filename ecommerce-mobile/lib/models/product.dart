class Product {
  final int id;
  final String name;
  final double price;
  final int quantity;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['productName'],  
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      category: json['categories'],
    );
  }
}
