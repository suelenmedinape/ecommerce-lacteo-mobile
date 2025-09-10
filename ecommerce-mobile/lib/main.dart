import 'package:ecommerce/client/pages/byCategory_page.dart';
import 'package:ecommerce/client/pages/cart_page.dart';
import 'package:ecommerce/client/pages/shop_page.dart';
import 'package:ecommerce/client/service/cart_service.dart';
import 'package:ecommerce/client/service/client_service.dart';
import 'package:ecommerce/client/service/product_service.dart';
import 'package:ecommerce/product_upload_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'all/pages/intro_page.dart';
import 'all/pages/login_page.dart';
import 'all/pages/register_page.dart';
import 'all/service/auth_service.dart';
import 'all/service/supabase.dart';
import 'all/themes/app_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await conexaoSupabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_) => RegisterService()),
        ChangeNotifierProvider(create: (_) => LoginService()),
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => ClientService())
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
        '/login_page': (context) => LoginPage(),
        '/register_page': (context) => RegisterPage(),
        '/shop_pages': (context) => ShopPage(),
        '/byCategory_page': (context) => Bycategory(),
        '/product/insert': (context) => ProductUploadTestScreen(),
        '/cart_pages': (context) => CartPage()
        // '//productor_page': (context) => ??
      },
    );
  }
}
