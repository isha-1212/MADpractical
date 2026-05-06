import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080';

  Future<Map<String, dynamic>> syncData(
      List<Map<String, dynamic>> syncQueue) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/sync'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'operations': syncQueue}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Sync failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Sync error: $e');
    }
  }

  Future<List<dynamic>> fetchRemoteFiles() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/files'))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to fetch files');
      }
    } catch (e) {
      throw Exception('Fetch error: $e');
    }
  }

  Future<Map<String, dynamic>> uploadFile(
      Map<String, dynamic> fileData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/files'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(fileData),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Upload failed');
      }
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }

  Future<bool> checkConnection() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/health'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
