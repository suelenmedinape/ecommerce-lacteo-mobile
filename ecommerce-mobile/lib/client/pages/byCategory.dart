import 'package:flutter/material.dart';

import '../../all/components/my_drawer.dart';
import '../../all/components/my_product_tile.dart';
import '../models/products.dart';
import '../service/product_service.dart';

class Bycategory extends StatelessWidget {
  const Bycategory({super.key});

  @override
  Widget build(BuildContext context) {
    // pega a categoria passada como argumento
    final String category =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: const Text("Shop Page"), centerTitle: true),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.home,
                  size: 15,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                Text(
                  ' Home',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 15,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_right,
                  size: 20,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                Text(
                  ' Products',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 15,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_right,
                  size: 20,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                Text(
                  ' $category',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // lista de produtos da categoria
          Expanded(
            child: FutureBuilder<List<ProductList>>(
              future: ProductService().listByCategory(category),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final products = snapshot.data!;
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.7,
                        ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return MyProductTile(
                        product: product,
                        key: ValueKey(product.id),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("Nenhum produto encontrado"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
