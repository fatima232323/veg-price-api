import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class PlumberServiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PlumberServiceScreen(),
    );
  }
}

class PlumberServiceScreen extends StatefulWidget {
  @override
  _PlumberServiceScreenState createState() => _PlumberServiceScreenState();
}

class _PlumberServiceScreenState extends State<PlumberServiceScreen> {
  String? selectedService;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final Random _random = Random();

  List<String> services = ["Bathroom", "Kitchen", "Geyser", "Motor"];

  // Example subcategories for each plumber service
  Map<String, List<Map<String, String>>> subcategories = {
    "Bathroom": [
      {
        "image": "bath1",
        "title": "Muslim shower installation",
        "desc": "Install new muslim shower"
      },
      {
        "image": "bath2",
        "title": "Muslim shower repair",
        "desc": "Repair old muslim shower"
      },
      {
        "image": "bath3",
        "title": "Muslim shower replacement",
        "desc": "Replace old muslim shower"
      },
      {
        "image": "bath4",
        "title": "Commode istallation",
        "desc": "Install new commode"
      },
      {
        "image": "bath5",
        "title": "Commode tank repair",
        "desc": "Repair commode tank"
      },
      {
        "image": "bath6",
        "title": "Commode tank replacement",
        "desc": "Repace old commode tank"
      },
      {
        "image": "bath7",
        "title": "Repair Faulty flush valve",
        "desc": "Repair old Faulty flush valve"
      },
      {
        "image": "bath8",
        "title": "Repair Leaky flush valve",
        "desc": "Repair old Leaky flush valve"
      },
      {
        "image": "bath9",
        "title": "Install bathroom tap",
        "desc": "Instal a new bathroon tap"
      },
      {
        "image": "bath10",
        "title": "Repair bathroom tap",
        "desc": "Repair an old bathroon tap"
      },
      {
        "image": "bath11",
        "title": "Repair Leaky/Clogged toilet",
        "desc": "Repair a faulty toilet"
      },
      {
        "image": "bath12",
        "title": "Bathroom drain cleaning",
        "desc": "Clean drainage"
      }
    ],
    "Kitchen": [
      {
        "image": "kitchen1",
        "title": "Sink Installation",
        "desc": "Install modern kitchen sinks"
      },
      {
        "image": "kitchen2",
        "title": "Tap Installation",
        "desc": "Install modern kitchen Tap"
      },
      {
        "image": "kitchen3",
        "title": "Drain Cleaning",
        "desc": "Unclog kitchen drains"
      }
    ],
    "Geyser": [
      {
        "image": "geyser1",
        "title": "Geyser Installation",
        "desc": "Install new water heaters"
      },
      {
        "image": "geyser2",
        "title": "Geyser Repair",
        "desc": "Fix faulty water heaters"
      }
    ],
    "Motor": [
      {
        "image": "motor1",
        "title": "Pump Installation",
        "desc": "Install water pumps"
      },
      {"image": "motor2", "title": "Motor Repair", "desc": "Repair pump motors"}
    ]
  };

  double generateRating() => (_random.nextDouble() * 2) + 3;
  int generatePrice() => (_random.nextInt(4500) + 500);

  @override
  Widget build(BuildContext context) {
    // Extra bottom padding so that even the last section scrolls fully to the top.
    final bottomPadding = MediaQuery.of(context).size.height * 0.4;

    return Scaffold(
      appBar: AppBar(
        title: Text("Plumbing Services"),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 108, 143, 172),
      ),
      body: Column(
        children: [
          // Header image
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/plumbermain.jpg"), // Replace with your plumber asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          // Horizontal toggle buttons
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: services.map((service) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedService = service;
                    });
                    final index = services.indexOf(service);
                    _itemScrollController.scrollTo(
                      index: index,
                      duration: Duration(milliseconds: 600),
                      curve: Curves.easeInOutCubic,
                      alignment: 0.0, // Aligns the section at the top
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: selectedService == service
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.plumbing, size: 20, color: Colors.blue),
                        SizedBox(width: 5),
                        Text(service),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Expanded scrollable list using ScrollablePositionedList
          Expanded(
            child: ScrollablePositionedList.builder(
              itemScrollController: _itemScrollController,
              itemCount: services.length,
              padding: EdgeInsets.only(bottom: bottomPadding),
              itemBuilder: (context, index) {
                final service = services[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section header
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        service,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // List of subcategories for this plumber service
                    ...subcategories[service]!.map((item) {
                      final rating = generateRating();
                      final price = generatePrice();
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.asset("assets/${item["image"]}.jpg",
                              width: 55, height: 55),
                          title: Text(item["title"]!),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item["desc"]!),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text("PKR $price",
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
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
