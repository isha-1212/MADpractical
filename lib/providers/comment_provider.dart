import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/index.dart';
import '../services/index.dart';

class CommentProvider extends ChangeNotifier {
  final CommentService commentService;
  Map<String, List<CommentModel>> _commentsByFile = {};
  String? _selectedFileId;

  CommentProvider(this.commentService);

  Map<String, List<CommentModel>> get commentsByFile => _commentsByFile;
  List<CommentModel> get currentComments =>
      _selectedFileId != null
          ? _commentsByFile[_selectedFileId] ?? []
          : [];

  void selectFile(String fileId) {
    _selectedFileId = fileId;
    loadComments(fileId);
  }

  void loadComments(String fileId) {
    _commentsByFile[fileId] = commentService.getCommentsByFileId(fileId);
    notifyListeners();
  }

  Future<void> addComment(String fileId, String text) async {
    try {
      await commentService.addComment(
        fileId: fileId,
        text: text,
      );
      loadComments(fileId);
    } catch (e) {
      rethrow;
    }
  }
}
