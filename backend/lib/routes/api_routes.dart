import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

Response healthCheck(Request request) {
  return Response.ok(jsonEncode({'status': 'healthy', 'timestamp': DateTime.now().toIso8601String()}),
      headers: {'Content-Type': 'application/json'});
}

Response syncData(Request request) async {
  try {
    final body = await request.readAsString();
    final jsonData = jsonDecode(body) as Map<String, dynamic>;
    final operations = jsonData['operations'] as List<dynamic>;

    return Response.ok(
      jsonEncode({
        'success': true,
        'message': 'Sync completed',
        'operationsProcessed': operations.length,
        'timestamp': DateTime.now().toIso8601String(),
      }),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'error': e.toString()}),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Response getFiles(Request request) {
  final mockFiles = [
    {
      'id': 'file_001',
      'name': 'Project Proposal',
      'fileType': 'DOCX',
      'description': 'Q1 Project Proposal',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'isShared': false,
      'latestVersion': 3,
      'ownerId': 'user_001',
    },
    {
      'id': 'file_002',
      'name': 'Budget Analysis',
      'fileType': 'XLSX',
      'description': 'Annual Budget Analysis 2024',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'isShared': true,
      'latestVersion': 2,
      'ownerId': 'user_002',
    },
  ];

  return Response.ok(jsonEncode(mockFiles),
      headers: {'Content-Type': 'application/json'});
}

Response uploadFile(Request request) async {
  try {
    final body = await request.readAsString();
    final fileData = jsonDecode(body) as Map<String, dynamic>;

    return Response.created(
      Uri.parse('/files/${fileData['id']}'),
      body: jsonEncode({
        'success': true,
        'fileId': fileData['id'],
        'message': 'File uploaded successfully',
      }),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'error': e.toString()}),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Middleware corsMiddleware() {
  return createCorsHeadersMiddleware(
    corsHeaders: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    },
  );
}

Middleware loggingMiddleware() {
  return (innerHandler) {
    return (request) {
      print('[${DateTime.now()}] ${request.method} ${request.url.path}');
      return innerHandler(request);
    };
  };
}
