import 'package:equatable/equatable.dart';

class FileVersionModel extends Equatable {
  final String id;
  final String fileId;
  final int versionNumber;
  final DateTime createdAt;
  final String createdBy;
  final String? changeDescription;

  const FileVersionModel({
    required this.id,
    required this.fileId,
    required this.versionNumber,
    required this.createdAt,
    required this.createdBy,
    this.changeDescription,
  });

  FileVersionModel copyWith({
    String? id,
    String? fileId,
    int? versionNumber,
    DateTime? createdAt,
    String? createdBy,
    String? changeDescription,
  }) {
    return FileVersionModel(
      id: id ?? this.id,
      fileId: fileId ?? this.fileId,
      versionNumber: versionNumber ?? this.versionNumber,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      changeDescription: changeDescription ?? this.changeDescription,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fileId': fileId,
        'versionNumber': versionNumber,
        'createdAt': createdAt.toIso8601String(),
        'createdBy': createdBy,
        'changeDescription': changeDescription,
      };

  factory FileVersionModel.fromJson(Map<String, dynamic> json) =>
      FileVersionModel(
        id: json['id'] as String,
        fileId: json['fileId'] as String,
        versionNumber: json['versionNumber'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String),
        createdBy: json['createdBy'] as String,
        changeDescription: json['changeDescription'] as String?,
      );

  @override
  List<Object?> get props => [
        id,
        fileId,
        versionNumber,
        createdAt,
        createdBy,
        changeDescription,
      ];
}
