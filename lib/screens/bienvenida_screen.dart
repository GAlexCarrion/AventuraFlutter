import 'package:flutter/material.dart';

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            // Imagen de fondo: Selva/Montaña estilo expedición
            image: NetworkImage(
              "https://phantom-elmundo.unidadeditorial.es/647dfec588ecbc704118394a2da06a54/crop/153x0/759x404/resize/414/f/jpg/assets/multimedia/imagenes/2020/03/30/15855939110237.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // Añadimos un pequeño degradado oscuro general para que no brille tanto el fondo
          color: Colors.black.withOpacity(0.3),
          child: SafeArea(
            child: Center(
              child: _contenido(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _contenido(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color.fromARGB(210, 13, 17, 23), 
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFC5A059), width: 1.5), 
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "AdventureStream",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFC5A059),
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Descubre lo inexplorado.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white, 
                fontSize: 18,
                fontStyle: FontStyle.italic
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Únete a las expediciones más grandes de la historia. Vive la acción y el misterio de los tesoros perdidos en alta definición.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 32),

            // BOTÓN LOGIN (Ahora usa Rutas Nombradas)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFC5A059),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                // USAMOS EL NOMBRE DE LA RUTA
                onPressed: () => Navigator.pushNamed(context, '/login'),
                icon: const Icon(Icons.explore, color: Colors.black87),
                label: const Text(
                  "INICIAR EXPEDICIÓN",
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // BOTÓN REGISTER (Ahora usa Rutas Nombradas)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/registro'),
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text("CREAR CUENTA"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}