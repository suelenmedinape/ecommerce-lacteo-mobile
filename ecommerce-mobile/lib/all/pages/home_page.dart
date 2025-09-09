import 'package:ecommerce/all/components/my_button.dart';
import 'package:ecommerce/all/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../client/models/products.dart';
import '../components/my_product_tile.dart';
import '../service/product_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(''), centerTitle: true),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 25),

            SvgPicture.asset(
              'assets/icons/cow-auth.svg',
              width: 72,
              height: 72,
            ),

            const SizedBox(height: 20),

            const Text(
              'Seja Bem-Vindo!',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              'Aqui você encontra os melhores produtos lácteos da região, com qualidade e sabor incomparáveis!',
              textAlign:
                  TextAlign.center, // centraliza o texto em várias linhas
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),

            InkWell(
              onTap: () {
                // ação ao clicar
                Navigator.pushNamed(context, '/shop_pages'); // exemplo
              },
              borderRadius: BorderRadius.circular(
                12,
              ), // mantém borda arredondada
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // evita ocupar toda a largura
                  children: [
                    Text(
                      'Loja',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_right_alt,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 80),

            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Mais Vendidos!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: FutureBuilder<List<ProductList>>(
                future: ProductService().listProductsBestSellers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final products = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal, // rolagem horizontal
                      padding: const EdgeInsets.all(8),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Container(
                          width: 200, // largura de cada card
                          margin: const EdgeInsets.only(
                            right: 10,
                          ), // espaçamento entre cards
                          child: MyProductTile(
                            product: product,
                            key: ValueKey(product.id),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text("Nenhum produto encontrado"),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
