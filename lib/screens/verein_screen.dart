import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/verein_detail.dart';
import 'package:zkmf2024_app/dto/verein_timetable_entry.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/cloudflare_image.dart';
import 'package:zkmf2024_app/widgets/favorite_button.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';
import 'package:zkmf2024_app/widgets/location_tile.dart';
import 'package:zkmf2024_app/widgets/random_sponsor.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

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
        actions: homeAction(context),
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

  List<Widget> buildContent(VereinDetailDTO vereinDetail) {
    return [
      CloudflareImage(
        cloudflareId: vereinDetail.bildImgId,
        paddingOuter: EdgeInsets.zero,
        paddingInner: EdgeInsets.zero,
        borderRadius: BorderRadius.zero,
      ),
      ListTile(
        leading: FavoriteButton(
          identifier: widget.identifier,
          offColor: Colors.white,
          onColor: gelb,
        ),
        title: const Text("zu Favoriten hinzufügen"),
        subtitle: const Text(
          "Benachrichtigungen zu diesem Verein erhalten",
          style: TextStyle(fontSize: 10),
        ),
      ),
      ListTile(
          title:
              Text("Dirigent/in: ${vereinDetail.direktionName}", style: const TextStyle(fontWeight: FontWeight.bold))),
      ...vereinDetail.timetableEntries.map((dto) => Column(
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
              LocationTileWidget(dto.location),
              if (dto.modul != "C") ...[
                ExpansionTile(
                  leading: const Icon(
                    Icons.music_note,
                    color: gruen,
                  ),
                  title: Text(
                    dto.titel != null ? "\"${dto.titel}\"" : "Komposition",
                  ),
                  expandedAlignment: Alignment.topLeft,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(dto.programm
                            .map((e) => "${e.titelName} (${e.composer})")
                            .join(dto.modul == "D" ? " oder\n" : "\n")),
                        description(dto)
                      ]),
                    )
                  ],
                )
              ],
              const Divider(),
            ],
          )),
      buildWebsiteText(vereinDetail),
      buildSocialMedia(vereinDetail),
      const RandomSponsor(),
    ];
  }

  Widget description(VereinTimetableEntryDTO dto) => dto.description != null
      ? Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Text(dto.description!),
        )
      : Container();

  Widget buildWebsiteText(VereinDetailDTO dto) {
    if (dto.websiteText != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
          launchUrl(Uri.parse(dto.facebook!), mode: LaunchMode.externalApplication);
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
          launchUrl(Uri.parse(dto.instagram!), mode: LaunchMode.externalApplication);
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
