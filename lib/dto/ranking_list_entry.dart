class RankingListEntryDTO {
  final int rank;
  final String vereinIdentifier;
  final String vereinsName;
  final double score;
  final String? additionalInfo;

  RankingListEntryDTO(this.rank, this.vereinIdentifier, this.vereinsName, this.score, this.additionalInfo);

  factory RankingListEntryDTO.fromJson(Map<String, dynamic> json) => RankingListEntryDTO(
      json["rank"], json["vereinIdentifier"], json["vereinsName"], json["score"], json["additionalInfo"]);
}
