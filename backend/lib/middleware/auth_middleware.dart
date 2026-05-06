import 'dart:convert';
import 'package:shelf/shelf.dart';

Middleware errorHandlingMiddleware() {
  return (innerHandler) {
    return (request) {
      try {
        return innerHandler(request);
      } catch (e) {
        print('Error: $e');
        return Response.internalServerError(
          body: jsonEncode({
            'error': 'Internal Server Error',
            'message': e.toString(),
          }),
          headers: {'Content-Type': 'application/json'},
        );
      }
    };
  };
}

Middleware authMiddleware() {
  return (innerHandler) {
    return (request) {
      final authHeader = request.headers['Authorization'];

      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        if (request.url.path == 'health' || request.url.path == 'api/health') {
          return innerHandler(request);
        }
        return Response.unauthorized(
          jsonEncode({'error': 'Missing or invalid authorization token'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return innerHandler(request);
    };
  };
}
