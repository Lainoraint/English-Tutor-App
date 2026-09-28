import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String code;
  final String message;

  ApiException(this.code, this.message);

  @override
  String toString() => message;
}

class ApiClient {
  static const String baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8000');
  static const String appToken = String.fromEnvironment('APP_TOKEN', defaultValue: 'dxeYl09vyUf7ZkbXiIG8WrbYwZK90Bxr');

  final String deviceId;
  final http.Client _client = http.Client();

  ApiClient({required this.deviceId});

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$path'),
        headers: {
          'Content-Type': 'application/json',
          'X-Device-Id': deviceId,
          'X-App-Token': appToken,
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 60));

      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data as Map<String, dynamic>;
      }

      if (data is Map && data.containsKey('error')) {
        final err = data['error'];
        throw ApiException(err['code'] ?? 'unknown', err['message'] ?? 'An unknown error occurred.');
      }

      throw ApiException('unknown', 'Server returned status ${response.statusCode}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('network_error', 'Failed to connect to the server. Please try again.');
    }
  }

  Future<void> healthCheck() async {
    try {
      await _client.get(Uri.parse('$baseUrl/health')).timeout(const Duration(seconds: 10));
    } catch (_) {
      // Ignore errors for background health check
    }
  }
}
