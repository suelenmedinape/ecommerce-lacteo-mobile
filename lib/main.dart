import 'package:ecommerce/models/shop.dart';
import 'package:ecommerce/register_screen.dart';
import 'package:ecommerce/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{

  await Supabase.initialize(
    url: 'https://xsvtsnkebbeskfhbnzfk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhzdnRzbmtlYmJlc2tmaGJuemZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUwMzQxOTIsImV4cCI6MjA3MDYxMDE5Mn0.VpAWm2Ms_sWdxoAMJY8ZghUsFBu47rQrHZmdqrweMUc',
  );

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
      home: const RegisterScreen(), // voltar para o que era, pois esqueci qual tela tu tava chamando
      theme: appColor,
      /*routes: {
        '/intro_page': (context) => const IntroPage(),
        '/shop_pages': (context) => const ShopPage(),
        '/cart_pages': (context) => const CartPage(),
      },*/
    );
  }
}
