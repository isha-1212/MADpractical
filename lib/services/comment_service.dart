import 'package:uuid/uuid.dart';
import '../models/index.dart';
import 'local_storage_service.dart';

class CommentService {
  final LocalStorageService storageService;
  static const uuid = Uuid();
  static const String currentUserId = 'user_001';
  static const String currentUsername = 'Current User';

  CommentService(this.storageService);

  Future<CommentModel> addComment({
    required String fileId,
    required String text,
  }) async {
    final comment = CommentModel(
      id: uuid.v4(),
      fileId: fileId,
      userId: currentUserId,
      username: currentUsername,
      text: text,
      createdAt: DateTime.now(),
    );

    await storageService.addComment(comment);

    await storageService.addToSyncQueue({
      'type': 'ADD_COMMENT',
      'commentId': comment.id,
      'fileId': fileId,
      'timestamp': DateTime.now().toIso8601String(),
    });

    return comment;
  }

  List<CommentModel> getCommentsByFileId(String fileId) {
    final comments = storageService.getCommentsByFileId(fileId);
    comments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return comments;
  }
}
