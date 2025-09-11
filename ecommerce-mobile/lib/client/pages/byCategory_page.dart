import 'package:ecommerce/client/components/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../all/components/my_drawer.dart';
import '../../all/components/my_product_tile.dart';
import '../../all/service/responses.dart';
import '../models/products.dart';
import '../service/product_service.dart';

class Bycategory extends StatefulWidget {
  const Bycategory({super.key});

  @override
  State<Bycategory> createState() => _BycategoryState();
}

class _BycategoryState extends State<Bycategory> {
  late Future<ApiResponse<List<ProductList>>> _productsFuture;
  String _category = ''; 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_category.isEmpty) {
      _category = ModalRoute.of(context)!.settings.arguments as String;
      
      final productService = Provider.of<ProductService>(context, listen: false);
      _productsFuture = productService.listByCategory(_category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shop Page"), centerTitle: true),
      drawer: MyDrawer(),
      body: Column(
        children: [
          MyHeader(
            category: _category,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<ApiResponse<List<ProductList>>>(
              future: _productsFuture, 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro de Conexão: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  
                  final apiResponse = snapshot.data!;

                  if (apiResponse.hasError) {
                    return Center(child: Text('Erro: ${apiResponse.errorMessage!}'));
                  }

                  final products = apiResponse.data!;
                  
                  if (products.isEmpty) {
                     return const Center(child: Text("Nenhum produto encontrado nesta categoria"));
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