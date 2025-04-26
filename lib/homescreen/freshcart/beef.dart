import 'dart:math';
import 'package:flutter/material.dart';

class BeefScreen extends StatefulWidget {
  @override
  _BeefScreenState createState() => _BeefScreenState();
}

class _BeefScreenState extends State<BeefScreen> {
  final Random _random = Random();
  String selectedKeema = '';

  final List<Map<String, String>> meatOptions = [
    {"title": "Keema", "desc": "Finely minced meat", "image": "keema1"},
    {
      "title": "Ran ",
      "desc": "Dawat at your home, Prepare ran",
      "image": "ran"
    },
    {
      "title": "Kalejee",
      "desc": "Rich in nutrients and flavor",
      "image": "cow2"
    },
    {"title": "champ", "desc": "Craving for some champain! ", "image": "ribs"},
    {"title": "payee", "desc": "Cook payee with us ", "image": "payee"},
  ];

  void showKeemaPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Select Keema Type", textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Ran Keema"),
                leading: Icon(Icons.food_bank, color: Colors.brown),
                onTap: () {
                  setState(() {
                    selectedKeema = "Ran Keema";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Chest Keema"),
                leading: Icon(Icons.fastfood, color: Colors.redAccent),
                onTap: () {
                  setState(() {
                    selectedKeema = "Chest Keema";
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  double generateRandomPrice() {
    return (500 + _random.nextDouble() * 1500).roundToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(150, 145, 64, 138),
        title: Text("Beef", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/cow.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: meatOptions.length,
              itemBuilder: (context, index) {
                final item = meatOptions[index];
                double price = generateRandomPrice();
                bool isKeema = item["title"] == "Keema";
                return Container(
                  color: isKeema
                      ? Color.fromARGB(150, 145, 64, 138)
                      : Colors.transparent,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  padding: isKeema ? EdgeInsets.all(12) : EdgeInsets.zero,
                  child: Card(
                    elevation: isKeema ? 6 : 2,
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: Image.asset(
                        "assets/${item["image"]}.jpg",
                        width: isKeema ? 75 : 55,
                        height: isKeema ? 75 : 55,
                      ),
                      title: Text(
                        item["title"]!,
                        style: TextStyle(
                          fontSize: isKeema ? 20 : 16,
                          fontWeight:
                              isKeema ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                        "${item["desc"]!} - Rs. ${price.toStringAsFixed(2)} per kg",
                      ),
                      trailing: isKeema
                          ? ElevatedButton(
                              onPressed: showKeemaPopup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(227, 145, 64, 138),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 14),
                              ),
                              child: Text(
                                "Select",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {},
                              child: Text("Add"),
                            ),
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
