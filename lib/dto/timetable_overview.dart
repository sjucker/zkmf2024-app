import 'package:zkmf2024_app/dto/timetable_overview_entry.dart';

class TimetableDayOverviewDTO {
  final String day;
  final bool inPast;
  final List<TimetableOverviewEntryDTO> entries;

  TimetableDayOverviewDTO({required this.day, required this.inPast, required this.entries});

  factory TimetableDayOverviewDTO.fromJson(Map<String, dynamic> json) => TimetableDayOverviewDTO(
      day: json["day"],
      inPast: json["inPast"],
      entries:
          (json["entries"] as List).map((e) => TimetableOverviewEntryDTO.fromJson(e as Map<String, dynamic>)).toList());
}
