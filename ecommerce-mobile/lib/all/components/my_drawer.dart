import 'package:ecommerce/all/components/my_list_tile.dart';
import 'package:ecommerce/all/service/auth_service.dart';
import 'package:ecommerce/client/service/client_service.dart';
import 'package:ecommerce/client/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ProductService productService = ProductService();
    final LoginService loginService = LoginService();

    final clientService = context.watch<ClientService>();
    final dados = clientService.client;

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: Column(
        children: [
          const SizedBox(height: 25),

          // 🔹 Header observando o provider
          if (clientService.loading && dados == null)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            )
          else if (dados == null)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text("Erro ao carregar dados"),
            )
          else
            SafeArea(
              bottom: false,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      child: Text(
                        (dados['name'] ?? 'U')[0].toUpperCase(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dados['name'] ?? "Usuário",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          dados['email'] ?? "Sem e-mail",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 25),

          // 🔹 itens
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                MyListTile(
                  text: 'Shop',
                  icon: Icons.shopping_bag,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/shop_pages');
                  },
                ),
                MyListTile(
                  text: 'Cart',
                  icon: Icons.shopping_cart,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/cart_pages');
                  },
                ),
                // 🔹 categorias
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: FutureBuilder<List<String>>(
                    future: productService.listCategory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Erro: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final categories = snapshot.data!;
                        return ExpansionTile(
                          leading: const Icon(Icons.category, color: Colors.grey),
                          title: const Text('Categorias'),
                          children: categories.map((category) {
                            return MyListTile(
                              text: category,
                              icon: Icons.label_important_outline,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                  context,
                                  '/byCategory',
                                  arguments: category,
                                );
                              },
                            );
                          }).toList(),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Exit
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
              text: 'Exit',
              icon: Icons.logout,
              onTap: () async {
                await loginService.logoutSupa(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/intro_page',
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}