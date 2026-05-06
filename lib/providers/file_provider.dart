import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/index.dart';
import '../services/index.dart';

class FileProvider extends ChangeNotifier {
  final FileService fileService;
  final ApiService apiService;
  List<FileModel> _files = [];
  List<FileModel> _filteredFiles = [];
  bool _isLoading = false;
  String? _selectedFilter;

  FileProvider(this.fileService, this.apiService) {
    loadFiles();
  }

  List<FileModel> get files => _files;
  List<FileModel> get filteredFiles => _filteredFiles;
  bool get isLoading => _isLoading;
  String? get selectedFilter => _selectedFilter;

  Future<void> loadFiles() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // First, try to fetch from API
      final remoteFiles = await apiService.fetchRemoteFiles();
      if (remoteFiles.isNotEmpty) {
        // Convert API response to FileModel list
        _files = remoteFiles.map((file) {
          return FileModel(
            id: file['id'] ?? '',
            name: file['name'] ?? '',
            fileType: file['file_type'] ?? '',
            description: file.containsKey('description') ? file['description'] : '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isShared: (file['is_shared'] ?? 0) == 1,
            latestVersion: file['latest_version'] ?? 1,
            ownerId: file.containsKey('owner_id') ? file['owner_id'] : 'unknown',
          );
        }).toList();
        
        // Save to local storage
        for (final file in _files) {
          await fileService.storageService.addFile(file);
        }
      } else {
        // Fallback to local storage if API returns empty
        _files = fileService.getAllFiles();
      }
    } catch (e) {
      // If API fails, use local storage
      _files = fileService.getAllFiles();
    }
    
    _filteredFiles = _files;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createFile({
    required String name,
    required String fileType,
    required String description,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await fileService.createFile(
        name: name,
        fileType: fileType,
        description: description,
      );
      await loadFiles();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateFile({
    required String fileId,
    required String description,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await fileService.updateFile(
        fileId: fileId,
        description: description,
      );
      await loadFiles();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> shareFile(String fileId, String userId) async {
    try {
      await fileService.shareFile(fileId, userId);
      await loadFiles();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFile(String fileId) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Remove from local state immediately for instant feedback
      _files.removeWhere((f) => f.id == fileId);
      _filteredFiles.removeWhere((f) => f.id == fileId);
      notifyListeners();
      
      // Delete from storage
      await fileService.deleteFile(fileId);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
    _isLoading = false;
    notifyListeners();
  }

  void searchFiles(String query) {
    if (query.isEmpty) {
      _filteredFiles = _files;
    } else {
      _filteredFiles = fileService.searchFiles(query);
    }
    notifyListeners();
  }

  void filterByFileType(String fileType) {
    _selectedFilter = fileType;
    if (fileType.isEmpty) {
      _filteredFiles = _files;
    } else {
      _filteredFiles = fileService.filterByFileType(fileType);
    }
    notifyListeners();
  }

  void showSharedFiles() {
    _selectedFilter = 'shared';
    _filteredFiles = fileService.getSharedWithMe();
    notifyListeners();
  }

  void showPersonalFiles() {
    _selectedFilter = 'personal';
    _filteredFiles = fileService.getPersonalFiles();
    notifyListeners();
  }

  void clearFilter() {
    _selectedFilter = null;
    _filteredFiles = _files;
    notifyListeners();
  }
}
