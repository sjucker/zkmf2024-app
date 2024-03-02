import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:zkmf2024_app/constants.dart';

class KarteSchlierenScreen extends StatelessWidget {
  const KarteSchlierenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Karte Festareal - Schlieren"),
      ),
      body: ClipRect(
        child: PhotoView(
          imageProvider: const AssetImage("assets/karte-schlieren.jpg"),
          backgroundDecoration: const BoxDecoration(color: blau),
        ),
      ),
    );
  }
}
