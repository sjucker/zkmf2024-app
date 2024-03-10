import 'package:zkmf2024_app/dto/location.dart';
import 'package:zkmf2024_app/dto/titel.dart';

class VereinTimetableEntryDTO {
  final String modul;
  final String competition;
  final LocationDTO location;
  final String dateTime;
  final String? titel;
  final String? description;
  final List<TitelDTO> programm;

  VereinTimetableEntryDTO(
      {required this.modul,
      required this.competition,
      required this.location,
      required this.dateTime,
      required this.titel,
      required this.description,
      required this.programm});

  factory VereinTimetableEntryDTO.fromJson(Map<String, dynamic> json) => VereinTimetableEntryDTO(
      modul: json["modul"],
      competition: json["competition"],
      location: LocationDTO.fromJson(json["location"]),
      dateTime: json["dateTime"],
      titel: json["titel"],
      description: json["description"],
      programm: (json["programm"] as List).map((e) => TitelDTO.fromJson(e as Map<String, dynamic>)).toList());
}
