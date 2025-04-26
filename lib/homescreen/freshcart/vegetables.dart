import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SeasonalVegetablesScreen extends StatefulWidget {
  @override
  _SeasonalVegetablesScreenState createState() =>
      _SeasonalVegetablesScreenState();
}

class _SeasonalVegetablesScreenState extends State<SeasonalVegetablesScreen> {
  final Random _random = Random();
  String selectedCategory = 'Four Season Vegetables';

  final List<String> categories = [
    'Four Season Vegetables',
    'Summer Speciality',
    'Winter Speciality'
  ];

  final Map<String, List<Map<String, String>>> vegetableData = {
    'Four Season Vegetables': [
      {
        "title": "Hr Sabzi Ki Zarurat",
        "image": "",
        "desc": "",
        "special": "true"
      },
      {
        "title": "Aloo",
        "image": "potatoes",
        "desc": "Golden, crispy, mashed—potatoes are love in every bite!"
      },
      {
        "title": "Pyaaz",
        "image": "onions",
        "desc":
            "Tears of joy! Sautéed, raw, or fried—onions make everything better."
      },
      {
        "title": "Tamatar",
        "image": "tomatoes",
        "desc": "Juicy, tangy, and perfect for every desi dish!"
      },
      {
        "title": "mirchain",
        "image": "chillies",
        "desc": "Spice up your life with these little firecrackers!"
      },
      {
        "title": "adrak",
        "image": "ginger",
        "desc": "A pinch of ginger and boom! Your dish just got an upgrade."
      },
      {
        "title": "lasaan",
        "image": "garlic",
        "desc": "That garlicky aroma? Mmm, irresistible!"
      },
      {
        "title": "want to buy some salad! hmmm",
        "image": "",
        "desc": "",
        "special": "true"
      },
      {
        "title": "Band Gobhi",
        "image": "cabbage",
        "desc": "Crunchy, fresh, and great for salads & stir-fries!"
      },
      {
        "title": "kheera",
        "image": "cucumber",
        "desc": "Cool as a cucumber—perfect for summer refreshment!"
      },
      {
        "title": "podina",
        "image": "mint",
        "desc": "Minty fresh and oh-so-refreshing!"
      },
      {
        "title": "Salad Patta",
        "image": "lettuce",
        "desc": "Crisp, green, and just right for those healthy munchies."
      },
      {
        "title": "chukandar",
        "image": "beetroot",
        "desc": "Earthy, sweet, and the perfect health booster!"
      },
      {
        "title": "Lemu",
        "image": "lemon",
        "desc": "Tangy, zesty, and a burst of freshness in every dish!"
      },
      {
        "title": "dhaniya",
        "image": "corriander",
        "desc": "The perfect finishing touch to every desi meal!"
      },
      {
        "title": "Four Seasons Vegetables",
        "image": "",
        "desc": "",
        "special": "true"
      },
      {
        "title": "Shimla",
        "image": "shimla",
        "desc": "Colorful, crunchy, and full of flavor!"
      },
      {
        "title": "bengun",
        "image": "eggplant",
        "desc": "Roasted, mashed, or fried—eggplant is a treat!"
      },
      {
        "title": "Chinese Gajar",
        "image": "orangecarrot",
        "desc": "Sweet, crunchy, and great for salads or juices!"
      },
      {
        "title": "Shaljam",
        "image": "shaljam",
        "desc": "Soft, mild, and perfect for winter stews!"
      },
      {
        "title": "Palak",
        "image": "palak",
        "desc": "Loaded with iron and flavor, a must for every meal!"
      },
    ],
    'Summer Speciality': [
      {
        "title": "Bhindi",
        "image": "bhindi",
        "desc": "Want some crispy bhindi? Fried, masala, or plain—always a hit!"
      },
      {
        "title": "Karela",
        "image": "karella",
        "desc":
            "Not so bitter when cooked right! Try some delicious stuffed karela."
      },
      {
        "title": "Tinda",
        "image": "tinda",
        "desc": "Soft, juicy, and ready for a homely curry!"
      },
      {
        "title": "Arvi",
        "image": "arvi",
        "desc":
            "Soft inside, crispy outside—Arvi is the secret star of the table!"
      },
    ],
    'Winter Speciality': [
      {
        "title": "Sarson ka saag",
        "image": "sarson",
        "desc":
            "Pair it with makki ki roti and a dollop of butter—pure winter bliss!"
      },
      {
        "title": "matar",
        "image": "peas",
        "desc": "Sweet, green, and tiny bites of happiness!"
      },
      {
        "title": "Gajar",
        "image": "redcarrot",
        "desc": "Craving gajar ka halwa? These red beauties got your back!"
      },
      {
        "title": "molli",
        "image": "raddish",
        "desc": "Crisp, fresh, and perfect for parathas or a crunchy salad!"
      },
      {
        "title": "Methi",
        "image": "fenugreek",
        "desc":
            "A little methi makes every dish more flavorful and oh-so-healthy!"
      },
    ],
  };

  final ItemScrollController _itemScrollController = ItemScrollController();

  void scrollToCategory(String category) {
    final index = categories.indexOf(category);
    _itemScrollController.scrollTo(
      index: index,
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  double generateRandomPrice() {
    return (20 + _random.nextDouble() * 80).roundToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(246, 104, 170, 107),
        title: Text("Vegetables",
            style: TextStyle(color: Color.fromARGB(255, 48, 48, 48))),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/vegetablemain.jpg"),
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
                          ? Color.fromARGB(255, 67, 129, 70).withOpacity(0.2)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.eco, size: 20, color: Colors.green),
                        SizedBox(width: 5),
                        Text(category),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ScrollablePositionedList.builder(
              itemScrollController: _itemScrollController,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    ...vegetableData[category]!.map((item) {
                      if (item["special"] == "true") {
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade300,
                                Colors.green.shade700
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center, // Center content
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .center, // Center text inside column
                                children: [
                                  Text(
                                    item["title"]!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign
                                        .center, // Ensure text is centered
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    item["desc"]!,
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize:
                                            10, // Increase the font size (adjust as needed)
                                        fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.center,
                                    // Ensure description is also centered
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }

                      double price = generateRandomPrice();
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.asset(
                            "assets/${item["image"]}.jpg",
                            width: 55,
                            height: 55,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.image_not_supported),
                          ),
                          title: Text(item["title"]!),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item[
                                  "desc"]!), // Display the vegetable description
                              Text(
                                "Rs. ${price.toStringAsFixed(2)} per kg",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
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
