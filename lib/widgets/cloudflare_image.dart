import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zkmf2024_app/constants.dart';

class CloudflareImage extends StatelessWidget {
  final String? cloudflareId;
  final Color? backgroundColor;
  final EdgeInsetsGeometry paddingOuter;
  final EdgeInsetsGeometry paddingInner;
  final BorderRadius borderRadius;

  const CloudflareImage(
      {super.key,
      this.cloudflareId,
      this.backgroundColor = Colors.transparent,
      this.paddingOuter = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      this.paddingInner = EdgeInsets.zero,
      this.borderRadius = const BorderRadius.all(Radius.circular(10))});

  @override
  Widget build(BuildContext context) {
    if (cloudflareId != null) {
      return Padding(
        padding: paddingOuter,
        child: Center(
          child: ClipRRect(
              borderRadius: borderRadius,
              child: Container(
                color: backgroundColor,
                padding: paddingInner,
                child: CachedNetworkImage(
                    imageUrl: '$cloudFlareUrl${cloudflareId!}/public',
                    progressIndicatorBuilder: (context, url, progress) =>
                        const Center(child: LinearProgressIndicator()),
                    fadeOutDuration: const Duration(milliseconds: 200),
                    fadeInDuration: const Duration(milliseconds: 200),
                    errorWidget: (context, url, error) => const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.error,
                                color: gelb,
                              ),
                            ),
                            Text("Bild konnte nicht geladen werden...")
                          ],
                        )),
              )),
        ),
      );
    } else {
      return Container();
    }
  }
}
