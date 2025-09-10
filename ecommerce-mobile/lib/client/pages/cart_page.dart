import 'package:ecommerce/client/service/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    final cartService = context.read<CartService>();
    cartService.listCartItems(); // carrega o carrinho do backend
  }

  @override
  Widget build(BuildContext context) {
    // Observa mudanças no CartService
    final cartService = context.watch<CartService>();

    // Calcula o total
    double total = cartService.cartItems.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Carrinho"), centerTitle: true),
      body: cartService.cartItems.isEmpty
          ? const Center(child: Text("Carrinho vazio"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cartService.cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartService.cartItems[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: product.product.imagePath != null
                              ? Image.network(
                                  product.product.imagePath!,
                                  width: 40,
                                  height: 40,
                                )
                              : const Icon(Icons.image_not_supported),
                          title: Text(product.product.productName),
                          subtitle: Text(
                            "R\$ ${product.unitPrice.toStringAsFixed(2)}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  if (product.quantity > 1) {
                                    await cartService.updateCart(
                                      product.quantity - 1,
                                      product.product.id,
                                    );
                                  }
                                },
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                              Text("${product.quantity}"),
                              IconButton(
                                onPressed: () async {
                                  await cartService.updateCart(
                                    product.quantity + 1,
                                    product.product.id,
                                  );
                                },
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await cartService.removeToCart(
                                    product.product.id,
                                  );
                                },
                                icon: const Icon(
                                  Icons.restore_from_trash,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5),
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Total geral",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        "R\$ ${total.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final cartService = context.read<CartService>();
                          final errorMessage = await cartService.buyItemsCart(
                            0,
                          ); // passe o productId se necessário

                          if (errorMessage == null) {
                            // Sucesso
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Pedido concluído com sucesso!"),
                              ),
                            );
                          } else {
                            // Erro
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Você precisa adicionar seu endereço. Redirecionando...')),
                            );

                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.pushNamed(context, '/address_page');
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Concluir pedido",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
