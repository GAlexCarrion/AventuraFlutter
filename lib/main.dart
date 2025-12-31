import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:aventura_flutter/screens/bienvenida_screen.dart';
import 'package:aventura_flutter/screens/login_screen.dart';
import 'package:aventura_flutter/screens/register_screen.dart';
import 'package:aventura_flutter/screens/catalogo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(const AppProyecto());
}

class AppProyecto extends StatelessWidget {
  const AppProyecto({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aventura Flutter',
      initialRoute: '/',
      routes: {
        '/': (context) => const BienvenidaScreen(),
        '/login': (context) => const LoginScreen(),
        '/registro': (context) => const RegisterScreen(),
        '/catalogo': (context) => const CatalogoScreen(),
        // NOTA: No registramos '/reproduccion' aquí porque 
        // pasamos el objeto directamente en el Navigator.push del Catálogo.
      },
    );
  }
}