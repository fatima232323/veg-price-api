import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static String? _baseUrl;

  static void initialize({required String baseUrl}) {
    _baseUrl = baseUrl;
  }

  static Future<Map<String, dynamic>> analyzeSentiment(String text) async {
    if (_baseUrl == null) {
      throw Exception('API service not initialized');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/analyze_sentiment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to analyze sentiment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error analyzing sentiment: $e');
    }
  }

  static Future<Map<String, dynamic>> getWorkerRating(String workerId) async {
    if (_baseUrl == null) {
      throw Exception('API service not initialized');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_worker_rating/$workerId'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get worker rating: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting worker rating: $e');
    }
  }

  static Future<Map<String, dynamic>> getTopWorkers(String category) async {
    if (_baseUrl == null) {
      throw Exception('API service not initialized');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_top_workers/$category'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get top workers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting top workers: $e');
    }
  }
}
