import 'package:flutter/material.dart';

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de imagen
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://phantom-elmundo.unidadeditorial.es/647dfec588ecbc704118394a2da06a54/crop/153x0/759x404/resize/414/f/jpg/assets/multimedia/imagenes/2020/03/30/15855939110237.jpg",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Filtro oscuro (Vignette)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.85),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: _contenido(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contenido(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min, // LÍNEA CORREGIDA AQUÍ
        children: [
          const Icon(Icons.auto_awesome_motion, color: Color(0xFFC5A059), size: 60),
          const SizedBox(height: 20),
          
          const Text(
            "ADVENTURE STREAM",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFC5A059),
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
          
          const SizedBox(height: 10),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(height: 1, width: 30, color: Colors.white24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "EXPLORA LO DESCONOCIDO",
                  style: TextStyle(color: Colors.white70, letterSpacing: 1.2, fontSize: 10),
                ),
              ),
              Container(height: 1, width: 30, color: Colors.white24),
            ],
          ),

          const SizedBox(height: 40),

          // Tarjeta Estilo Glassmorphism
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117).withOpacity(0.85),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: const Color(0xFFC5A059).withOpacity(0.4), width: 1),
            ),
            child: Column(
              children: [
                const Text(
                  "Vive la acción y el misterio de los tesoros perdidos. La mayor colección de expediciones en tus manos.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC5A059),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text("INICIAR EXPEDICIÓN", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                
                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white38),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/registro'),
                    child: const Text("CREAR CUENTA"),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          const Text(
            "v1.0.2 - Powered by Flutter",
            style: TextStyle(color: Colors.white24, fontSize: 10),
          )
        ],
      ),
    );
  }
}