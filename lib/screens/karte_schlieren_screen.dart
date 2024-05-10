import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

class KarteSchlierenScreen extends StatelessWidget {
  const KarteSchlierenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Karte Festareal - Schlieren"),
        actions: homeAction(context),
      ),
      body: ClipRect(
        child: PhotoView(
          imageProvider:
              const CachedNetworkImageProvider('${cloudFlareUrl}c5103f8a-75a3-4e1f-d6e0-169d30049e00/public'),
          backgroundDecoration: const BoxDecoration(color: blau),
        ),
      ),
    );
  }
}
