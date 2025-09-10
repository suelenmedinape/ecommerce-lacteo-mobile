import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/client/models/products.dart';
import 'package:ecommerce/client/service/cart_service.dart';
import 'package:flutter/material.dart';

import 'my_textfield.dart';

class MyProductTile extends StatelessWidget {
  final ProductList product;

  const MyProductTile({super.key, required this.product});

  void add(BuildContext context, int productId) {
    final controller = TextEditingController();
    final CartService cartService = CartService();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar ao Carrinho'),
        content: MyTextFormField(
          controller: controller,
          hintText: 'Quantidade',
          obscureText: false,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final quantity = int.tryParse(controller.text) ?? 1;

              Navigator.pop(context); // fecha o diálogo

              final success = await cartService.addToCart(quantity, productId);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Produto adicionado ao carrinho!'
                          : 'Erro ao adicionar.',
                    ),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.amber),
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(20),
      width: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // product image
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: double.infinity,
                  padding: EdgeInsets.all(25),
                  child: product.imagePath != null
                      ? CachedNetworkImage(
                          imageUrl: product.imagePath!,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                ),
              ),

              const SizedBox(height: 10),

              //product name
              Text(
                product.productName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),

              //category
              Text(
                product.categories,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),

              // product price + add to cart
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // product page
                  Text('R\$${product.price.toStringAsFixed(2)}'),

                  // add to cart
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () {
                        add(context, product.id);
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
