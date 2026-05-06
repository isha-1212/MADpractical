import 'package:flutter/material.dart';
import '../models/index.dart';
import '../services/index.dart';

class VersionProvider extends ChangeNotifier {
  final ConflictResolutionService conflictService;
  Map<String, List<FileVersionModel>> _versionsByFile = {};

  VersionProvider(this.conflictService);

  Map<String, List<FileVersionModel>> get versionsByFile => _versionsByFile;

  void loadVersions(String fileId) {
    _versionsByFile[fileId] = conflictService.getVersionsForFile(fileId);
    notifyListeners();
  }

  List<FileVersionModel> getVersionsForFile(String fileId) {
    return _versionsByFile[fileId] ?? [];
  }
}
