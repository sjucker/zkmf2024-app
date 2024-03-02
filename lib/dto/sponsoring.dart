class SponsoringDTO {
  final List<SponsorDTO> hauptsponsor;
  final List<SponsorDTO> premium;
  final List<SponsorDTO> deluxe;
  final List<SponsorDTO> sponsor;
  final List<SponsorDTO> musikfan;
  final List<SponsorDTO> goenner;

  SponsoringDTO(this.hauptsponsor, this.premium, this.deluxe, this.sponsor, this.musikfan, this.goenner);

  factory SponsoringDTO.fromJson(Map<String, dynamic> json) {
    return SponsoringDTO(
        toSponsorDTOs(json["hauptsponsor"] as List),
        toSponsorDTOs(json["premium"] as List),
        toSponsorDTOs(json["deluxe"] as List),
        toSponsorDTOs(json["sponsor"] as List),
        toSponsorDTOs(json["musikfan"] as List),
        toSponsorDTOs(json["goenner"] as List));
  }

  static List<SponsorDTO> toSponsorDTOs(List<dynamic> entries) {
    return entries.map((e) => SponsorDTO.fromJson(e as Map<String, dynamic>)).toList();
  }
}

class SponsorDTO {
  final String name;
  final String? cloudflareId;
  final String? url;

  SponsorDTO(this.name, this.cloudflareId, this.url);

  factory SponsorDTO.fromJson(Map<String, dynamic> json) {
    return SponsorDTO(json["name"], json["cloudflareId"], json["url"]);
  }
}
