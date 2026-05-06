import 'package:equatable/equatable.dart';

class FileModel extends Equatable {
  final String id;
  final String name;
  final String fileType;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isShared;
  final int latestVersion;
  final String ownerId;

  const FileModel({
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

  FileModel copyWith({
    String? id,
    String? name,
    String? fileType,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isShared,
    int? latestVersion,
    String? ownerId,
  }) {
    return FileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      fileType: fileType ?? this.fileType,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isShared: isShared ?? this.isShared,
      latestVersion: latestVersion ?? this.latestVersion,
      ownerId: ownerId ?? this.ownerId,
    );
  }

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

  factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
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

  @override
  List<Object?> get props => [
        id,
        name,
        fileType,
        description,
        createdAt,
        updatedAt,
        isShared,
        latestVersion,
        ownerId,
      ];
}
