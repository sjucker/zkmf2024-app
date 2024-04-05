import 'package:zkmf2024_app/dto/unterhaltung_entry.dart';

class UnterhaltungTypeDTO {
  final UnterhaltungEntryType type;
  final List<UnterhaltungsEntryDTO> entries;

  UnterhaltungTypeDTO({required this.type, required this.entries});

  factory UnterhaltungTypeDTO.fromJson(Map<String, dynamic> json) => UnterhaltungTypeDTO(
      type: UnterhaltungEntryType.values.byName(json["type"]),
      entries:
      (json["entries"] as List).map((e) => UnterhaltungsEntryDTO.fromJson(e as Map<String, dynamic>)).toList());

}

enum UnterhaltungEntryType { FREITAG_ABEND, SAMSTAG_TAG, SAMSTAG_ABEND, SONNTAG }
