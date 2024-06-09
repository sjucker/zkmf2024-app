import 'package:cached_network_image/cached_network_image.dart';
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
          imageProvider:
              const CachedNetworkImageProvider('${cloudFlareUrl}b3a8bf80-1479-4847-6c93-e06e3430d700/public'),
          backgroundDecoration: const BoxDecoration(color: blau),
        ),
      ),
    );
  }
}
