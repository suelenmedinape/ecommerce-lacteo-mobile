import 'package:flutter/material.dart';

class MyHeader extends StatelessWidget {
  final String category;
  const MyHeader({super.key, this.category = ''});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Home (clicável)
          Icon(Icons.home, size: 15, color: theme.inversePrimary),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/shop_pages');
            },
            child: Text(
              ' Home',
              style: TextStyle(color: theme.inversePrimary, fontSize: 15),
            ),
          ),

          Icon(Icons.keyboard_arrow_right, size: 20, color: theme.inversePrimary),

          // Products (clicável)
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/shop_pages');
            },
            child: Text(
              ' Products',
              style: TextStyle(color: theme.inversePrimary, fontSize: 15),
            ),
          ),

          if (category.isNotEmpty) ...[
            Icon(Icons.keyboard_arrow_right, size: 20, color: theme.inversePrimary),

            // Category (apenas texto)
            Text(
              ' $category',
              style: TextStyle(color: theme.inversePrimary, fontSize: 15),
            ),
          ],
        ],
      ),
    );
  }
}
