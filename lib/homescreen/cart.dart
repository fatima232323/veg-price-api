import 'package:flutter/material.dart';
import 'package:servicehub/drawer/sidedrawer.dart';
import 'package:servicehub/homescreen/schedule.dart';
import 'package:servicehub/screens/bid_review_screen.dart';

class CartScreen extends StatefulWidget {
  final Map<String, int> itemCounts;
  final Map<String, String> itemImages;
  final String screenTitle;

  CartScreen({
    required this.itemCounts,
    required this.itemImages,
    required this.screenTitle,
  });

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final double unitPrice = 500;
  Map<String, bool> selectedItems = {};

  @override
  void initState() {
    super.initState();
    widget.itemCounts.forEach((key, value) {
      selectedItems[key] = true; // Now all items are checked by default
    });
  }

  void incrementCount(String title) {
    setState(() {
      widget.itemCounts[title] = (widget.itemCounts[title] ?? 0) + 1;
    });
  }

  void decrementCount(String title) {
    setState(() {
      if ((widget.itemCounts[title] ?? 0) > 1) {
        widget.itemCounts[title] = widget.itemCounts[title]! - 1;
      } else {
        widget.itemCounts.remove(title);
        selectedItems.remove(title);
      }
    });
  }

  double calculateTotalPrice() {
    double total = 0;
    widget.itemCounts.forEach((title, quantity) {
      if (selectedItems[title] == true) {
        total += unitPrice * quantity;
      }
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Checkout"),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      drawer: AppDrawer(),
      body: widget.itemCounts.isEmpty
          ? Center(
              child: Text(
                "No items in cart",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    widget.screenTitle,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(10),
                    children: widget.itemCounts.entries.map((entry) {
                      String title = entry.key;
                      String imagePath = widget.itemImages[title] ?? "default";
                      int quantity = entry.value;
                      double totalPrice = unitPrice * quantity;

                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Checkbox(
                                value: selectedItems[title] ?? false,
                                onChanged: (bool? value) {
                                  setState(() {
                                    selectedItems[title] = value!;
                                  });
                                },
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  "assets/$imagePath.jpg",
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset("assets/default.jpg",
                                        width: 80, height: 80);
                                  },
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "PKR ${totalPrice.toStringAsFixed(0)}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_circle,
                                        color: Colors.brown),
                                    onPressed: () => decrementCount(title),
                                  ),
                                  Text('$quantity',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: Icon(Icons.add_circle,
                                        color: Colors.brown),
                                    onPressed: () => incrementCount(title),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total",
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.bold)),
                          Text(
                            "PKR ${calculateTotalPrice().toStringAsFixed(0)}",
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Map<String, int> selectedOrders = {};
                              widget.itemCounts.forEach((key, value) {
                                if (selectedItems[key] == true) {
                                  selectedOrders[key] = value;
                                }
                              });

                              if (selectedOrders.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Please select at least one item."),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BidReviewScreen(
                                    bidData: {
                                      'id':
                                          'bid_${DateTime.now().millisecondsSinceEpoch}',
                                      'amount': calculateTotalPrice(),
                                      'service': widget.screenTitle,
                                      'provider':
                                          'Electrician Service Provider',
                                      'items': selectedOrders,
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.phone, color: Colors.white),
                            label: Text("Call Now",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 35, vertical: 15)),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Map<String, int> selectedOrders = {};
                              widget.itemCounts.forEach((key, value) {
                                if (selectedItems[key] == true) {
                                  selectedOrders[key] = value;
                                }
                              });

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScheduleServiceScreen(
                                    orderedItems: selectedOrders,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.schedule, color: Colors.white),
                            label: Text("Schedule for Later",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 35, vertical: 15)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
