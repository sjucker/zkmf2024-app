import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/location.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/service/geolocation.dart';
import 'package:zkmf2024_app/service/maps.dart';
import 'package:zkmf2024_app/widgets/cloudflare_image.dart';
import 'package:zkmf2024_app/widgets/distance_to_location.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';
import 'package:zkmf2024_app/widgets/random_sponsor.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

class LocationScreen extends StatefulWidget {
  final String identifier;

  const LocationScreen({super.key, required this.identifier});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late Future<LocationDTO> _location;
  late Future<Position?> _currentPosition;

  @override
  void initState() {
    super.initState();
    _location = fetchLocation(widget.identifier);
    _currentPosition = determineCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
            future: _location,
            builder: (BuildContext context, AsyncSnapshot<LocationDTO> snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.requireData.name);
              } else {
                return const Text('');
              }
            }),
        actions: homeAction(context),
      ),
      body: FutureBuilder<LocationDTO>(
        future: _location,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var requireData = snapshot.requireData;
            return ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.maps_home_work),
                  title: Text(
                    requireData.address,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.map_sharp),
                  onTap: () async {
                    var opened = await openMap(requireData);
                    if (!opened && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          'Keine Karten-Applikation vorhanden, um Standort anzuzeigen.',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: rot,
                      ));
                    }
                  },
                  title: const Text(
                    "Karte öffnen",
                  ),
                  trailing: const Icon(
                    Icons.navigate_next_sharp,
                    color: Colors.white,
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.my_location,
                  ),
                  title: FutureBuilder(
                    future: _currentPosition,
                    builder: (innerContext, innerSnapshot) {
                      return DistanceToLocationWidget(innerSnapshot, requireData.getPosition());
                    },
                  ),
                ),
                ListTile(
                    leading: const Icon(Icons.explore_outlined),
                    title: Text("Kennzeichen auf Karte: ${requireData.mapId}")),
                buildModulesTile(requireData),
                CloudflareImage(cloudflareId: requireData.cloudflareId),
                const RandomSponsor()
              ],
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

  Widget buildModulesTile(LocationDTO requireData) {
    if (requireData.modules != null) {
      return ListTile(
        leading: const Icon(Icons.info_outlined),
        title: Text(
          "Module: ${requireData.modules}",
        ),
      );
    } else {
      return Container();
    }
  }
}
