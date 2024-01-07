import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zkmf2024_app/service/geolocation.dart';

class DistanceToLocationWidget extends StatelessWidget {
  final AsyncSnapshot<Position> _currentPosition;
  final Position _locationPosition;

  const DistanceToLocationWidget(this._currentPosition, this._locationPosition,
      {super.key});

  @override
  Widget build(BuildContext context) {
    if (_currentPosition.hasData) {
      return Text(
        getDistanceToLocation(_currentPosition.requireData, _locationPosition),
      );
    } else if (_currentPosition.hasError) {
      return const Text("Entfernung konnte nicht bestimmt werden...");
    } else {
      return const LinearProgressIndicator();
    }
  }
}
