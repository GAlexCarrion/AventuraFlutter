import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

//pantallas
import 'screens/bienvenida_screen.dart'; 
import 'screens/register_screen.dart';
import 'screens/login_screen.dart'; 
import 'screens/catalogo_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: 'https://bjfuujarglzomagebqsa.supabase.co',
    anonKey: 'sb_publishable_GAShKGml7TZ1x_fgVS76pQ_789Bzl92', 
  );

  runApp(const AppAventura());
}

class AppAventura extends StatelessWidget {
  const AppAventura({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AventuraFlutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      
      initialRoute: '/', 
      routes: {
        '/': (context) => const BienvenidaScreen(), 
        '/registro': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(), 
        '/catalogo': (context) => const CatalogoScreen(),
      },
    );
  }
}