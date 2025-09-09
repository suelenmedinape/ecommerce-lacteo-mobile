import 'package:shared_preferences/shared_preferences.dart';

Future<void> salvarLogin(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
}

Future<bool> estaLogado() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.containsKey('auth_token');
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token'); 
}

Future<String?> getRole() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_role');
}