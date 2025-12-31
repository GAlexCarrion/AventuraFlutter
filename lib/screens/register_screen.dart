import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> registrarUsuario() async {
    try {
      // CORRECCIÓN: Usamos final para evitar el error de PigeonUserDetails
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;

        // Guardar en Realtime Database
        DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('usuarios');
        await dbRef.child(uid).set({
          "nombre": _nombreController.text.trim(),
          "correo": _emailController.text.trim(),
          "fecha_registro": DateTime.now().toIso8601String(),
          "rango": "Explorador Novato",
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("¡Registro exitoso! Bienvenido explorador.")),
          );
          Navigator.pop(context); 
        }
      }
    } on FirebaseAuthException catch (e) {
      String mensaje = "Error en el registro";
      if (e.code == 'weak-password') mensaje = "La contraseña es muy débil";
      if (e.code == 'email-already-in-use') mensaje = "El correo ya existe";
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://i.pinimg.com/736x/1a/10/72/1a10720b00b3c1f780de2dd3663d6722.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: _formularioRegistro(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formularioRegistro() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color.fromARGB(199, 1, 1, 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Registro", style: TextStyle(color: Colors.redAccent, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: "Nombre", labelStyle: TextStyle(color: Colors.white), prefixIcon: Icon(Icons.person, color: Colors.white)),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Correo", labelStyle: TextStyle(color: Colors.white), prefixIcon: Icon(Icons.email, color: Colors.white)),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Contraseña", labelStyle: TextStyle(color: Colors.white), prefixIcon: Icon(Icons.lock, color: Colors.white)),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(158, 32, 32, 1))),
                onPressed: registrarUsuario, 
                child: const Text("Registrarse"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}