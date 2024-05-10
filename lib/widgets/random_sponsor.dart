import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/cloudflare_image.dart';

class RandomSponsor extends StatelessWidget {
  const RandomSponsor({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchRandomSponsor(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              const Divider(),
              const Text("Sponsor"),
              InkWell(
                child: CloudflareImage(
                  cloudflareId: snapshot.requireData.cloudflareId,
                  backgroundColor: Colors.white,
                  paddingInner: const EdgeInsets.symmetric(vertical: 0, horizontal: 80),
                ),
                onTap: () {
                  if (snapshot.requireData.url != null) {
                    launchUrl(Uri.parse(snapshot.requireData.url!));
                  }
                },
              ),
            ],
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
