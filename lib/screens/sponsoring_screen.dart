import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:zkmf2024_app/dto/sponsoring.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/cloudflare_image.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';

class SponsoringScreen extends StatefulWidget {
  const SponsoringScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SponsoringScreenState();
}

class _SponsoringScreenState extends State<SponsoringScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sponsoring"),
      ),
      body: FutureBuilder(
          future: fetchSponsoring(),
          builder: (BuildContext context, AsyncSnapshot<SponsoringDTO> snapshot) {
            if (snapshot.hasData) {
              var requireData = snapshot.requireData;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Hauptsponsorin",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    image(requireData.hauptsponsor.first.cloudflareId),
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Premium-Partner",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ResponsiveGridRow(
                        children: requireData.premium
                            .map((e) => ResponsiveGridCol(xs: 12, md: 6, child: image(e.cloudflareId)))
                            .toList()),
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Deluxe-Partner",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ResponsiveGridRow(
                        children: requireData.deluxe
                            .map((e) => ResponsiveGridCol(xs: 12, md: 6, child: image(e.cloudflareId)))
                            .toList()),
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Sponsor",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ResponsiveGridRow(
                        children: requireData.sponsor
                            .map((e) => ResponsiveGridCol(xs: 12, md: 6, child: image(e.cloudflareId)))
                            .toList()),
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Musikfan",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ResponsiveGridRow(
                        children: requireData.musikfan
                            .map((e) => ResponsiveGridCol(
                                xs: 6,
                                child: image(e.cloudflareId, const EdgeInsets.symmetric(vertical: 5, horizontal: 5))))
                            .toList()),
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Gönner",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ResponsiveGridRow(
                          children: requireData.goenner.map((e) => ResponsiveGridCol(child: Text(e.name))).toList()),
                    )
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const GeneralErrorWidget();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  CloudflareImage image(String? cloudflareId,
      [EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 30)]) {
    return CloudflareImage(
      cloudflareId: cloudflareId,
      backgroundColor: Colors.white,
      padding: padding,
    );
  }
}
