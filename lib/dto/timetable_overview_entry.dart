import 'package:zkmf2024_app/dto/location.dart';

class TimetableOverviewEntryDTO {
  final int vereinId;
  final String vereinIdentifier;
  final String vereinsname;
  final String modul;
  final String? klasse;
  final String? besetzung;
  final String competition;
  final String type;
  final LocationDTO location;
  final DateTime date;
  final String start;
  final String end;
  final String time;
  final bool inPast;

  TimetableOverviewEntryDTO(
      {required this.vereinId,
      required this.vereinIdentifier,
      required this.vereinsname,
      required this.modul,
      required this.klasse,
      required this.besetzung,
      required this.competition,
      required this.type,
      required this.location,
      required this.date,
      required this.start,
      required this.end,
      required this.time,
      required this.inPast});

  factory TimetableOverviewEntryDTO.fromJson(Map<String, dynamic> json) => TimetableOverviewEntryDTO(
        vereinId: json["vereinId"],
        vereinIdentifier: json["vereinIdentifier"],
        vereinsname: json["vereinsname"],
        modul: json["modul"],
        klasse: json["klasse"],
        besetzung: json["besetzung"],
        competition: json["competition"],
        type: json["type"],
        location: LocationDTO.fromJson(json["location"]),
        date: DateTime.parse(json["date"]),
        start: json["start"],
        end: json["end"],
        time: json["time"],
        inPast: json["inPast"],
      );
}
