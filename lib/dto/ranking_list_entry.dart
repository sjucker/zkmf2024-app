class RankingListEntryDTO {
  final int rank;
  final String vereinsName;
  final double score;

  RankingListEntryDTO(this.rank, this.vereinsName, this.score);

  factory RankingListEntryDTO.fromJson(Map<String, dynamic> json) =>
      RankingListEntryDTO(json["rank"], json["vereinsName"], json["score"]);
}
