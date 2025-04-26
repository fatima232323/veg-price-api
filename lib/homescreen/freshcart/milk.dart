import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MilkScreen extends StatefulWidget {
  @override
  _MilkScreenState createState() => _MilkScreenState();
}

class _MilkScreenState extends State<MilkScreen> {
  String selectedCategory = 'Milk';

  final List<String> categories = ['Milk', 'Yogurt'];

  final Map<String, String> descriptions = {
    'Milk':
        "Pure, fresh, and straight from the farm! Packed with nutrition and love.",
    'Yogurt':
        "Creamy, delicious, and gut-friendly! The perfect treat for your taste buds."
  };

  final Map<String, String> images = {
    'Milk': 'milk.jpg',
    'Yogurt': 'yogurt.jpg',
  };

  // Replace the ScrollController with an ItemScrollController.
  final ItemScrollController _itemScrollController = ItemScrollController();
  final Random _random = Random();

  // Scroll to a specific category by its index.
  void scrollToCategory(String category) {
    final index = categories.indexOf(category);
    _itemScrollController.scrollTo(
      index: index,
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      alignment: 0.0, // Brings the selected section to the top.
    );
  }

  // Show the quantity popup.
  void showQuantityPopup(BuildContext context, String category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Center(
            child: Text(
              "Select Quantity",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose your preferred quantity:",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 15),
              if (category == 'Milk') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: Text("1 Litre"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: Text("2 Litres"),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Enter your choice (Litres)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ] else ...[
                TextField(
                  decoration: InputDecoration(
                    labelText: "Enter quantity (Grams/Kg)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Close",
                  style: TextStyle(color: Colors.brown, fontSize: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Generate a random price (for demonstration purposes).
  double generateRandomPrice() {
    // Example: price between Rs. 50 and Rs. 150.
    return 50 + _random.nextDouble() * 100;
  }

  // Generate a random rating (for demonstration purposes).
  double generateRandomRating() {
    // Rating between 3.0 and 5.0.
    return (_random.nextDouble() * 2) + 3;
  }

  @override
  Widget build(BuildContext context) {
    // Extra bottom padding so that the last section scrolls fully to the top.
    final bottomPadding = MediaQuery.of(context).size.height * 0.6;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(216, 121, 86, 33),
        title: Text("Dairy Delights",
            style: TextStyle(color: Color.fromARGB(255, 51, 14, 0))),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header image.
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/milkmain.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),

          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                    scrollToCategory(category);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: selectedCategory == category
                          ? Colors.orange.withOpacity(0.2)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_drink, size: 20, color: Colors.brown),
                        SizedBox(width: 5),
                        Text(category),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Expanded scrollable list built with ScrollablePositionedList.
          Expanded(
            child: ScrollablePositionedList.builder(
              itemScrollController: _itemScrollController,
              itemCount: categories.length,
              padding: EdgeInsets.only(bottom: bottomPadding),
              itemBuilder: (context, index) {
                final category = categories[index];
                // For demonstration, generate a random price and rating.
                final double price = generateRandomPrice();
                final double rating = generateRandomRating();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category header.
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(category,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    // Category card.
                    Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        leading: Image.asset("assets/${images[category]}",
                            width: 55, height: 55),
                        title: Text(category,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(descriptions[category]!,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700])),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text("Rs. ${price.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green)),
                                SizedBox(width: 10),
                                Row(
                                  children: List.generate(
                                    5,
                                    (index) => Icon(
                                      index < rating
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(rating.toStringAsFixed(1),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            showQuantityPopup(context, category);
                          },
                          child: Text("Get Fresh"),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
