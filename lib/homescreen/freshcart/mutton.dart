import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MuttonScreen extends StatefulWidget {
  @override
  _MuttonScreenState createState() => _MuttonScreenState();
}

class _MuttonScreenState extends State<MuttonScreen> {
  final Random _random = Random();
  String selectedCategory = 'Goat';
  String selectedKeema = '';

  final List<String> categories = ['Goat', 'Lamb'];

  final Map<String, List<Map<String, String>>> meatOptions = {
    'Goat': [
      {"title": "Keema", "desc": "Finely minced meat", "image": "keema"},
      {
        "title": "Payee",
        "desc": "Craving for some delicious Payee?",
        "image": "leg1"
      },
      {
        "title": "Kalejee",
        "desc": "Rich in nutrients and flavor",
        "image": "liver"
      },
      {
        "title": "Champ",
        "desc": "Tender and juicy goat ribs",
        "image": "champ1"
      },
      {
        "title": "Ran",
        "desc": "Dawat at your home, Prepare ran",
        "image": "ran1"
      },
    ],
    'Lamb': [
      {"title": "Keema", "desc": "Fresh minced lamb", "image": "keema"},
      {
        "title": "Leg (Payee)",
        "desc": "Soft and flavorful leg piece",
        "image": "leg2"
      },
      {
        "title": "Liver (Kalejee)",
        "desc": "Nutritious and full of taste",
        "image": "liver2"
      },
      {
        "title": "Ribs (Champ)",
        "desc": "Delicious lamb ribs",
        "image": "champ2"
      },
      {
        "title": "Leg (Ran)",
        "desc": "Dawat at your home, Prepare ran",
        "image": "ran2"
      },
    ],
  };

  // Create an ItemScrollController to scroll by index.
  final ItemScrollController _itemScrollController = ItemScrollController();

  // Scroll to a category section by its index.
  void scrollToCategory(String category) {
    final index = categories.indexOf(category);
    _itemScrollController.scrollTo(
      index: index,
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      alignment: 0.0, // Positions the selected section at the top.
    );
  }

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

  // Generate a random price (e.g. between Rs.500 and Rs.2000).
  double generateRandomPrice() {
    return (500 + _random.nextDouble() * 1500).roundToDouble();
  }

  @override
  Widget build(BuildContext context) {
    // Extra bottom padding ensures that the last section scrolls fully to the top.
    final bottomPadding = MediaQuery.of(context).size.height * 0.6;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(228, 173, 69, 95),
        title: Text("Mutton", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header image
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/goatmain.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          // Horizontal toggle buttons
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
                          ? Color.fromARGB(255, 243, 189, 207).withOpacity(0.2)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.food_bank,
                            size: 20,
                            color: Color.fromARGB(255, 187, 137, 145)),
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category header
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Meat options for this category
                    ...meatOptions[category]!.map((item) {
                      double price = generateRandomPrice();
                      bool isKeema = item["title"] == "Keema";
                      return Container(
                        color: isKeema
                            ? Color.fromARGB(207, 158, 64, 88)
                            : Colors.transparent,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                                fontWeight: isKeema
                                    ? FontWeight.bold
                                    : FontWeight.normal,
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
                                          Color.fromARGB(226, 175, 53, 83),
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
                    }).toList(),
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
