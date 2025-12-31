import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  XFile? _imagen;
  bool _estaCargando = false;

  Future<void> _obtenerImagen(ImageSource fuente) async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagenSeleccionada = await picker.pickImage(
      source: fuente, 
      imageQuality: 50, 
    );
    
    if (imagenSeleccionada != null) {
      setState(() {
        _imagen = imagenSeleccionada;
      });
    }
  }

  void _mostrarOpcionesCamara() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1117),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Color(0xFFC5A059)),
            title: const Text("Tomar Foto (Cámara)", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _obtenerImagen(ImageSource.camera); // ABRE LA CAMARA
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Color(0xFFC5A059)),
            title: const Text("Elegir de Galería", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _obtenerImagen(ImageSource.gallery); // ABRE LA GALERIA
            },
          ),
        ],
      ),
    );
  }

  Future<void> _registrarUsuario() async {
    if (_nombreController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _mostrarMensaje("Por favor, llena todos los campos");
      return;
    }

    setState(() => _estaCargando = true);

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;
      String? fotoUrl;

      if (_imagen != null) {
        final file = File(_imagen!.path);
        final supabase = Supabase.instance.client;

        await supabase.storage.from('fotoPerfil').upload(
          '$uid.png',
          file,
          fileOptions: const FileOptions(upsert: true, contentType: 'image/png'),
        );

        fotoUrl = supabase.storage.from('fotoPerfil').getPublicUrl('$uid.png');
      } else {
        fotoUrl = "https://cdn-icons-png.flaticon.com/512/1154/1154446.png";
      }

      DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('usuarios');
      await dbRef.child(uid).set({
        "nombre": _nombreController.text.trim(),
        "correo": _emailController.text.trim(),
        "fotoPerfil": fotoUrl,
        "fecha_registro": DateTime.now().toIso8601String(),
        "rango": "Explorador Novato",
      });

      if (mounted) {
        _mostrarExito(); 
      }
    } on FirebaseAuthException catch (e) {
      _mostrarMensaje(e.message ?? "Error al registrar");
    } finally {
      if (mounted) setState(() => _estaCargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Stack(
        children: [
          _buildFondo(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(child: _buildFormulario()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFondo() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&q=80"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
      ),
    );
  }

  Widget _buildFormulario() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117).withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFC5A059), width: 1.5),
        ),
        child: Column(
          children: [
            const Text("UNIRSE A LA AVENTURA", 
              style: TextStyle(color: Color(0xFFC5A059), fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const SizedBox(height: 25),
            
            GestureDetector(
              onTap: _mostrarOpcionesCamara, 
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: const Color(0xFFC5A059),
                    backgroundImage: _imagen != null ? FileImage(File(_imagen!.path)) : null,
                    child: _imagen == null 
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.black) 
                      : null,
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15,
                    child: Icon(Icons.add, size: 20, color: Colors.black),
                  )
                ],
              ),
            ),
            const SizedBox(height: 25),
            _inputField("Nombre", Icons.person_outline, _nombreController),
            const SizedBox(height: 15),
            _inputField("Correo", Icons.email_outlined, _emailController),
            const SizedBox(height: 15),
            _inputField("Contraseña", Icons.lock_outline, _passwordController, obscure: true),
            const SizedBox(height: 35),
            _estaCargando 
              ? const CircularProgressIndicator(color: Color(0xFFC5A059))
              : _buildBotonRegistro(),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonRegistro() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC5A059),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _registrarUsuario,
        child: const Text("REGISTRARSE", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _inputField(String label, IconData icon, TextEditingController controller, {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: const Color(0xFFC5A059)),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFC5A059))),
      ),
    );
  }

  void _mostrarMensaje(String txt) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(txt)));
  }

  void _mostrarExito() {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D1117),
        title: const Text("¡Éxito!", style: TextStyle(color: Color(0xFFC5A059))),
        content: const Text("Ya eres parte de AventuraFlutter. Inicia sesión para comenzar."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cierra el diálogo
              Navigator.pushReplacementNamed(context, '/login'); 
            }, 
            child: const Text("ACEPTAR", style: TextStyle(color: Color(0xFFC5A059)))
          )
        ],
      ),
    );
  }
}