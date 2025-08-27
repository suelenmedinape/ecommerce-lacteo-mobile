import 'package:ecommerce/models/shop.dart';
import 'package:ecommerce/pages/cart_page.dart';
import 'package:ecommerce/pages/intro_page.dart';
import 'package:ecommerce/pages/shop_pages.dart';
import 'package:ecommerce/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Shop(),
      child: const Ecommerce(),
    ),
  );
}

class Ecommerce extends StatelessWidget {
  const Ecommerce({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const IntroPage(),
      theme: appColor,
      routes: {
        '/intro_page': (context) => const IntroPage(),
        '/shop_pages': (context) => const ShopPage(),
        '/cart_pages': (context) => const CartPage(),
      },
    );
  }
}
