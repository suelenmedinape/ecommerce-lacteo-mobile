
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> conexaoSupabase() async {
  await Supabase.initialize(
    url: 'https://xsvtsnkebbeskfhbnzfk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhzdnRzbmtlYmJlc2tmaGJuemZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUwMzQxOTIsImV4cCI6MjA3MDYxMDE5Mn0.VpAWm2Ms_sWdxoAMJY8ZghUsFBu47rQrHZmdqrweMUc',
  );
}
