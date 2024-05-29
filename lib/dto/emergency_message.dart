class EmergencyMessageDTO {
  final String header;
  final String message;

  EmergencyMessageDTO(this.header, this.message);

  factory EmergencyMessageDTO.fromJson(Map<String, dynamic> json) {
    return EmergencyMessageDTO(json["header"], json["message"]);
  }
}
