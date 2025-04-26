import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SeasonalFruitsScreen extends StatefulWidget {
  @override
  _SeasonalFruitsScreenState createState() => _SeasonalFruitsScreenState();
}

class _SeasonalFruitsScreenState extends State<SeasonalFruitsScreen> {
  final Random _random = Random();
  String selectedSeason = 'Spring Fruits (March - May)';

  final List<String> seasons = [
    'Spring Fruits (March - May)',
    'Summer Fruits (June - August)',
    'Autumn Fruits (September - November)',
    'Winter Fruits (December - February)'
  ];

  final Map<String, List<Map<String, String>>> seasonalFruits = {
    'Spring Fruits (March - May)': [
      {"title": "Strawberries", "desc": "1 kg", "image": "strawberries"},
      {"title": "Peach", "desc": "1 kg", "image": "peaches"},
      {"title": "Guava", "desc": "1 kg", "image": "guava"},
      {"title": "Apricot", "desc": "1 kg", "image": "apricot"},
    ],
    'Summer Fruits (June - August)': [
      {"title": "Mango", "desc": "1 dozen", "image": "mangoes"},
      {"title": "Watermelon", "desc": "1 piece", "image": "watermelons"},
      {"title": "Melon", "desc": "1 piece", "image": "melons"},
      {"title": "Jamun", "desc": "1 kg", "image": "jamun"},
      {"title": "Banana", "desc": "1 dozen", "image": "bananas"},
    ],
    'Autumn Fruits (September - November)': [
      {"title": "Grapes", "desc": "1 kg", "image": "grapes"},
      {"title": "Pomegranate", "desc": "1 kg", "image": "pomegranate"},
      {"title": "Apple", "desc": "1 kg", "image": "apples"},
      {"title": "Dates", "desc": "1 kg", "image": "dates"},
      {"title": "Banana", "desc": "1 dozen", "image": "bananas"},
    ],
    'Winter Fruits (December - February)': [
      {"title": "Oranges", "desc": "1 dozen", "image": "oranges"},
      {"title": "Grapefruit", "desc": "1 piece", "image": "grapefruit"},
    ],
  };

  // Use an ItemScrollController to scroll by index.
  final ItemScrollController _itemScrollController = ItemScrollController();

  void scrollToSeason(String season) {
    final index = seasons.indexOf(season);
    _itemScrollController.scrollTo(
      index: index,
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      alignment: 0.0, // Brings the selected section to the top.
    );
  }

  double generateRandomPrice() {
    return (10 + _random.nextDouble() * 40).roundToDouble();
  }

  @override
  Widget build(BuildContext context) {
    // Extra bottom padding so the last section can scroll fully to the top.
    final bottomPadding = MediaQuery.of(context).size.height * 0.6;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 214, 152, 181),
        title: Text("Seasonal Fruits", style: TextStyle(color: Colors.white)),
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
                image: AssetImage("assets/fruits.jpg"),
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
              itemCount: seasons.length,
              itemBuilder: (context, index) {
                final season = seasons[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSeason = season;
                    });
                    scrollToSeason(season);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: selectedSeason == season
                          ? Color.fromARGB(255, 243, 189, 207).withOpacity(0.2)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.eco,
                            size: 20,
                            color: Color.fromARGB(255, 187, 137, 145)),
                        SizedBox(width: 5),
                        Text(season),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Expanded scrollable list using ScrollablePositionedList.builder
          Expanded(
            child: ScrollablePositionedList.builder(
              itemScrollController: _itemScrollController,
              itemCount: seasons.length,
              padding: EdgeInsets.only(bottom: bottomPadding),
              itemBuilder: (context, index) {
                final season = seasons[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Season header
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        season,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Fruit items for this season
                    ...seasonalFruits[season]!.map((item) {
                      double price = generateRandomPrice();
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.asset("assets/${item["image"]}.jpg",
                              width: 55, height: 55),
                          title: Text(item["title"]!),
                          subtitle: Text(
                              "${item["desc"]!} - Rs. ${price.toStringAsFixed(2)}"),
                          trailing: ElevatedButton(
                            onPressed: () {},
                            child: Text("Add"),
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
