// Em profile_page.dart
import 'package:ecommerce/all/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/client_service.dart';

// 1. Converter para StatefulWidget
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // 2. Adicionar o initState para carregar os dados
  @override
  void initState() {
    super.initState();
    // Garante que o carregamento dos dados seja chamado ao entrar na tela
    Future.microtask(() {
      // Usamos 'read' aqui para apenas disparar a ação, sem ouvir por mudanças
      context.read<ClientService>().clientDetail();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 'watch' irá reconstruir a tela quando os dados chegarem
    final clientService = context.watch<ClientService>();
    final client = clientService.client;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      // 3. O resto do seu build() continua aqui, sem alterações...
      body: clientService.loading && client == null
          ? const Center(child: CircularProgressIndicator())
          : client == null
          ? const Center(child: Text("Erro ao carregar dados do perfil."))
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    _buildInfoCard(
                      icon: Icons.person_outline,
                      label: "Nome completo",
                      value: client.name,
                    ),
                    const SizedBox(height: 15),
                    _buildInfoCard(
                      icon: Icons.email_outlined,
                      label: "E-mail",
                      value: client.email,
                    ),
                    const SizedBox(height: 15),
                    _buildInfoCard(
                      icon: Icons.phone_outlined,
                      label: "Telefone",
                      value: client.phone!,
                    ),
                    const SizedBox(height: 15),
                    _buildInfoCard(
                      icon: Icons.credit_card_outlined,
                      label: "CPF",
                      value: client.cpf!,
                    ),
                    const SizedBox(height: 15),
                    _buildInfoCard(
                      icon: Icons.home_outlined,
                      label: "Endereço",
                      value:
                          "${client.address?.street}, ${client.address?.number}\n"
                          "${client.address?.neighborhood}\n"
                          "${client.address?.city} - ${client.address?.state}",
                    ),
                    const SizedBox(height: 15),
                    MyButtonAuth(
  onTap: () {
    // Passar `true` significa que queremos editar os dados existentes.
    Navigator.pushNamed(context, '/address_page', arguments: true);
  },
  textButtonName: 'Editar Informações',
),
                  ],
                ),
              ),
            ),
    );
  }

  // Seu método _buildInfoCard permanece igual
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    // ... seu código do card ...
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.amber),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value.isNotEmpty ? value : "—",
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
