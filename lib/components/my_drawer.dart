import 'package:ecommerce/components/my_list_tile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final String nome;
  final String email;

  const MyDrawer({
    super.key,
    this.nome = "Usuário",
    this.email = "email@email.com",
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

            // Header: user info
            SafeArea(
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
                          style: TextStyle(
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

            // itens principais
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [

                  // shop tile
                  MyListTile(
                    text: 'Shop',
                    icon: Icons.home,
                    onTap: () => Navigator.pop(context),
                  ),

                  // cart tile
                  MyListTile(
                    text: 'Cart',
                    icon: Icons.shopping_cart,
                    onTap: () {
                      // pop drawer first
                      Navigator.pop(context);

                      // go to cart page
                      Navigator.pushNamed(context, '/cart_pages');
                    },
                  ),
                ],
              ),
            ),

            // exit shop tile
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: MyListTile(
                text: 'Exit',
                icon: Icons.logout,
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/intro_page',
                  (route) => false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
