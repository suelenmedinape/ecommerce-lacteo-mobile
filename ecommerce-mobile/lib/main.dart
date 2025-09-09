import 'package:ecommerce/client/pages/byCategory.dart';
import 'package:ecommerce/client/pages/shop_page.dart';
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
        ChangeNotifierProvider(create: (_) => RegisterService()),
        ChangeNotifierProvider(create: (_) => LoginService())
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
        '/byCategory': (context) => Bycategory()
        // '//productor_page': (context) => ??
      },
    );
  }
}
