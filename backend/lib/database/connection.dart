import 'dart:async';
import 'package:sqlite3/sqlite3.dart';

class DatabaseConnection {
  static final DatabaseConnection _instance = DatabaseConnection._internal();
  late Database _database;
  bool _initialized = false;

  DatabaseConnection._internal();

  factory DatabaseConnection() {
    return _instance;
  }

  Future<void> initialize({
    required String databasePath,
  }) async {
    if (_initialized) return;

    try {
      _database = sqlite3.open(databasePath);
      _database.execute('PRAGMA foreign_keys = ON;');
      _initialized = true;
      print('✓ SQLite database connection established at $databasePath');
    } catch (e) {
      print('✗ Database connection failed: $e');
      rethrow;
    }
  }

  Database get connection => _database;

  Future<void> close() async {
    if (_initialized) {
      _database.close();
      _initialized = false;
    }
  }

  Future<List<Map<String, dynamic>>> query(String sql,
      [List<Object?>? parameters]) async {
    if (!_initialized) {
      throw Exception('Database not initialized');
    }

    try {
      final statement = _database.prepare(sql);
      if (parameters != null) {
        statement.bind(parameters);
      }
      final result = statement.select().map((row) {
        final map = <String, dynamic>{};
        for (var i = 0; i < row.columnCount; i++) {
          map[row.columnName(i)] = row[i];
        }
        return map;
      }).toList();
      statement.dispose();
      return result;
    } catch (e) {
      print('Query error: $e');
      rethrow;
    }
  }

  Future<int> execute(String sql, [List<Object?>? parameters]) async {
    if (!_initialized) {
      throw Exception('Database not initialized');
    }

    try {
      final statement = _database.prepare(sql);
      if (parameters != null) {
        statement.bind(parameters);
      }
      statement.executeInsert();
      final changes = _database.getUpdatedRows();
      statement.dispose();
      return changes;
    } catch (e) {
      print('Execute error: $e');
      rethrow;
    }
  }

  void executeBatch(String sql) {
    if (!_initialized) {
      throw Exception('Database not initialized');
    }
    _database.execute(sql);
  }
}
