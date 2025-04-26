import 'dart:math';
import 'package:flutter/material.dart';

class ChickenMenuScreen extends StatelessWidget {
  final List<Map<String, String>> chickenItems = [
    {
      "title": "Whole Chicken",
      "desc": "Perfect for your Dawat!",
      "image": "wholechicken"
    },
    {
      "title": "Leg Piece",
      "desc": "Crispy, juicy, and flavorful!",
      "image": "legpiece"
    },
    {
      "title": "Boneless ",
      "desc": "Get the best boneless chicken ",
      "image": "chest"
    },
    {"title": "Wings", "desc": "Bite-sized delight!", "image": "wings"},
  ];

  final Random _random = Random();

  double generateRandomPrice() {
    return (800 + _random.nextDouble() * 500).roundToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 214, 152, 181),
        title: Text("Chicken Menu", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/chickenmain.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            color: Color.fromARGB(207, 158, 64, 88),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            padding: EdgeInsets.all(12),
            child: Card(
              elevation: 6,
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: Image.asset("assets/wholechicken.jpg",
                    width: 75, height: 75),
                title: Text(
                  "Whole Chicken",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    "Perfect for your Dawat! - Rs. ${generateRandomPrice().toStringAsFixed(2)} per kg"),
                trailing: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(226, 175, 53, 83),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  child: Text("Add",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chickenItems.length - 1,
              itemBuilder: (context, index) {
                final item = chickenItems[index + 1];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.asset("assets/${item["image"]}.jpg",
                        width: 55, height: 55),
                    title: Text(item["title"]!),
                    subtitle: Text(
                        "${item["desc"]!} - Rs. ${generateRandomPrice().toStringAsFixed(2)} per kg"),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      child: Text("Add"),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
