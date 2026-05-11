import 'package:trip_organizer_project/enums/trip_enums.dart';

class Attachment {
  final String id;
  final String itineraryItemId;
  final AttachmentType type;
  final String fileUrl;
  final String fileName;
  final DateTime uploadedAt;

  const Attachment({
    required this.id,
    required this.itineraryItemId,
    required this.type,
    required this.fileUrl,
    required this.fileName,
    required this.uploadedAt,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'] as String,
      itineraryItemId: json['itineraryItemId'] as String,
      type: AttachmentType.values.byName(json['type'] as String),
      fileUrl: json['fileUrl'] as String,
      fileName: json['fileName'] as String,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'itineraryItemId': itineraryItemId,
        'type': type.name,
        'fileUrl': fileUrl,
        'fileName': fileName,
        'uploadedAt': uploadedAt.toIso8601String(),
      };
}
