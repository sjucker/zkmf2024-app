import 'package:map_launcher/map_launcher.dart';
import 'package:zkmf2024_app/dto/location.dart';
import 'package:zkmf2024_app/service/geolocation.dart';

Future<bool> openMap(LocationDTO location) async {
  var mapType = await getMapType();
  if (mapType == null) {
    return false;
  }

  var currentPosition = await determineCurrentPosition();
  if (currentPosition != null) {
    await MapLauncher.showDirections(
        mapType: mapType,
        destination: Coords(location.latitude, location.longitude),
        destinationTitle: location.name,
        origin: Coords(currentPosition.latitude, currentPosition.longitude),
        originTitle: "Meine Position",
        directionsMode: DirectionsMode.walking);
  } else {
    await MapLauncher.showMarker(
      mapType: mapType,
      coords: Coords(location.latitude, location.longitude),
      title: location.name,
    );
  }
  return true;
}

Future<MapType?> getMapType() async {
  if (await MapLauncher.isMapAvailable(MapType.google) ?? false) {
    return MapType.google;
  }
  if (await MapLauncher.isMapAvailable(MapType.apple) ?? false) {
    return MapType.apple;
  }
  final availableMaps = await MapLauncher.installedMaps;
  return availableMaps.firstOrNull?.mapType;
}
