class TitelDTO {
  final String? titelName;
  final String? composer;
  final bool pflichtStueck;
  final String? infoModeration;

  TitelDTO(
      {required this.titelName, required this.composer, required this.pflichtStueck, required this.infoModeration});

  factory TitelDTO.fromJson(Map<String, dynamic> json) => TitelDTO(
      titelName: json["titelName"],
      composer: json["composer"],
      pflichtStueck: json["pflichtStueck"],
      infoModeration: json["infoModeration"]);
}
