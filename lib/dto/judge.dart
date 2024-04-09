class JudgeDTO {
  final String name;
  final String modul;
  final String cloudflareId;

  JudgeDTO({required this.name, required this.modul, required this.cloudflareId});

  factory JudgeDTO.fromJson(Map<String, dynamic> json) => JudgeDTO(
        name: json["name"],
        modul: json["modul"],
        cloudflareId: json["cloudflareId"],
      );
}
