import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

class KarteUrdorfScreen extends StatelessWidget {
  const KarteUrdorfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Karte Festareal - Urdorf"),
        actions: homeAction(context),
      ),
      body: ClipRect(
        child: PhotoView(
          imageProvider: const AssetImage("assets/karte-urdorf.jpg"),
          backgroundDecoration: const BoxDecoration(color: blau),
        ),
      ),
    );
  }
}
