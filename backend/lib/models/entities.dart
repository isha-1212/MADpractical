class FileEntity {
  final String id;
  final String name;
  final String fileType;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isShared;
  final int latestVersion;
  final String ownerId;

  FileEntity({
    required this.id,
    required this.name,
    required this.fileType,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.isShared,
    required this.latestVersion,
    required this.ownerId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'fileType': fileType,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'isShared': isShared,
        'latestVersion': latestVersion,
        'ownerId': ownerId,
      };

  factory FileEntity.fromJson(Map<String, dynamic> json) => FileEntity(
        id: json['id'] as String,
        name: json['name'] as String,
        fileType: json['fileType'] as String,
        description: json['description'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        isShared: json['isShared'] as bool,
        latestVersion: json['latestVersion'] as int,
        ownerId: json['ownerId'] as String,
      );
}

class VersionEntity {
  final String id;
  final String fileId;
  final int versionNumber;
  final DateTime createdAt;
  final String createdBy;
  final String? changeDescription;

  VersionEntity({
    required this.id,
    required this.fileId,
    required this.versionNumber,
    required this.createdAt,
    required this.createdBy,
    this.changeDescription,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fileId': fileId,
        'versionNumber': versionNumber,
        'createdAt': createdAt.toIso8601String(),
        'createdBy': createdBy,
        'changeDescription': changeDescription,
      };
}

class CommentEntity {
  final String id;
  final String fileId;
  final String userId;
  final String username;
  final String text;
  final DateTime createdAt;

  CommentEntity({
    required this.id,
    required this.fileId,
    required this.userId,
    required this.username,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fileId': fileId,
        'userId': userId,
        'username': username,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };
}
