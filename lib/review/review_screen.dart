import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewScreen extends StatefulWidget {
  final String workerId;
  final String workerName;
  final String category;

  const ReviewScreen({
    Key? key,
    required this.workerId,
    required this.workerName,
    required this.category,
  }) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  Map<String, dynamic>? _workerRatings;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchWorkerRatings();
  }

  Future<void> _fetchWorkerRatings() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/get_worker_rating/${widget.workerId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _workerRatings = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load ratings';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _submitReview() async {
    if (_reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a review')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/analyze_sentiment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'text': _reviewController.text,
          'worker_id': widget.workerId,
          'category': widget.category,
        }),
      );

      if (response.statusCode == 200) {
        // Refresh ratings after successful review
        await _fetchWorkerRatings();
        _reviewController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit review')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildRatingCard(String attribute, double score) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              attribute.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: score,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                score > 0.7
                    ? Colors.green
                    : score > 0.4
                        ? Colors.orange
                        : Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(score * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                color: score > 0.7
                    ? Colors.green
                    : score > 0.4
                        ? Colors.orange
                        : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.workerName}\'s Reviews'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Worker Info Card
                      Card(
                        margin: const EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.workerName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Category: ${widget.category}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Total Reviews: ${_workerRatings?['total_reviews'] ?? 0}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Attribute Ratings
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Attribute Ratings',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (_workerRatings?['attribute_scores'] != null)
                        ...(_workerRatings!['attribute_scores']
                                as Map<String, dynamic>)
                            .entries
                            .map((entry) => _buildRatingCard(
                                  entry.key,
                                  (entry.value as num).toDouble(),
                                ))
                            .toList(),

                      // Review Input
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Write a Review',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _reviewController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: 'Share your experience...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _submitReview,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Submit Review',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
