import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReproduccionScreen extends StatefulWidget {
  final Map pelicula;

  const ReproduccionScreen({super.key, required this.pelicula});

  @override
  State<ReproduccionScreen> createState() => _ReproduccionScreenState();
}

class _ReproduccionScreenState extends State<ReproduccionScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.pelicula["video"] ?? ""),
    )..initialize().then((_) {
        setState(() {});
        _controller.play(); 
      });
  }

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117), 
      appBar: AppBar(
        title: Text(
          widget.pelicula["titulo"],
          style: const TextStyle(color: Color(0xFFC5A059)),
        ),
        backgroundColor: const Color(0xFF0D1117),
        iconTheme: const IconThemeData(color: Color(0xFFC5A059)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ÁREA DEL VIDEO
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child: _controller.value.isInitialized
                    ? Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          VideoPlayer(_controller),
                          VideoProgressIndicator(
                            _controller,
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              playedColor: Color(0xFFC5A059),
                              bufferedColor: Colors.white24,
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(color: Color(0xFFC5A059)),
                      ),
              ),
            ),
            
            // BOTONES DE CONTROL
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _controller.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
                      color: const Color(0xFFC5A059),
                      size: 50,
                    ),
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying ? _controller.pause() : _controller.play();
                      });
                    },
                  ),
                ],
              ),
            ),

            // INFORMACION DE LA PELÍCULA
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SINOPSIS",
                    style: TextStyle(
                      color: Color(0xFFC5A059),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.pelicula["descripcion"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}