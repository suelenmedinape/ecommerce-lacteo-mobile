import 'package:ecommerce/all/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../all/components/my_button.dart';
import '../service/client_service.dart';

import 'package:provider/provider.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final cpfController = TextEditingController();
  final streetController = TextEditingController();
  final numberController = TextEditingController();
  final cityController = TextEditingController();
  final neighborhoodController = TextEditingController();
  final stateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // busca os dados do cliente quando abrir a tela
    Future.microtask(() async {
      final clientService = context.read<ClientService>();
      await clientService.clientDetails();

      // quando os dados chegarem, preenche os controllers
      final data = clientService.client;
      if (data != null) {
        nameController.text = data['name'] ?? '';
        phoneController.text = data['phone'] ?? '';
        cpfController.text = data['cpf'] ?? '';

        if (data['address'] != null) {
          streetController.text = data['address']['street'] ?? '';
          numberController.text = data['address']['number'] ?? '';
          cityController.text = data['address']['city'] ?? '';
          neighborhoodController.text = data['address']['neighborhood'] ?? '';
          stateController.text = data['address']['state'] ?? '';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final clientService = context.watch<ClientService>();

    if (clientService.loading && clientService.client == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Meus Dados")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 50),
              // logo
              SvgPicture.asset(
                'assets/icons/cow-auth.svg',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 50),
              MyTextFormField(
                controller: nameController,
                hintText: "Nome",
                obscureText: false,
              ),
              const SizedBox(height: 15),
              MyTextFormField(
                controller: phoneController,
                hintText: "Telefone",
                obscureText: false,
              ),
              const SizedBox(height: 15),
              MyTextFormField(
                controller: cpfController,
                hintText: "CPF",
                obscureText: false,
              ),
              const SizedBox(height: 15),
              MyTextFormField(
                controller: streetController,
                hintText: "Rua",
                obscureText: false,
              ),
              const SizedBox(height: 15),
              MyTextFormField(
                controller: numberController,
                hintText: "Número",
                obscureText: false,
              ),
              const SizedBox(height: 15),
              MyTextFormField(
                controller: cityController,
                hintText: "Cidade",
                obscureText: false,
              ),
              const SizedBox(height: 15),
              MyTextFormField(
                controller: neighborhoodController,
                hintText: "Bairro",
                obscureText: false,
              ),
              const SizedBox(height: 15),
              MyTextFormField(
                controller: stateController,
                hintText: "Estado",
                obscureText: false,
              ),
              const SizedBox(height: 20),

              MyButtonAuth(
                textButtonName: "Salvar",
                loading: clientService.loading,
                onTap: () async {
                  final updated = await clientService.updateDetailsClient({
                    "name": nameController.text,
                    "phone": phoneController.text,
                    "cpf": cpfController.text,
                    "address": {
                      "street": streetController.text,
                      "number": numberController.text,
                      "city": cityController.text,
                      "neighborhood": neighborhoodController.text,
                      "state": stateController.text,
                    },
                  });

                  if (updated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Dados atualizados com sucesso! Retornando ao Carrinho..."),
                      ),
                    );
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pushNamed(context, '/cart_pages');
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
