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

  // 1. Declare a variável como um membro da classe State.
  // Inicia como `false` por padrão.
  bool _isEditingAddress = false;
  bool _isDataInitialized = false;

  @override
void didChangeDependencies() {
  super.didChangeDependencies();

  if (!_isDataInitialized) {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    // Se for true, entra no modo de edição
    if (arguments is bool && arguments == true) {
      setState(() {
        _isEditingAddress = true;
      });
    }

    // 🔹 Sempre tenta carregar os dados do cliente
    _loadClientData();

    _isDataInitialized = true;
  }
}

  // Método para carregar os dados do cliente e preencher os campos
  Future<void> _loadClientData() async {
  final clientService = context.read<ClientService>();

  if (clientService.client == null) {
    await clientService.clientDetail();
  }

  final clientData = clientService.client;
  if (clientData != null && mounted) {
    nameController.text = clientData.name;
    phoneController.text = clientData.phone ?? '';
    cpfController.text = clientData.cpf ?? '';

    if (clientData.address != null) {
      streetController.text = clientData.address!.street;
      numberController.text = clientData.address!.number; // <- deixe como String
      cityController.text = clientData.address!.city;
      neighborhoodController.text = clientData.address!.neighborhood;
      stateController.text = clientData.address!.state;
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final clientService = context.watch<ClientService>();

    // Define o título da página dinamicamente
    final pageTitle = _isEditingAddress
        ? "Editar Meus Dados"
        : "Adicionar Novo Endereço";

    if (clientService.loading &&
        _isEditingAddress &&
        clientService.client == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 50),
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
              // ... resto dos seus TextFormFields
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
                  // O mapa de dados continua o mesmo
                  final clientData = {
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
                  };

                  // 1. A variável agora é 'response' e armazena o ApiResponse
                  final response = await clientService.updateDetailsClient(
                    clientData,
                  );

                  // É uma boa prática verificar se o widget ainda está montado logo após o 'await'
                  if (!mounted) return;

                  // 2. Verifique a propriedade 'hasError' da resposta
                  if (response.hasError) {
                    // Se deu ERRO, mostre a mensagem de erro específica do backend
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(response.errorMessage!),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  } else {
                    // Se deu SUCESSO, mostre a mensagem de sucesso do backend
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(response.successMessage!),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // 3. A navegação acontece apenas no caso de sucesso
                    Navigator.pop(context);
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
