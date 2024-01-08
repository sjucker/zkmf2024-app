import 'package:zkmf2024_app/dto/location.dart';

class VereinTimetableEntryDTO {
  final String competition;
  final LocationDTO location;
  final String dateTime;

  VereinTimetableEntryDTO({required this.competition, required this.location, required this.dateTime});

  factory VereinTimetableEntryDTO.fromJson(Map<String, dynamic> json) => VereinTimetableEntryDTO(
      competition: json["competition"], location: LocationDTO.fromJson(json["location"]), dateTime: json["dateTime"]);
}
