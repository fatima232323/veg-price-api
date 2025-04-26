import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ACTechnicianServiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ACTechnicianServiceScreen(),
    );
  }
}

class ACTechnicianServiceScreen extends StatefulWidget {
  @override
  _ACTechnicianServiceScreenState createState() =>
      _ACTechnicianServiceScreenState();
}

class _ACTechnicianServiceScreenState extends State<ACTechnicianServiceScreen> {
  String? selectedService;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final Random _random = Random();

  List<String> services = [
    "Installation",
    "Uninstall/Relocate",
    "Repair",
    "Service",
    "Ducts",
    "Gas Leak/Refill"
  ];

  Map<String, List<Map<String, String>>> subcategories = {
    "Installation": [
      {
        "image": "ac1",
        "title": "Split AC Installation",
        "desc": "Professional installation of split AC units"
      },
      {
        "image": "ac2",
        "title": "Window AC Installation",
        "desc": "Efficient installation of window ACs"
      },
      {
        "image": "ac3",
        "title": "Cassette AC Installation",
        "desc": "Efficient installation of cassette ACs"
      },
    ],
    "Uninstall/Relocate": [
      {
        "image": "ac4",
        "title": "AC Uninstallation",
        "desc": "Safe removal of your AC unit"
      },
      {
        "image": "ac5",
        "title": "AC Relocation",
        "desc": "Relocate your AC unit to a new spot"
      },
    ],
    "Repair": [
      {
        "image": "ac6",
        "title": "Compressor Repair",
        "desc": "Repair faulty compressors"
      },
      {
        "image": "ac7",
        "title": "Capacitor Repair",
        "desc": "Repair faulty capacitor"
      },
      {
        "image": "ac8",
        "title": "Fan Motor Repair",
        "desc": "Fix malfunctioning fan motors"
      },
      {
        "image": "ac9",
        "title": "Thermostat Repair",
        "desc": "Repair temperature or control sensors"
      },
    ],
    "Service": [
      {
        "image": "ac12",
        "title": "Split AC Regular Service",
        "desc": "Routine maintenance for AC efficiency"
      },
      {
        "image": "ac13",
        "title": "Window AC Regular Service",
        "desc": "Routine maintenance for AC efficiency"
      },
      {
        "image": "ac14",
        "title": "Cassette AC Regular Service",
        "desc": "Routine maintenance for AC efficiency"
      },
    ],
    "Ducts": [
      {
        "image": "ac10",
        "title": "Duct Cleaning",
        "desc": "Clean and sanitize your AC ducts"
      },
      {
        "image": "ac11",
        "title": "Duct Repair",
        "desc": "Repair leaks and damage in ducts"
      },
    ],
    "Gas Leak/Refill": [
      {
        "image": "ac15",
        "title": "Leak Detection & Repair",
        "desc": "Detect and fix refrigerant leaks"
      },
      {
        "image": "ac16",
        "title": "Gas Refill",
        "desc": "Refill refrigerant gas for AC"
      },
    ],
  };

  double generateRating() => (_random.nextDouble() * 2) + 3; // 3.0 to 5.0
  int generatePrice() => (_random.nextInt(4500) + 500);

  @override
  Widget build(BuildContext context) {
    // Extra bottom padding so that even the last section scrolls fully to the top.
    final bottomPadding = MediaQuery.of(context).size.height * 0.4;

    return Scaffold(
      appBar: AppBar(
        title: Text("AC Technician Services"),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 108, 143, 172),
      ),
      body: Column(
        children: [
          // Header image for AC services
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage("assets/acmain.jpg"), // replace with your asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          // Horizontal toggle buttons for AC technician services
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
                        Icon(Icons.build,
                            size: 20,
                            color: Color.fromARGB(255, 124, 150, 172)),
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
                    // Section header for each AC technician service category
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        service,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // List of subcategories for the selected service
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
