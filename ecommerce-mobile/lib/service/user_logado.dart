import 'package:shared_preferences/shared_preferences.dart';

// Salvar login
Future<void> salvarLogin(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
}

// Verificar se está logado
Future<bool> estaLogado() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.containsKey('auth_token');
}

// Remover login (logout)
Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
}
