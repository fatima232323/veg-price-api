import 'package:flutter/material.dart';

class OrderListScreen extends StatelessWidget {
  final String scheduledDate;
  final String scheduledTime;
  final Map<String, int> orderedItems;
  final double unitPrice;

  const OrderListScreen({
    Key? key,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.orderedItems,
    this.unitPrice = 500, // Default unit price
  }) : super(key: key);

  double calculateTotalPrice() {
    double total = 0;
    orderedItems.forEach((key, quantity) {
      total += unitPrice * quantity;
    });
    return total;
  }

  void _placeOrder(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Order Placed"),
        content: Text("Your order has been successfully placed!"),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Ordered Items"),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Scheduled for: $scheduledDate at $scheduledTime",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Ordered Items:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: orderedItems.entries.map((entry) {
                  return ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.brown),
                    title: Text(
                      "${entry.key} (x${entry.value})",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    trailing: Text(
                      "PKR ${(entry.value * unitPrice).toStringAsFixed(0)}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ),
            Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total: PKR ${calculateTotalPrice().toStringAsFixed(0)}",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _placeOrder(context),
                child: Text("Place Order"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
