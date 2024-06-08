import 'package:zkmf2024_app/dto/unterhaltung_entry.dart';

class UnterhaltungTypeDTO {
  final UnterhaltungEntryType type;
  final bool inPast;
  final List<UnterhaltungsEntryDTO> entries;

  UnterhaltungTypeDTO({required this.type, required this.inPast, required this.entries});

  factory UnterhaltungTypeDTO.fromJson(Map<String, dynamic> json) => UnterhaltungTypeDTO(
      type: UnterhaltungEntryType.values.byName(json["type"]),
      inPast: json["inPast"],
      entries:
          (json["entries"] as List).map((e) => UnterhaltungsEntryDTO.fromJson(e as Map<String, dynamic>)).toList());
}

enum UnterhaltungEntryType {
  FREITAG_ABEND("Freitag, 21. Juni 2024", "Freitag"),
  SAMSTAG_TAG("Samstag, 22. Juni 2024 – tagsüber", "Samstag tagsüber"),
  SAMSTAG_ABEND("Samstag, 22. Juni 2024 – Abendprogramm", "Samstagabend"),
  SONNTAG("Sonntag, 23. Juni 2024", "Sonntag");

  final String label;
  final String labelShort;

  const UnterhaltungEntryType(this.label, this.labelShort);
}
