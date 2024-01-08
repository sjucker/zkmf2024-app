import 'package:flutter/material.dart';
import 'package:zkmf2024_app/constants.dart';

class CloudflareImage extends StatelessWidget {
  final String? cloudflareId;

  const CloudflareImage({super.key, this.cloudflareId});

  @override
  Widget build(BuildContext context) {
    if (cloudflareId != null) {
      return ListTile(
        title: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              '$cloudFlareUrl${cloudflareId!}/public',
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return const Center(child: LinearProgressIndicator());
                }
              },
            )),
      );
    } else {
      return Container();
    }
  }
}
