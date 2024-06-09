import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/location.dart';
import 'package:zkmf2024_app/dto/verein_member_info.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';
import 'package:zkmf2024_app/widgets/location_tile.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  final box = GetStorage();

  late String? _selectedVerein;
  late Future<VereinMemberInfoDTO> _info;

  @override
  void initState() {
    super.initState();
    _selectedVerein = box.read(selectedVereinKey);
    _info = fetchMemberInfo(_selectedVerein ?? '?');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detailinformation'),
          actions: homeAction(context),
        ),
        body: Center(
          child: FutureBuilder<VereinMemberInfoDTO>(
            future: _info,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: [
                    const ListTile(
                        title: Text(
                      "Einsatzzeiten",
                      style: TextStyle(fontWeight: FontWeight.bold, color: gruen),
                    )),
                    ...snapshot.requireData.timetableEntries.map((e) => ListTile(
                          title: Text('${DateFormat.EEEE('de_CH').format(e.date)}, ${e.time}: ${e.typeDescription}'),
                          subtitle: Text(e.location.name),
                          leading: Icon(e.inPast ? Icons.event_available_outlined : Icons.event_outlined),
                          trailing: const Icon(
                            Icons.navigate_next_sharp,
                            color: Colors.white,
                          ),
                          onTap: () {
                            context.push('/wettspiellokale/${e.location.identifier}');
                          },
                        )),
                    const Divider(),
                    const ListTile(
                        title: Text(
                      "Instrumentendepot",
                      style: TextStyle(fontWeight: FontWeight.bold, color: gruen),
                    )),
                    location(snapshot.requireData.instrumentenDepot),
                    location(snapshot.requireData.instrumentenDepotParademusik),
                    const Divider(),
                    const ListTile(
                        title: Text(
                      "Mittagessen",
                      style: TextStyle(fontWeight: FontWeight.bold, color: gruen),
                    )),
                    ListTile(
                      title: Text("${snapshot.requireData.lunchTime.substring(0, 5)} Uhr im Festzelt Urdorf"),
                      leading: const Icon(Icons.restaurant_outlined),
                      trailing: const Icon(
                        Icons.navigate_next_sharp,
                        color: Colors.white,
                      ),
                      onTap: () {
                        context.push('/wettspiellokale/festzelt-urdorf');
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text("Zur Vereinsseite"),
                      leading: const Icon(Icons.music_note_outlined),
                      trailing: const Icon(
                        Icons.navigate_next_sharp,
                        color: Colors.white,
                      ),
                      onTap: () {
                        context.push('/vereine/$_selectedVerein');
                      },
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return const GeneralErrorWidget();
              }

              return const CircularProgressIndicator();
            },
          ),
        ));
  }

  Widget location(LocationDTO? location) {
    if (location != null) {
      return LocationTileWidget(location);
    } else {
      return Container();
    }
  }
}
