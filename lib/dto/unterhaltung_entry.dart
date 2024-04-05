import 'package:zkmf2024_app/dto/location.dart';
import 'package:zkmf2024_app/dto/unterhaltung_type.dart';

class UnterhaltungsEntryDTO {
  final UnterhaltungEntryType type;
  final DateTime date;
  final String start;
  final String? end;
  final String title;
  final String? subtitle;
  final String? text;
  final LocationDTO location;
  final String? cloudflareId;
  final String? vereinIdentifier;
  final String? unterhaltungIdentifier;

  UnterhaltungsEntryDTO(
      {required this.type,
      required this.date,
      required this.start,
      required this.end,
      required this.title,
      required this.subtitle,
      required this.text,
      required this.location,
      required this.cloudflareId,
      required this.vereinIdentifier,
      required this.unterhaltungIdentifier});

  factory UnterhaltungsEntryDTO.fromJson(Map<String, dynamic> json) => UnterhaltungsEntryDTO(
        type: UnterhaltungEntryType.values.byName(json["type"]),
        date: DateTime.parse(json["date"]),
        start: json["start"],
        end: json["end"],
        title: json["title"],
        subtitle: json["subtitle"],
        text: json["text"],
        location: LocationDTO.fromJson(json["location"]),
        cloudflareId: json["cloudflareId"],
        vereinIdentifier: json["vereinIdentifier"],
        unterhaltungIdentifier: json["unterhaltungIdentifier"],
      );
}
