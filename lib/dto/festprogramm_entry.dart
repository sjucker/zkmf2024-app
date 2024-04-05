class FestprogrammEntryDTO {
  final DateTime date;
  final String timeFrom;
  final String? timeTo;
  final String description;
  final String location;
  final bool important;

  FestprogrammEntryDTO(
      {required this.date,
      required this.timeFrom,
      required this.timeTo,
      required this.description,
      required this.location,
      required this.important});

  factory FestprogrammEntryDTO.fromJson(Map<String, dynamic> json) => FestprogrammEntryDTO(
      date: DateTime.parse(json["date"]),
      timeFrom: json["timeFrom"],
      timeTo: json["timeTo"],
      description: json["description"],
      location: json["location"],
      important: json["important"] == "true");
}
