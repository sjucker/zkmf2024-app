import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zkmf2024_app/dto/sponsoring.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/cloudflare_image.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

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
        actions: homeAction(context),
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    image(requireData.hauptsponsor.first),
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Premium-Partner",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ResponsiveGridRow(
                        children:
                            requireData.premium.map((e) => ResponsiveGridCol(xs: 12, md: 6, child: image(e))).toList()),
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Deluxe-Partner",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ResponsiveGridRow(
                        children:
                            requireData.deluxe.map((e) => ResponsiveGridCol(xs: 12, md: 6, child: image(e))).toList()),
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Sponsor",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ResponsiveGridRow(
                        children:
                            requireData.sponsor.map((e) => ResponsiveGridCol(xs: 12, md: 6, child: image(e))).toList()),
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Musikfan",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ResponsiveGridRow(
                        children: requireData.musikfan
                            .map((e) => ResponsiveGridCol(
                                xs: 6, child: image(e, const EdgeInsets.symmetric(vertical: 5, horizontal: 5))))
                            .toList()),
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Gönner",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ResponsiveGridRow(
                          children: requireData.goenner
                              .map((e) => ResponsiveGridCol(
                                      child: Text(
                                    e.name,
                                    textAlign: TextAlign.center,
                                  )))
                              .toList()),
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

  InkWell image(SponsorDTO dto,
      [EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 30)]) {
    return InkWell(
      onTap: () {
        if (dto.url != null) {
          launchUrl(Uri.parse(dto.url!));
        }
      },
      child: CloudflareImage(
        cloudflareId: dto.cloudflareId,
        backgroundColor: Colors.white,
        paddingInner: padding,
      ),
    );
  }
}
