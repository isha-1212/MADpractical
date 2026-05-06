import 'package:equatable/equatable.dart';

class SharedFileModel extends Equatable {
  final String id;
  final String fileId;
  final String sharedBy;
  final String sharedWith;
  final DateTime sharedAt;
  final String accessLevel;

  const SharedFileModel({
    required this.id,
    required this.fileId,
    required this.sharedBy,
    required this.sharedWith,
    required this.sharedAt,
    required this.accessLevel,
  });

  SharedFileModel copyWith({
    String? id,
    String? fileId,
    String? sharedBy,
    String? sharedWith,
    DateTime? sharedAt,
    String? accessLevel,
  }) {
    return SharedFileModel(
      id: id ?? this.id,
      fileId: fileId ?? this.fileId,
      sharedBy: sharedBy ?? this.sharedBy,
      sharedWith: sharedWith ?? this.sharedWith,
      sharedAt: sharedAt ?? this.sharedAt,
      accessLevel: accessLevel ?? this.accessLevel,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fileId': fileId,
        'sharedBy': sharedBy,
        'sharedWith': sharedWith,
        'sharedAt': sharedAt.toIso8601String(),
        'accessLevel': accessLevel,
      };

  factory SharedFileModel.fromJson(Map<String, dynamic> json) =>
      SharedFileModel(
        id: json['id'] as String,
        fileId: json['fileId'] as String,
        sharedBy: json['sharedBy'] as String,
        sharedWith: json['sharedWith'] as String,
        sharedAt: DateTime.parse(json['sharedAt'] as String),
        accessLevel: json['accessLevel'] as String,
      );

  @override
  List<Object?> get props => [
        id,
        fileId,
        sharedBy,
        sharedWith,
        sharedAt,
        accessLevel,
      ];
}
