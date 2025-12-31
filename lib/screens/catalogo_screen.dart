import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aventura_flutter/screens/reproduccion_screen.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  
  final User? _usuarioActual = FirebaseAuth.instance.currentUser;
  Map<dynamic, dynamic>? _datosUsuario;

  @override
  void initState() {
    super.initState();
    _escucharDatosUsuario();
  }

  void _escucharDatosUsuario() {
    if (_usuarioActual != null) {
      _dbRef.child('usuarios/${_usuarioActual.uid}').onValue.listen((event) {
        if (mounted) {
          setState(() {
            _datosUsuario = event.snapshot.value as Map<dynamic, dynamic>?;
          });
        }
      });
    }
  }

  Future<void> cerrarSesion() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _mostrarDetalles(BuildContext context, dynamic peli) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161B22),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    peli["titulo"]?.toUpperCase() ?? "DETALLES",
                    style: const TextStyle(
                      color: Color(0xFFC5A059),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white38),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          peli["año"]?.toString() ?? "2024", 
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text("HD", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "DESCRIPCIÓN",
                    style: TextStyle(color: Color(0xFFC5A059), fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    peli["descripcion"] ?? "No hay descripción disponible.",
                    style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "PRODUCTOS RELACIONADOS",
                    style: TextStyle(color: Color(0xFFC5A059), fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    peli["productos"] ?? "Equipamiento estándar de expedición.",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReproduccionScreen(pelicula: peli)),
                        );
                      },
                      icon: const Icon(Icons.play_arrow, size: 28),
                      label: const Text("VER AHORA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC5A059),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      //DRAWER ---
      endDrawer: _construirMenuPerfil(),
      appBar: AppBar(
        title: const Text("EXPEDICIONES", 
          style: TextStyle(color: Color(0xFFC5A059), fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0D1117),
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openEndDrawer(), 
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 8, bottom: 8),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFC5A059).withOpacity(0.3),
                  backgroundImage: _datosUsuario != null && _datosUsuario!['fotoPerfil'] != null
                      ? NetworkImage(_datosUsuario!['fotoPerfil'])
                      : null,
                  child: _datosUsuario == null || _datosUsuario!['fotoPerfil'] == null
                      ? const Icon(Icons.person, color: Color(0xFFC5A059))
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _dbRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Error de conexión", style: TextStyle(color: Colors.white)));

          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            final Map<dynamic, dynamic> baseDatos = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            List<dynamic> todasLasPeliculas = [];

            baseDatos.forEach((key, value) {
              if (key != 'usuarios') {
                if (value is List) {
                  todasLasPeliculas.addAll(value.where((item) => item != null));
                } else if (value is Map) {
                  todasLasPeliculas.addAll(value.values);
                }
              }
            });

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65, 
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: todasLasPeliculas.length,
              itemBuilder: (context, index) => _tarjetaPelicula(context, todasLasPeliculas[index]),
            );
          }
          return const Center(child: CircularProgressIndicator(color: Color(0xFFC5A059)));
        },
      ),
    );
  }

  // WIDGET PARA EL MENU LATERAL
  Widget _construirMenuPerfil() {
    return Drawer(
      backgroundColor: const Color(0xFF0D1117),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF161B22)),
            currentAccountPicture: CircleAvatar(
              backgroundImage: _datosUsuario != null && _datosUsuario!['fotoPerfil'] != null
                  ? NetworkImage(_datosUsuario!['fotoPerfil'])
                  : null,
            ),
            accountName: Text(_datosUsuario?['nombre'] ?? "Explorador", 
                style: const TextStyle(color: Color(0xFFC5A059), fontWeight: FontWeight.bold)),
            accountEmail: Text(_datosUsuario?['correo'] ?? _usuarioActual?.email ?? ""),
          ),
          ListTile(
            leading: const Icon(Icons.stars, color: Color(0xFFC5A059)),
            title: const Text("Rango", style: TextStyle(color: Colors.white)),
            subtitle: Text(_datosUsuario?['rango'] ?? "Novato", style: const TextStyle(color: Colors.white70)),
          ),
          const Divider(color: Colors.white24),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Cerrar Sesión", style: TextStyle(color: Colors.redAccent)),
            onTap: cerrarSesion,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _tarjetaPelicula(BuildContext context, dynamic peli) {
    final String titulo = peli["titulo"] ?? "Sin título";
    final String imagenUrl = peli["imagen"] ?? "https://via.placeholder.com/150";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReproduccionScreen(pelicula: peli)),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFC5A059).withOpacity(0.5), width: 1),
                image: DecorationImage(image: NetworkImage(imagenUrl), fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                titulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            IconButton(
              onPressed: () => _mostrarDetalles(context, peli),
              icon: const Icon(Icons.info_outline, color: Color(0xFFC5A059), size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }
}