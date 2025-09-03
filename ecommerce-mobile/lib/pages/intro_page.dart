import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../components/my_button.dart';
import '../service/user_logado.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            SvgPicture.asset(
              'assets/icons/cow-auth.svg',
              width: 72,
              height: 72,
            ),

            const SizedBox(height: 25),

            // title
            Text(
              'Ecommerce Lacteo',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),

            // subtitle
            Text(
              'Os Melhores Produtos da Região',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),

            const SizedBox(height: 10),

            // button
            MyButton(
              onTap: () async {
                bool logado = await estaLogado();

                if (!logado) {
                  Navigator.pushNamed(context, '/login_page');
                } else {
                  Navigator.pushNamed(context, '/shop_pages');
                }
              },
              child: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }
}
