class AppPageDTO {
  final int id;
  final String title;
  final String markdown;
  final String? cloudflareId;
  final DateTime createdAt;

  AppPageDTO(this.id, this.title, this.markdown, this.cloudflareId, this.createdAt);

  factory AppPageDTO.fromJson(Map<String, dynamic> json) {
    return AppPageDTO(
        json["id"], json["title"], json["markdown"], json["cloudflareId"], DateTime.parse(json["createdAt"]));
  }
}
