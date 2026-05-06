import 'package:uuid/uuid.dart';
import '../models/index.dart';
import 'local_storage_service.dart';

class ConflictResolutionService {
  final LocalStorageService storageService;
  static const uuid = Uuid();

  ConflictResolutionService(this.storageService);

  Future<void> detectAndResolveConflicts(String fileId) async {
    final versions = storageService.getVersionsByFileId(fileId);

    if (versions.length > 1) {
      versions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final latestVersion = versions.first;

      final conflict = ConflictModel(
        id: uuid.v4(),
        fileId: fileId,
        conflictingVersionIds:
            versions.map((v) => v.id).toList(),
        detectedAt: DateTime.now(),
        resolutionStrategy: 'LATEST_TIMESTAMP',
        resolvedVersionId: latestVersion.id,
      );

      await storageService.addConflict(conflict);
    }
  }

  List<ConflictModel> getUnresolvedConflicts() {
    return storageService.getUnresolvedConflicts();
  }

  List<FileVersionModel> getVersionsForFile(String fileId) {
    final versions = storageService.getVersionsByFileId(fileId);
    versions.sort((a, b) => b.versionNumber.compareTo(a.versionNumber));
    return versions;
  }
}
