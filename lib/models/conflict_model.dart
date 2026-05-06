import 'package:equatable/equatable.dart';

class ConflictModel extends Equatable {
  final String id;
  final String fileId;
  final List<String> conflictingVersionIds;
  final DateTime detectedAt;
  final String resolutionStrategy;
  final String? resolvedVersionId;

  const ConflictModel({
    required this.id,
    required this.fileId,
    required this.conflictingVersionIds,
    required this.detectedAt,
    required this.resolutionStrategy,
    this.resolvedVersionId,
  });

  ConflictModel copyWith({
    String? id,
    String? fileId,
    List<String>? conflictingVersionIds,
    DateTime? detectedAt,
    String? resolutionStrategy,
    String? resolvedVersionId,
  }) {
    return ConflictModel(
      id: id ?? this.id,
      fileId: fileId ?? this.fileId,
      conflictingVersionIds: conflictingVersionIds ?? this.conflictingVersionIds,
      detectedAt: detectedAt ?? this.detectedAt,
      resolutionStrategy: resolutionStrategy ?? this.resolutionStrategy,
      resolvedVersionId: resolvedVersionId ?? this.resolvedVersionId,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fileId': fileId,
        'conflictingVersionIds': conflictingVersionIds,
        'detectedAt': detectedAt.toIso8601String(),
        'resolutionStrategy': resolutionStrategy,
        'resolvedVersionId': resolvedVersionId,
      };

  factory ConflictModel.fromJson(Map<String, dynamic> json) => ConflictModel(
        id: json['id'] as String,
        fileId: json['fileId'] as String,
        conflictingVersionIds:
            List<String>.from(json['conflictingVersionIds'] as List),
        detectedAt: DateTime.parse(json['detectedAt'] as String),
        resolutionStrategy: json['resolutionStrategy'] as String,
        resolvedVersionId: json['resolvedVersionId'] as String?,
      );

  @override
  List<Object?> get props => [
        id,
        fileId,
        conflictingVersionIds,
        detectedAt,
        resolutionStrategy,
        resolvedVersionId,
      ];
}
