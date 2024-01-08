class VereinOverviewDTO {
  final int id;
  final String identifier;
  final String name;
  final String? logoImgId;
  final String? bildImgId;
  final String? homepage;
  final String? facebook;
  final String? instagram;
  final String? websiteText;

  const VereinOverviewDTO(
      {required this.id,
      required this.identifier,
      required this.name,
      required this.logoImgId,
      required this.bildImgId,
      required this.homepage,
      required this.facebook,
      required this.instagram,
      required this.websiteText});

  factory VereinOverviewDTO.fromJson(Map<String, dynamic> json) =>
      VereinOverviewDTO(
          id: json["id"],
          identifier: json["identifier"],
          name: json["name"],
          logoImgId: json["logoImgId"],
          bildImgId: json["bildImgId"],
          homepage: json["homepage"],
          facebook: json["facebook"],
          instagram: json["instagram"],
          websiteText: json["websiteText"]);
}
