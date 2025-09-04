import 'package:ecommerce/components/my_drawer.dart';
import 'package:ecommerce/components/my_product_tile.dart';
import 'package:ecommerce/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Shop Page'),
        centerTitle: true,
        actions: [
          // go to cart button
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/cart_pages'),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder(
        future: Provider.of<Shop>(context, listen: false).fetchProducts(),
        builder: (context, snapshot) {
          // enquanto carrega
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // se deu erro
          if (snapshot.hasError) {
            return Center(
              child: Text("Erro: ${snapshot.error}"),
            );
          }

          // se deu certo
          final products = context.watch<Shop>().shop;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),

              // shop subtitle
              Padding(
                padding: const EdgeInsets.only(left: 25, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shop',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    Text(
                      'Pick from a selected list of premium products',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // product grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // duas colunas
                    crossAxisSpacing: 10, // espaço horizontal
                    mainAxisSpacing: 10, // espaço vertical
                    childAspectRatio: 0.7, // altura x largura
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return MyProductTile(product: product);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
