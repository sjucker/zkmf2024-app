import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/verein_detail.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/cloudflare_image.dart';
import 'package:zkmf2024_app/widgets/favorite_button.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';

class VereinScreen extends StatefulWidget {
  final String identifier;

  const VereinScreen({super.key, required this.identifier});

  @override
  State<StatefulWidget> createState() => _VereinScreenState();
}

class _VereinScreenState extends State<VereinScreen> {
  late Future<VereinDetailDTO> _verein;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _verein = fetchVerein(widget.identifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: _verein,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.requireData.name);
            } else {
              return const Text("");
            }
          },
        ),
        actions: [
          FavoriteButton(
            identifier: widget.identifier,
            valueChanged: (v) {},
            offColor: rot,
            onColor: gelb,
          )
        ],
      ),
      body: FutureBuilder<VereinDetailDTO>(
        future: _verein,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var requireData = snapshot.requireData;

            return SingleChildScrollView(
              child: Column(
                children: buildContent(requireData),
              ),
            );
          } else if (snapshot.hasError) {
            return const GeneralErrorWidget();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  List<Widget> buildContent(VereinDetailDTO requireData) {
    return [
      ...requireData.timetableEntries
          .map((dto) => Column(
                children: [
                  ListTile(
                      title: Text(
                    dto.competition,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
                  ListTile(
                    // TODO add to calendar functionality?
                    leading: const Icon(Icons.access_time),
                    title: Text(dto.dateTime),
                  ),
                  ListTile(
                      leading: const Icon(Icons.location_on),
                      trailing: const Icon(
                        Icons.navigate_next_sharp,
                        color: Colors.white,
                      ),
                      onTap: () {
                        context.push('/wettspiellokale/${dto.location.identifier}');
                      },
                      title: Text(dto.location.name)),
                  const Divider(),
                ],
              ))
          .toList(),
      CloudflareImage(
        cloudflareId: requireData.bildImgId,
      ),
      buildWebsiteText(requireData),
      buildSocialMedia(requireData),
    ];
  }

  Widget buildWebsiteText(VereinDetailDTO dto) {
    if (dto.websiteText != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(dto.websiteText!),
      );
    } else {
      return Container();
    }
  }

  Widget buildSocialMedia(VereinDetailDTO dto) {
    List<Widget> widgets = [];
    if (dto.facebook != null) {
      widgets.add(IconButton(
        onPressed: () {
          launchUrl(Uri.parse(dto.facebook!));
        },
        icon: const FaIcon(
          FontAwesomeIcons.facebook,
          color: Colors.white,
        ),
      ));
    }
    if (dto.instagram != null) {
      widgets.add(IconButton(
        onPressed: () {
          launchUrl(Uri.parse(dto.instagram!));
        },
        icon: const FaIcon(
          FontAwesomeIcons.instagram,
          color: Colors.white,
        ),
      ));
    }

    // TODO add share functionality?

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: widgets),
    );
  }
}
