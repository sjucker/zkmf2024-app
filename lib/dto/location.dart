import 'package:geolocator/geolocator.dart';

class LocationDTO {
  final int id;
  final String identifier;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String googleMapsAddress;
  final String googleMapsCoordinates;
  final int sortOrder;
  final String modules;
  final String? cloudflareId;
  final String? kuulaId;

  const LocationDTO({required this.id,
    required this.identifier,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.googleMapsAddress,
    required this.googleMapsCoordinates,
    required this.sortOrder,
    required this.modules,
    this.cloudflareId,
    this.kuulaId});

  factory LocationDTO.fromJson(Map<String, dynamic> json) =>
      LocationDTO(
        id: json["id"],
        identifier: json["identifier"],
        name: json["name"],
        address: json["address"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        googleMapsAddress: json["googleMapsAddress"],
        googleMapsCoordinates: json["googleMapsCoordinates"],
        sortOrder: json["sortOrder"],
        modules: json["modules"],
        cloudflareId: json["cloudflareId"],
        kuulaId: json["kuulaId"],
      );

  Position getPosition() {
    return Position(longitude: longitude,
        latitude: latitude,
        timestamp: DateTime.timestamp(),
        accuracy: 0.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0);
  }
}
