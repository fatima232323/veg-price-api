import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;

class ReviewService {
  // Use different URLs based on platform
  static String get baseUrl {
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:5000'; // Android emulator
      }
    } catch (e) {
      // Web platform or other
    }
    return 'http://127.0.0.1:5000'; // Default for web/Windows
  }

  Future<String> analyzeSentiment(String text) async {
    try {
      print('Sending request to: $baseUrl/analyze_sentiment');
      print('Request body: ${json.encode({'text': text})}');

      final response = await http.post(
        Uri.parse('$baseUrl/analyze_sentiment'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'text': text}),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['sentiment'] != null) {
          return data['sentiment'];
        } else {
          throw Exception('No sentiment in response');
        }
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Failed to analyze sentiment');
      }
    } catch (e) {
      print('Error in analyzeSentiment: $e');
      throw Exception('Error analyzing sentiment: $e');
    }
  }

  // Add more API methods here as needed
  Future<List<Map<String, dynamic>>> getReviews(String bidId) async {
    try {
      // TODO: Replace with actual API call once backend is ready
      await Future.delayed(const Duration(seconds: 1));
      return [
        {
          'id': '1',
          'user': 'John Doe',
          'rating': 4.5,
          'comment': 'Great service, very professional!',
          'sentiment': 'positive',
          'date': '2024-03-20',
        },
        {
          'id': '2',
          'user': 'Jane Smith',
          'rating': 5.0,
          'comment': 'Excellent work and communication',
          'sentiment': 'positive',
          'date': '2024-03-19',
        },
      ];
    } catch (e) {
      print('Error in getReviews: $e');
      throw Exception('Error fetching reviews: $e');
    }
  }

  Future<void> submitReview({
    required String bidId,
    required String comment,
    required double rating,
  }) async {
    try {
      // First analyze the sentiment
      final sentiment = await analyzeSentiment(comment);

      // TODO: Replace with actual API call once backend is ready
      await Future.delayed(const Duration(seconds: 1));

      print('Review submitted successfully with sentiment: $sentiment');
    } catch (e) {
      print('Error in submitReview: $e');
      throw Exception('Error submitting review: $e');
    }
  }

  Future<bool> checkServerHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'healthy' && data['model_loaded'] == true;
      }
      return false;
    } catch (e) {
      print('Error checking server health: $e');
      return false;
    }
  }
}
