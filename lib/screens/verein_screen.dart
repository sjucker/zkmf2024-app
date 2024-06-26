import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/titel.dart';
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
          key: Key('favorite-${widget.identifier}'),
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
      ...getRankings(vereinDetail),
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
              if (dto.programm.isNotEmpty) ...[
                ExpansionTile(
                  leading: const Icon(
                    Icons.music_note,
                    color: gruen,
                  ),
                  title: Text(
                    getProgrammTitel(dto),
                  ),
                  expandedAlignment: Alignment.topLeft,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [...getProgramm(dto), description(dto)]),
                    )
                  ],
                )
              ],
              const Divider(),
            ],
          )),
      buildWebsiteLink(vereinDetail),
      buildWebsiteText(vereinDetail),
      buildSocialMedia(vereinDetail),
      const RandomSponsor(),
    ];
  }

  List<Widget> getRankings(VereinDetailDTO vereinDetail) {
    if (vereinDetail.rankings.isNotEmpty) {
      return [
        const ListTile(
          title: Text("Ranglisten", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ...vereinDetail.rankings.map((e) => ListTile(
              title: Text(e.description),
              trailing: const Icon(
                Icons.navigate_next_sharp,
                color: Colors.white,
              ),
              onTap: () {
                context.push('/ranglisten/${e.id}');
              },
            )),
        const Divider(),
      ];
    } else {
      return [];
    }
  }

  Iterable<Widget> getProgramm(VereinTimetableEntryDTO dto) {
    if (dto.modul == "D") {
      return [Text(dto.programm.map((e) => "${e.titelName} (${e.composer})").join("\noder\n"))];
    } else {
      return dto.programm.map((e) {
        if (e.infoModeration != null) {
          return ExpansionTile(
            title: Text(getTitel(e)),
            children: [Text(e.infoModeration ?? '')],
          );
        } else {
          return ListTile(title: Text(getTitel(e)));
        }
      });
    }
  }

  String getTitel(TitelDTO e) => "${e.titelName} (${e.composer})${e.pflichtStueck ? '*' : ''}";

  String getProgrammTitel(VereinTimetableEntryDTO dto) {
    if (dto.modul == "D") {
      // Parademusik
      return "Komposition";
    } else if (dto.modul == "G") {
      // Tambouren
      return dto.programm.length > 1 ? "Kompositionen" : "Komposition";
    } else {
      return dto.titel != null ? "\"${dto.titel}\"" : "Programm";
    }
  }

  Widget description(VereinTimetableEntryDTO dto) => dto.description != null
      ? Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Text(dto.description!),
        )
      : Container();

  Widget buildWebsiteLink(VereinDetailDTO dto) {
    if (dto.homepage != null) {
      return ListTile(
        title: const Text("Website"),
        leading: const Icon(Icons.language_outlined),
        trailing: const Icon(
          Icons.arrow_outward_outlined,
          color: Colors.white,
        ),
        onTap: () {
          launchUrl(Uri.parse(dto.homepage!));
        },
      );
    } else {
      return Container();
    }
  }

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
