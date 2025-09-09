/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../backup/models/product.dart';

class MyProductTile extends StatelessWidget {
  final Product product;

  const MyProductTile({super.key, required this.product});

  void quantity(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quantidade'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: 'Digite a quantidade'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final qty = int.tryParse(controller.text) ?? 1;
              /*final success = await Provider.of<Shop>(
                context,
                listen: false,
              ).addToCart(product, qty);

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Produto adicionado ao carrinho!"),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Erro ao adicionar o produto.")),
                );
              }*/

              Navigator.pop(context); // fecha dialog quantidade
              Navigator.pop(context); // fecha dialog "Adicionar ao carrinho"
            },
            child: Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  // add to cart
  void addToCart(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Adicionar este item ao carrinho?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(onPressed: () => quantity(context), child: Text('Sim')),
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
                  //child: Image.asset(product.imagePath),
                ),
              ),

              const SizedBox(height: 10),

              //product name
              Text(
                product.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),

              //category
              Text(
                product.category,
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
                      onPressed: () => addToCart(context),
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
}*/
