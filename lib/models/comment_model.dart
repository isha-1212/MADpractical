import 'package:equatable/equatable.dart';

class CommentModel extends Equatable {
  final String id;
  final String fileId;
  final String userId;
  final String username;
  final String text;
  final DateTime createdAt;

  const CommentModel({
    required this.id,
    required this.fileId,
    required this.userId,
    required this.username,
    required this.text,
    required this.createdAt,
  });

  CommentModel copyWith({
    String? id,
    String? fileId,
    String? userId,
    String? username,
    String? text,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      fileId: fileId ?? this.fileId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fileId': fileId,
        'userId': userId,
        'username': username,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json['id'] as String,
        fileId: json['fileId'] as String,
        userId: json['userId'] as String,
        username: json['username'] as String,
        text: json['text'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  @override
  List<Object?> get props => [id, fileId, userId, username, text, createdAt];
}
