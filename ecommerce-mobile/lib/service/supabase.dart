
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> conexaoSupabase() async {
  await Supabase.initialize(
    url: 'https://psxqhduizzmlhurlqolp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBzeHFoZHVpenptbGh1cmxxb2xwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4NDQ4OTAsImV4cCI6MjA3MjQyMDg5MH0.docXjxKhbShpUguOogH02na_ps23CB4-IjxR2CyDSC0',
  );
}
