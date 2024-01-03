import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/location.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/service/geolocation.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';

class LocationScreen extends StatefulWidget {
  final String identifier;

  const LocationScreen({super.key, required this.identifier});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late Future<LocationDTO> _location;
  late Future<Position> _currentPosition;

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
            builder:
                (BuildContext context, AsyncSnapshot<LocationDTO> snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.requireData.name);
              } else {
                return const Text('');
              }
            }),
      ),
      body: FutureBuilder<LocationDTO>(
        future: _location,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var requireData = snapshot.requireData;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    requireData.address,
                  ),
                  FutureBuilder(
                    future: _currentPosition,
                    builder: (innerContext, innerSnapshot) {
                      if (innerSnapshot.hasData) {
                        return getDistanceToLocation(innerSnapshot.requireData,
                            requireData.getPosition());
                      } else {
                        return Container();
                      }
                    },
                  ),
                  getLocationImage(requireData),
                ],
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

  Widget getLocationImage(LocationDTO requireData) {
    if (requireData.cloudflareId != null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(
              '$cloudFlareUrl${requireData.cloudflareId!}/public'));
    } else {
      return Container();
    }
  }

  Widget getDistanceToLocation(
      Position currentPosition, Position locationPosition) {
    var distanceInMeters =
        calculateDistanceInMeters(currentPosition, locationPosition);

    var distance = '';
    if (distanceInMeters < 100) {
      distance = 'weniger als 100 Meter entfernt';
    } else if (distanceInMeters < 1000) {
      distance = 'ca. ${(distanceInMeters / 100).round() * 100} Meter entfernt';
    } else if (distanceInMeters < 10000) {
      distance = 'ca. ${(distanceInMeters / 1000).round()} Kilometer entfernt';
    } else {
      distance = 'mehr als 10 Kilometer entfernt';
    }

    return Text(distance);
  }
}
