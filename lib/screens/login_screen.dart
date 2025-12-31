import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:aventura_flutter/screens/catalogo_screen.dart'; // Importante para la navegación directa

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginUsuario() async {
    try {
      // CORRECCIÓN: Usamos final para capturar la respuesta y evitar el error de PigeonUserDetails
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted && userCredential.user != null) {
        showDialog(
          context: context,
          barrierDismissible: false, 
          builder: (context) {
            return const AlertDialog(
              backgroundColor: Color(0xFF0D1117),
              title: Text("Felicidades", style: TextStyle(color: Color(0xFFC5A059))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Inicio de sesión exitoso", style: TextStyle(color: Colors.white)),
                  SizedBox(height: 10),
                  Text("Redirigiendo a la expedición...", style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 20),
                  CircularProgressIndicator(color: Color(0xFFC5A059)),
                ],
              ),
            );
          },
        );

        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          Navigator.pop(context); // Cierra el diálogo
          // Navegación directa para asegurar que entre al catálogo
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => const CatalogoScreen())
          ); 
        }
      }
    } on FirebaseAuthException catch (_) {
      const errorMsg = "Credenciales Incorrectas";
      if (mounted) {
        _mostrarError(errorMsg);
      }
    }
  }

  void _mostrarError(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D1117),
        title: const Text("Error", style: TextStyle(color: Colors.redAccent)),
        content: Text(msg, style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Reintentar", style: TextStyle(color: Color(0xFFC5A059))),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://i.pinimg.com/736x/a7/84/63/a7846386298ad20f01e64ead89f053b3.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.55),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: _contenidoLogin(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _contenidoLogin(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xEC0D1117),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFC5A059), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shield_moon_outlined, size: 50, color: Color(0xFFC5A059)),
            const SizedBox(height: 16),
            const Text("Acceso de Explorador", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFC5A059), fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Correo electrónico", labelStyle: TextStyle(color: Colors.white70), prefixIcon: Icon(Icons.email_outlined, color: Color(0xFFC5A059))),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Contraseña", labelStyle: TextStyle(color: Colors.white70), prefixIcon: Icon(Icons.key_outlined, color: Color(0xFFC5A059))),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFFC5A059), foregroundColor: Colors.black87),
                onPressed: loginUsuario, 
                child: const Text("INICIAR SESIÓN"),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/registro'), 
              child: const Text("¿Eres nuevo? Únete a la expedición", style: TextStyle(color: Color(0xFF50D0DA))),
            ),
          ],
        ),
      ),
    );
  }
}