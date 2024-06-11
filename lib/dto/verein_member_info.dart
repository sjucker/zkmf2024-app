import 'package:zkmf2024_app/dto/location.dart';
import 'package:zkmf2024_app/dto/timetable_overview_entry.dart';

class VereinMemberInfoDTO {
  final List<TimetableOverviewEntryDTO> timetableEntries;
  final String lunchTime;
  final LocationDTO? instrumentenDepot;
  final LocationDTO? instrumentenDepotParademusik;

  VereinMemberInfoDTO(this.timetableEntries, this.lunchTime, this.instrumentenDepot, this.instrumentenDepotParademusik);

  factory VereinMemberInfoDTO.fromJson(Map<String, dynamic> json) {
    return VereinMemberInfoDTO(
      (json["timetableEntries"] as List)
          .map((e) => TimetableOverviewEntryDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      json["lunchTime"],
      json["instrumentenDepot"] != null ? LocationDTO.fromJson(json["instrumentenDepot"]) : null,
      json["instrumentenDepotParademusik"] != null ? LocationDTO.fromJson(json["instrumentenDepotParademusik"]) : null,
    );
  }
}
