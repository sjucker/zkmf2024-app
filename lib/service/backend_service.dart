import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/location.dart';
import 'package:zkmf2024_app/dto/verein_detail.dart';
import 'package:zkmf2024_app/dto/verein_overview.dart';

Future<List<LocationDTO>> fetchLocations() async {
  final response =
      await http.get(Uri.parse('$baseUrl/public/location/wettspiel'));

  if (response.statusCode == 200) {
    var body = json.decode(utf8.decode(response.bodyBytes)) as List;
    return body
        .map((e) => LocationDTO.fromJson(e as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to load locations');
  }
}

Future<LocationDTO> fetchLocation(String identifier) async {
  final response =
      await http.get(Uri.parse('$baseUrl/public/location/$identifier'));

  if (response.statusCode == 200) {
    return LocationDTO.fromJson(
        json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load location for $identifier');
  }
}

Future<List<VereinOverviewDTO>> fetchVereine() async {
  final response = await http.get(Uri.parse('$baseUrl/public/verein/overview'));

  if (response.statusCode == 200) {
    var body = json.decode(utf8.decode(response.bodyBytes)) as List;
    return body
        .map((e) => VereinOverviewDTO.fromJson(e as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to load vereine');
  }
}

Future<VereinDetailDTO> fetchVerein(String identifier) async {
  final response = await http.get(Uri.parse('$baseUrl/public/verein/$identifier'));

  if (response.statusCode == 200) {
    return VereinDetailDTO.fromJson(
        json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load verein for $identifier');
  }
}
