import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Position?> determineCurrentPosition() async {
  var serviceEnabled = await Permission.location.serviceStatus.isEnabled;
  if (!serviceEnabled) {
    // location services are disabled
    return Future.value(null);
  }

  var permission = await Permission.location.status;
  if (permission == PermissionStatus.permanentlyDenied) {
    // location permissions are permanently denied, we cannot request permissions
    return Future.value(null);
  }

  permission = await Permission.location.request();

  if (permission == PermissionStatus.denied) {
    // location permissions are denied
    return Future.value(null);
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
