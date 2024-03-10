class TitelDTO {
  final String? titelName;
  final String? composer;

  TitelDTO({required this.titelName, required this.composer});

  factory TitelDTO.fromJson(Map<String, dynamic> json) =>
      TitelDTO(titelName: json["titelName"], composer: json["composer"]);
}
