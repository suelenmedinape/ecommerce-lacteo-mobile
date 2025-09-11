import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Use a mesma chave para salvar e buscar!
const String _authTokenKey = 'flutter.auth_token';

Future<void> salvarLogin(String token) async {
  final prefs = await SharedPreferences.getInstance();
  // Salva na mesma chave que o Supabase usa.
  await prefs.setString(_authTokenKey, token); 
}

Future<bool> estaLogado() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.containsKey(_authTokenKey);
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_authTokenKey);
  // É uma boa prática também fazer logout do Supabase.
  await Supabase.instance.client.auth.signOut();
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString(_authTokenKey); 

  if (token != null) {
    // *** A CORREÇÃO PRINCIPAL ESTÁ AQUI ***
    // Se o token começar e terminar com aspas, remova-as.
    if (token.startsWith('"') && token.endsWith('"')) {
      token = token.substring(1, token.length - 1);
    }
  }
  
  return token;
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