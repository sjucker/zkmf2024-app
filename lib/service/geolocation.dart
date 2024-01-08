import 'dart:math';

import 'package:geolocator/geolocator.dart';

Future<Position> determineCurrentPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

double calculateDistanceInMeters(Position pointA, Position pointB) {
  const radiusOfEarthInKm = 6371;
  const degreesToRadians = 0.017453292519943295;

  var longitudeA = pointA.longitude * degreesToRadians;
  var longitudeB = pointB.longitude * degreesToRadians;
  var latitudeA = pointA.latitude * degreesToRadians;
  var latitudeB = pointB.latitude * degreesToRadians;

  var deltaLongitude = longitudeB - longitudeA;
  var deltaLatitude = latitudeB - latitudeA;
  var a = pow(sin(deltaLatitude / 2), 2) + cos(latitudeA) * cos(latitudeB) * pow(sin(deltaLongitude / 2), 2);

  var c = 2 * asin(sqrt(a));

  return c * radiusOfEarthInKm * 1000;
}

String getDistanceToLocation(Position currentPosition, Position locationPosition) {
  var distanceInMeters = calculateDistanceInMeters(currentPosition, locationPosition);

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

  return distance;
}
