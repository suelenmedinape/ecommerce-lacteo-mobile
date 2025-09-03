import 'package:ecommerce/models/shop.dart';
import 'package:ecommerce/pages/intro_page.dart';
import 'package:ecommerce/pages/login_page.dart';
import 'package:ecommerce/pages/register_page.dart';
import 'package:ecommerce/register_screen.dart';
import 'package:ecommerce/service/register_service.dart';
import 'package:ecommerce/service/supabase.dart';
import 'package:ecommerce/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/cart_page.dart';
import 'pages/shop_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await conexaoSupabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Shop()),
        ChangeNotifierProvider(create: (_) => RegisterService()),
      ],
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
        '/login_page': (context) => LoginPage(),
        '/register_page': (context) => RegisterPage()
      },
    );
  }
}
