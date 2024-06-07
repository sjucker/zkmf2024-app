import 'package:zkmf2024_app/dto/festprogramm_entry.dart';

class FestprogrammDayDTO {
  final String day;
  final bool inPast;
  final List<FestprogrammEntryDTO> entries;

  FestprogrammDayDTO({required this.day, required this.inPast, required this.entries});

  factory FestprogrammDayDTO.fromJson(Map<String, dynamic> json) => FestprogrammDayDTO(
      day: json["day"],
      inPast: json["inPast"],
      entries: (json["entries"] as List).map((e) => FestprogrammEntryDTO.fromJson(e as Map<String, dynamic>)).toList());
}
