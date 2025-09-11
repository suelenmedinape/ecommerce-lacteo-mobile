import 'package:ecommerce/all/components/my_product_tile.dart';
import 'package:ecommerce/client/components/header.dart';
import 'package:ecommerce/client/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../all/components/my_drawer.dart';
import '../../all/service/responses.dart';
import '../models/products.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late Future<ApiResponse<List<ProductList>>> _productsFuture;

  @override
  void initState() {
    super.initState();
    final productService = Provider.of<ProductService>(context, listen: false);
    _productsFuture = productService.listProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop Page"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/cart_pages'),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          MyHeader(),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<ApiResponse<List<ProductList>>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro de Conexão: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final apiResponse = snapshot.data!;

                  if (apiResponse.hasError) {
                    return Center(
                      child: Text(
                        'Erro: ${apiResponse.errorMessage!}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final products = apiResponse.data!;

                  if (products.isEmpty) {
                    return const Center(child: Text("Nenhum produto encontrado."));
                  }

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
                  return const Center(child: Text("Nenhum produto para exibir."));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}