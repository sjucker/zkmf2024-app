import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/location.dart';

// TODO ba

Future<List<LocationDTO>> fetchLocations() async {
  final response = await http.get(Uri.parse(
      '$baseUrl/public/location/wettspiel'));

  if (response.statusCode == 200) {
    var body = json.decode(response.body) as List;
    return body
        .map((e) => LocationDTO.fromJson(e as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to load locations');
  }
}

Future<LocationDTO> fetchLocation(String identifier) async {
  final response = await http.get(Uri.parse('$baseUrl/public/location/$identifier'));

  if (response.statusCode == 200) {
   return LocationDTO.fromJson(json.decode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load location for $identifier');
  }
}
