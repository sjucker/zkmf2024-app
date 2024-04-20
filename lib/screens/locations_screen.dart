import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/location.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/service/geolocation.dart';
import 'package:zkmf2024_app/widgets/distance_to_location.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  late Future<List<LocationDTO>> _locations;
  late Future<Position> _currentPosition;

  @override
  void initState() {
    super.initState();
    _locations = fetchLocations();
    _currentPosition = determineCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Wettspiellokale'),
          actions: homeAction(context),
        ),
        body: Center(
          child: FutureBuilder<List<LocationDTO>>(
            future: _locations,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  itemCount: snapshot.requireData.length,
                  itemBuilder: (BuildContext context, int index) {
                    var requireData = snapshot.requireData[index];
                    return ListTile(
                      leading: const Icon(
                        Icons.location_on,
                        color: gruen,
                      ),
                      trailing: const Icon(
                        Icons.navigate_next_sharp,
                        color: Colors.white,
                      ),
                      onTap: () {
                        context.push('/wettspiellokale/${requireData.identifier}');
                      },
                      title: Text(
                        requireData.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: FutureBuilder(
                        future: _currentPosition,
                        builder: (innerContext, innerSnapshot) {
                          return DistanceToLocationWidget(innerSnapshot, requireData.getPosition());
                        },
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                );
              } else if (snapshot.hasError) {
                return const GeneralErrorWidget();
              }

              return const CircularProgressIndicator();
            },
          ),
        ));
  }
}
