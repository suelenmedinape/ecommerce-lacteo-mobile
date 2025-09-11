import 'package:ecommerce/all/components/my_list_tile.dart';
import 'package:ecommerce/all/service/auth_service.dart';
import 'package:ecommerce/client/service/client_service.dart';
import 'package:ecommerce/client/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/responses.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Instanciar os services aqui é ok, já que são usados pontualmente
    final ProductService productService = ProductService();
    final LoginService loginService = LoginService();

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: Column(
        children: [
          // ALTERAÇÃO: Substituímos toda a lógica do cabeçalho
          // por um widget dedicado e limpo.
          const _DrawerHeader(),

          // 🔹 itens da lista (o resto do seu código permanece igual)
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                MyListTile(
                  text: 'Profile',
                  icon: Icons.person_outline, // Ícone mais apropriado
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile_page');
                  },
                ),
                MyListTile(
                  text: 'Shop',
                  icon: Icons.store_outlined, // Ícone mais apropriado
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/shop_pages');
                  },
                ),
                MyListTile(
                  text: 'Cart',
                  icon: Icons.shopping_cart_outlined,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/cart_pages');
                  },
                ),
                // 🔹 categorias
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  // 1. Mude o tipo para esperar um ApiResponse que contém uma lista de Strings
                  child: FutureBuilder<ApiResponse<List<String>>>(
                    future: productService.listCategory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      // Erro de conexão/rede (o Future em si falhou)
                      else if (snapshot.hasError) {
                        return Text('Erro: ${snapshot.error}');
                      }
                      // O Future completou, agora verificamos o ApiResponse
                      else if (snapshot.hasData) {
                        // 2. Acesse o ApiResponse a partir do snapshot
                        final apiResponse = snapshot.data!;

                        // 3. VERIFIQUE SE HÁ ERRO LÓGICO DENTRO DA RESPOSTA
                        if (apiResponse.hasError) {
                          return Text('Erro: ${apiResponse.errorMessage!}');
                        }

                        // 4. Se não houver erro, pegue a lista de dados de dentro do ApiResponse
                        final categories = apiResponse.data!;

                        // A partir daqui, seu código continua o mesmo, pois 'categories' é a lista
                        return ExpansionTile(
                          leading: const Icon(
                            Icons.category,
                            color: Colors.grey,
                          ),
                          title: const Text('Categorias'),
                          children: categories.map((category) {
                            return MyListTile(
                              text: category,
                              icon: Icons.label_important_outline,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                  context,
                                  '/byCategory_page',
                                  arguments: category,
                                );
                              },
                            );
                          }).toList(),
                        );
                      } else {
                        return const Text('Nenhuma categoria encontrada.');
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

// WIDGET ADICIONADO: Responsável por carregar e exibir o cabeçalho
class _DrawerHeader extends StatefulWidget {
  const _DrawerHeader();

  @override
  State<_DrawerHeader> createState() => _DrawerHeaderState();
}

class _DrawerHeaderState extends State<_DrawerHeader> {
  @override
  void initState() {
    super.initState();
    // Garante que os dados do cliente sejam carregados assim que o Drawer for construído
    Future.microtask(() {
      context.read<ClientService>().clientDetail();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Usamos 'watch' para que o widget reconstrua quando os dados chegarem
    final clientService = context.watch<ClientService>();
    final client = clientService.client;

    // A lógica de UI que estava no Column agora está aqui
    if (clientService.loading && client == null) {
      return const SizedBox(
        height: 120, // Altura fixa para não "pular" a UI
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (client == null) {
      return const SizedBox(
        height: 120,
        child: Center(child: Text("Bem-vindo(a)!")),
      );
    }

    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              child: Text(
                client.name.isNotEmpty ? client.name[0].toUpperCase() : "U",
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 12),
            // Usamos Flexible para evitar overflow se o nome/email for muito longo
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    client.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    client.email,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
