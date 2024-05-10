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
              const CachedNetworkImageProvider('${cloudFlareUrl}e9b37972-3cb2-46f7-118b-cd6c780eda00/public'),
          backgroundDecoration: const BoxDecoration(color: blau),
        ),
      ),
    );
  }
}
