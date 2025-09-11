import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

Future<String?> getUserRoleFromToken() async {
  final supabase = Supabase.instance.client;
  
  final Session? session = supabase.auth.currentSession;
  
  if (session == null) {
    return null;
  }
  
  final String accessToken = session.accessToken;
  
  try {
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
    
    final userMetadata = decodedToken['user_metadata'];
    
    if (userMetadata != null && userMetadata['role'] != null) {
      return userMetadata['role'] as String;
    } else {
      return null;
    }
  } catch (e) {
    print('Erro ao decodificar o token: $e');
    return null;
  }
}