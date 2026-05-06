import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import '../services/index.dart';

class SyncProvider extends ChangeNotifier {
  final ApiService apiService;
  final LocalStorageService storageService;
  bool _isOnline = false;
  bool _isSyncing = false;
  String? _syncStatus;
  Timer? _statusTimer;

  SyncProvider(this.apiService, this.storageService) {
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      _handleConnectivityChange(result);
    });
  }

  bool get isOnline => _isOnline;
  bool get isSyncing => _isSyncing;
  String? get syncStatus => _syncStatus;

  void _clearStatusAfterDelay() {
    _statusTimer?.cancel();
    _statusTimer = Timer(const Duration(seconds: 2), () {
      _syncStatus = null;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    try {
      _isOnline = await apiService.checkConnection();
      if (_isOnline) {
        await _syncData();
      }
    } catch (e) {
      _isOnline = false;
    }
    notifyListeners();
  }

  void _handleConnectivityChange(dynamic result) {
    try {
      final results = result is List ? result : [result];
      if (results.contains(ConnectivityResult.none)) {
        _isOnline = false;
      } else {
        _checkConnectivity();
      }
    } catch (e) {
      _isOnline = false;
    }
    notifyListeners();
  }


  Future<void> _syncData() async {
    if (_isSyncing) return;

    _isSyncing = true;
    _syncStatus = 'Syncing...';
    notifyListeners();

    try {
      final syncQueue = storageService.getSyncQueue();
      if (syncQueue.isNotEmpty) {
        final result = await apiService.syncData(syncQueue);
        await storageService.clearSyncQueue();
        _syncStatus = 'Sync completed';
      } else {
        _syncStatus = 'Already synced';
      }
    } catch (e) {
      _syncStatus = 'Sync failed: $e';
    }

    _isSyncing = false;
    notifyListeners();
    _clearStatusAfterDelay();
  }

  Future<void> manualSync() async {
    await _checkConnectivity();
  }
}


