import 'package:zkmf2024_app/dto/verein_timetable_entry.dart';

class VereinDetailDTO {
  final int id;
  final String name;
  final String? logoImgId;
  final String? bildImgId;
  final String? homepage;
  final String? facebook;
  final String? instagram;
  final String? websiteText;
  final List<VereinTimetableEntryDTO> timetableEntries;

  const VereinDetailDTO(
      {required this.id,
      required this.name,
      required this.logoImgId,
      required this.bildImgId,
      required this.homepage,
      required this.facebook,
      required this.instagram,
      required this.websiteText,
      required this.timetableEntries});

  factory VereinDetailDTO.fromJson(Map<String, dynamic> json) {
    return VereinDetailDTO(
        id: json["id"],
        name: json["name"],
        logoImgId: json["logoImgId"],
        bildImgId: json["bildImgId"],
        homepage: json["homepage"],
        facebook: json["facebook"],
        instagram: json["instagram"],
        websiteText: json["websiteText"],
        timetableEntries: (json["timetableEntries"] as List)
            .map((e) => VereinTimetableEntryDTO.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}
