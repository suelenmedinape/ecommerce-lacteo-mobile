import 'package:ecommerce/all/components/my_list_tile.dart';
import 'package:ecommerce/all/service/auth_service.dart';
import 'package:ecommerce/all/service/user_logado.dart';
import 'package:ecommerce/client/service/product_service.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ProductService productService = ProductService();
    final LoginService loginService = LoginService();
    final AuthService authService = AuthService();

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Theme(
        data: theme.copyWith(
          dividerTheme: const DividerThemeData(
            color: Colors.transparent,
            thickness: 0,
            space: 0,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 25),

            // 🔹 Header com FutureBuilder (dados do usuário)
            FutureBuilder<Map<String, dynamic>?>(
              future: authService.clientDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError || snapshot.data == null) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Erro ao carregar dados"),
                  );
                } else {
                  final dados = snapshot.data!;
                  final nome = dados['name'] ?? "Usuário";
                  final email = dados['email'] ?? "Sem e-mail";

                  return SafeArea(
                    bottom: false,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            child: Text(
                              nome.isNotEmpty ? nome[0].toUpperCase() : "?",
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                nome,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                email,
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
                  );
                }
              },
            ),

            const SizedBox(height: 25),

            // 🔹 itens principais
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

                  // 🔹 Categorias dinâmicas
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: FutureBuilder<List<String>>(
                      future: productService.listCategory(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
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
      ),
    );
  }
}
