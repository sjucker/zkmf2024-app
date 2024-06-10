import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zkmf2024_app/service/geolocation.dart';

class DistanceToLocationWidget extends StatelessWidget {
  final AsyncSnapshot<Position?> _currentPosition;
  final Position _locationPosition;

  const DistanceToLocationWidget(this._currentPosition, this._locationPosition, {super.key});

  @override
  Widget build(BuildContext context) {
    if (_currentPosition.connectionState == ConnectionState.waiting) {
      return const LinearProgressIndicator();
    }

    if (_currentPosition.hasData) {
      return Text(
        getDistanceToLocation(_currentPosition.requireData!, _locationPosition),
      );
    } else {
      return const Text("Entfernung konnte nicht bestimmt werden - Ortungsdienste aktivieren");
    }
  }
}
