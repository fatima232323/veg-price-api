import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../review/review_screen.dart';

class WorkerListScreen extends StatefulWidget {
  final String category;

  const WorkerListScreen({Key? key, required this.category}) : super(key: key);

  @override
  _WorkerListScreenState createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  List<dynamic> _workers = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchTopWorkers();
  }

  Future<void> _fetchTopWorkers() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/get_top_workers/${widget.category}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _workers = data['top_workers'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load workers';
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

  Widget _buildAttributeBar(
      String attribute, int count, int totalReviews, bool isPositive) {
    final percentage = (count / totalReviews * 100).toStringAsFixed(1);
    final value = count / totalReviews;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '${isPositive ? "✓" : "✗"} ${attribute}: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                isPositive ? Colors.green : Colors.red,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$percentage%',
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerCard(int index, Map<String, dynamic> worker) {
    final score = worker['score'] as double;
    final positiveAttributes =
        worker['positive_attributes'] as Map<String, dynamic>;
    final negativeAttributes =
        worker['negative_attributes'] as Map<String, dynamic>;
    final totalReviews = worker['total_reviews'] as int;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewScreen(
                workerId: worker['worker_id'],
                workerName: 'Worker ${index + 1}',
                category: widget.category,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '#${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Worker ${index + 1}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Total Reviews: $totalReviews',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: score > 0.7
                          ? Colors.green
                          : score > 0.4
                              ? Colors.orange
                              : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${(score * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Positive Attributes:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              ...positiveAttributes.entries.map((entry) => _buildAttributeBar(
                    entry.key,
                    entry.value as int,
                    totalReviews,
                    true,
                  )),
              const SizedBox(height: 16),
              const Text(
                'Negative Attributes:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              ...negativeAttributes.entries.map((entry) => _buildAttributeBar(
                    entry.key,
                    entry.value as int,
                    totalReviews,
                    false,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top ${widget.category} Workers'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : RefreshIndicator(
                  onRefresh: _fetchTopWorkers,
                  child: ListView.builder(
                    itemCount: _workers.length,
                    itemBuilder: (context, index) {
                      return _buildWorkerCard(index, _workers[index]);
                    },
                  ),
                ),
    );
  }
}
