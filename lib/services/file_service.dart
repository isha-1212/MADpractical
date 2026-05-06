import 'package:uuid/uuid.dart';
import '../models/index.dart';
import 'local_storage_service.dart';

class FileService {
  final LocalStorageService storageService;
  static const uuid = Uuid();
  static const String currentUserId = 'user_001';
  static const String currentUsername = 'Current User';

  FileService(this.storageService);

  Future<FileModel> createFile({
    required String name,
    required String fileType,
    required String description,
  }) async {
    final file = FileModel(
      id: uuid.v4(),
      name: name,
      fileType: fileType,
      description: description,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isShared: false,
      latestVersion: 1,
      ownerId: currentUserId,
    );

    await storageService.addFile(file);

    final version = FileVersionModel(
      id: uuid.v4(),
      fileId: file.id,
      versionNumber: 1,
      createdAt: DateTime.now(),
      createdBy: currentUserId,
      changeDescription: 'Initial version',
    );

    await storageService.addVersion(version);

    await storageService.addToSyncQueue({
      'type': 'CREATE_FILE',
      'fileId': file.id,
      'timestamp': DateTime.now().toIso8601String(),
    });

    return file;
  }

  Future<void> updateFile({
    required String fileId,
    required String description,
  }) async {
    final file = storageService.getFile(fileId);
    if (file != null) {
      final newVersionNumber = file.latestVersion + 1;

      final updatedFile = file.copyWith(
        updatedAt: DateTime.now(),
        latestVersion: newVersionNumber,
        description: description,
      );

      await storageService.updateFile(updatedFile);

      final version = FileVersionModel(
        id: uuid.v4(),
        fileId: fileId,
        versionNumber: newVersionNumber,
        createdAt: DateTime.now(),
        createdBy: currentUserId,
        changeDescription: 'Updated file',
      );

      await storageService.addVersion(version);

      await storageService.addToSyncQueue({
        'type': 'UPDATE_FILE',
        'fileId': fileId,
        'versionNumber': newVersionNumber,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  List<FileModel> getAllFiles() {
    return storageService.getAllFiles();
  }

  List<FileModel> getPersonalFiles() {
    return getAllFiles()
        .where((file) => !file.isShared && file.ownerId == currentUserId)
        .toList();
  }

  List<FileModel> searchFiles(String query) {
    final allFiles = getAllFiles();
    return allFiles
        .where((file) =>
            file.name.toLowerCase().contains(query.toLowerCase()) ||
            file.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<FileModel> filterByFileType(String fileType) {
    return getAllFiles()
        .where((file) => file.fileType.toLowerCase() == fileType.toLowerCase())
        .toList();
  }

  List<FileModel> getSharedWithMe() {
    return getAllFiles().where((file) => file.isShared).toList();
  }

  Future<void> shareFile(String fileId, String sharedWithUserId) async {
    final file = storageService.getFile(fileId);
    if (file != null) {
      final updatedFile = file.copyWith(isShared: true);
      await storageService.updateFile(updatedFile);

      final sharedFile = SharedFileModel(
        id: uuid.v4(),
        fileId: fileId,
        sharedBy: currentUserId,
        sharedWith: sharedWithUserId,
        sharedAt: DateTime.now(),
        accessLevel: 'VIEW',
      );

      await storageService.addSharedFile(sharedFile);

      await storageService.addToSyncQueue({
        'type': 'SHARE_FILE',
        'fileId': fileId,
        'sharedWith': sharedWithUserId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> deleteFile(String fileId) async {
    await storageService.deleteFile(fileId);
    await storageService.addToSyncQueue({
      'type': 'DELETE_FILE',
      'fileId': fileId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
