import 'package:flutter/material.dart';
import '../services/review_service.dart';

class BidReviewScreen extends StatefulWidget {
  final Map<String, dynamic> bidData;

  const BidReviewScreen({Key? key, required this.bidData}) : super(key: key);

  @override
  _BidReviewScreenState createState() => _BidReviewScreenState();
}

class _BidReviewScreenState extends State<BidReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  final ReviewService _reviewService = ReviewService();
  List<Map<String, dynamic>> reviews = [];
  bool isLoading = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() {
      isLoading = true;
    });

    try {
      final loadedReviews =
          await _reviewService.getReviews(widget.bidData['id']);
      setState(() {
        reviews = loadedReviews;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading reviews: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _submitReview() async {
    if (_reviewController.text.isEmpty) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      // First analyze the sentiment
      final sentiment =
          await _reviewService.analyzeSentiment(_reviewController.text);

      // Submit the review
      await _reviewService.submitReview(
        bidId: widget.bidData['id'],
        comment: _reviewController.text,
        rating: 5.0, // You might want to add a rating picker in the UI
      );

      // Add the review to the list
      setState(() {
        reviews.insert(0, {
          'user': 'Current User',
          'rating': 5.0,
          'comment': _reviewController.text,
          'sentiment': sentiment,
          'date': DateTime.now().toString().split(' ')[0],
        });
      });

      _reviewController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting review: $e')),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bid Details & Reviews'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bid Details Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bid Amount: \$${widget.bidData['amount'] ?? '0'}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Service: ${widget.bidData['service'] ?? 'Not specified'}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Provider: ${widget.bidData['provider'] ?? 'Unknown'}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: 8),
                  if (widget.bidData['items'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected Items:',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        const SizedBox(height: 4),
                        ...(widget.bidData['items'] as Map<String, int>)
                            .entries
                            .map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '• ${entry.key} (Qty: ${entry.value})',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                ],
              ),
            ),

            // Review Input Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Write a Review',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      hintText: 'Share your experience...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: isSubmitting ? null : _submitReview,
                    child: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Submit Review'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Reviews List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Reviews',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              review['user'],
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: review['sentiment'] == 'positive'
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                review['sentiment'],
                                style: TextStyle(
                                  color: review['sentiment'] == 'positive'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(review['comment']),
                        const SizedBox(height: 8),
                        Text(
                          'Posted on ${review['date']}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
