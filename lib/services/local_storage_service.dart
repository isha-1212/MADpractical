import 'package:hive_flutter/hive_flutter.dart';
import '../models/index.dart';

class LocalStorageService {
  static const String filesBoxName = 'files';
  static const String versionsBoxName = 'versions';
  static const String commentsBoxName = 'comments';
  static const String sharedFilesBoxName = 'shared_files';
  static const String conflictsBoxName = 'conflicts';
  static const String syncQueueBoxName = 'sync_queue';

  late Box<dynamic> filesBox;
  late Box<dynamic> versionsBox;
  late Box<dynamic> commentsBox;
  late Box<dynamic> sharedFilesBox;
  late Box<dynamic> conflictsBox;
  late Box<dynamic> syncQueueBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    filesBox = await Hive.openBox(filesBoxName);
    versionsBox = await Hive.openBox(versionsBoxName);
    commentsBox = await Hive.openBox(commentsBoxName);
    sharedFilesBox = await Hive.openBox(sharedFilesBoxName);
    conflictsBox = await Hive.openBox(conflictsBoxName);
    syncQueueBox = await Hive.openBox(syncQueueBoxName);
  }

  Future<void> addFile(FileModel file) async {
    await filesBox.put(file.id, file.toJson());
  }

  Future<void> updateFile(FileModel file) async {
    await filesBox.put(file.id, file.toJson());
  }

  FileModel? getFile(String fileId) {
    final data = filesBox.get(fileId);
    if (data != null) {
      return FileModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  List<FileModel> getAllFiles() {
    return filesBox.values
        .map((file) => FileModel.fromJson(Map<String, dynamic>.from(file)))
        .toList();
  }

  Future<void> deleteFile(String fileId) async {
    await filesBox.delete(fileId);
  }

  Future<void> addVersion(FileVersionModel version) async {
    await versionsBox.put(version.id, version.toJson());
  }

  List<FileVersionModel> getVersionsByFileId(String fileId) {
    return versionsBox.values
        .where((v) =>
            Map<String, dynamic>.from(v)['fileId'] == fileId)
        .map((version) =>
            FileVersionModel.fromJson(Map<String, dynamic>.from(version)))
        .toList();
  }

  Future<void> addComment(CommentModel comment) async {
    await commentsBox.put(comment.id, comment.toJson());
  }

  List<CommentModel> getCommentsByFileId(String fileId) {
    return commentsBox.values
        .where((c) =>
            Map<String, dynamic>.from(c)['fileId'] == fileId)
        .map((comment) =>
            CommentModel.fromJson(Map<String, dynamic>.from(comment)))
        .toList();
  }

  Future<void> addSharedFile(SharedFileModel sharedFile) async {
    await sharedFilesBox.put(sharedFile.id, sharedFile.toJson());
  }

  List<SharedFileModel> getSharedFiles(String userId) {
    return sharedFilesBox.values
        .where((sf) {
          final data = Map<String, dynamic>.from(sf);
          return data['sharedWith'] == userId;
        })
        .map((sf) =>
            SharedFileModel.fromJson(Map<String, dynamic>.from(sf)))
        .toList();
  }

  Future<void> addConflict(ConflictModel conflict) async {
    await conflictsBox.put(conflict.id, conflict.toJson());
  }

  List<ConflictModel> getUnresolvedConflicts() {
    return conflictsBox.values
        .where((c) {
          final data = Map<String, dynamic>.from(c);
          return data['resolvedVersionId'] == null;
        })
        .map((c) =>
            ConflictModel.fromJson(Map<String, dynamic>.from(c)))
        .toList();
  }

  Future<void> addToSyncQueue(Map<String, dynamic> operation) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await syncQueueBox.put(timestamp, operation);
  }

  List<Map<String, dynamic>> getSyncQueue() {
    return syncQueueBox.values
        .map((op) => Map<String, dynamic>.from(op))
        .toList();
  }

  Future<void> clearSyncQueue() async {
    await syncQueueBox.clear();
  }

  Future<void> removeFromSyncQueue(int key) async {
    await syncQueueBox.delete(key);
  }

  Future<void> clear() async {
    await filesBox.clear();
    await versionsBox.clear();
    await commentsBox.clear();
    await sharedFilesBox.clear();
    await conflictsBox.clear();
  }
}
