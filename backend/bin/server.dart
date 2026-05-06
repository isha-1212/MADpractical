import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:sqlite3/sqlite3.dart';
import 'dart:convert';
import 'dart:async';

late Database _db;

Future<void> initializeDatabase() async {
  _db = sqlite3.open('../smart_file_sharing.db');
  _db.execute('PRAGMA foreign_keys = ON;');
  print('✓ SQLite Database connected: smart_file_sharing.db');
}

Response healthCheck(Request request) {
  return Response.ok(jsonEncode({'status': 'ok', 'message': 'Backend running'}),
      headers: {'Content-Type': 'application/json'});
}

Response getFiles(Request request) {
  try {
    final result = _db.select('SELECT * FROM files LIMIT 50;');
    final files = result
        .map((row) => {
              'id': row['id'],
              'name': row['name'],
              'file_type': row['file_type'],
              'is_shared': row['is_shared'],
            })
        .toList();
    return Response.ok(jsonEncode(files),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'});
  }
}

FutureOr<Response> createFile(Request request) async {
  try {
    final body = await request.readAsString();
    final data = jsonDecode(body);
    return Response.ok(jsonEncode({'success': true, 'data': data}),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.badRequest(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'});
  }
}

FutureOr<Response> syncData(Request request) async {
  try {
    return Response.ok(jsonEncode({'synced': true}),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'});
  }
}

void main() async {
  await initializeDatabase();

  final router = Router()
    ..get('/health', healthCheck)
    ..get('/api/health', healthCheck)
    ..get('/api/files', getFiles)
    ..post('/api/files', createFile)
    ..post('/api/sync', syncData);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(router);

  shelf_io.serve(handler, 'localhost', 8080);

  print('✓ Smart File Sharing Backend Server running on http://localhost:8080');
  print('✓ SQLite Database: smart_file_sharing.db');
  print('✓ Health check: http://localhost:8080/health');
  print('✓ API endpoints: GET /api/files, POST /api/files, POST /api/sync');
  print('✓ Ready to accept requests from Flutter app');
}
