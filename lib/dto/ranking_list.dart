import 'package:zkmf2024_app/dto/location.dart';
import 'package:zkmf2024_app/dto/ranking_list_entry.dart';

class RankingListDTO {
  final int id;
  final String modulDescription;
  final String? klasseDescription;
  final String? besetzungDescription;
  final String? categoryDescription;
  final LocationDTO location;
  final String description;
  final String status;
  final List<RankingListEntryDTO> entries;

  RankingListDTO(this.id, this.modulDescription, this.klasseDescription, this.besetzungDescription,
      this.categoryDescription, this.location, this.description, this.status, this.entries);

  factory RankingListDTO.fromJson(Map<String, dynamic> json) => RankingListDTO(
      json["id"],
      json["modulDescription"],
      json["klasseDescription"],
      json["besetzungDescription"],
      json["categoryDescription"],
      LocationDTO.fromJson(json["location"]),
      json["description"],
      json["status"],
      (json["entries"] as List).map((e) => RankingListEntryDTO.fromJson(e as Map<String, dynamic>)).toList());
}
