import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class NailServicesScreen extends StatefulWidget {
  @override
  _NailServicesScreenState createState() => _NailServicesScreenState();
}

class _NailServicesScreenState extends State<NailServicesScreen> {
  String? selectedService;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final Random _random = Random();
  String searchQuery = "";

  List<String> services = [
    "Classic",
    "Acrylic",
    "French",
    "Stiletto",
    "Body Massage"
  ];

  Map<String, List<Map<String, String>>> subcategories = {
    "Classic": [
      {
        "title": "Basic Nail Polish",
        "desc": "Simple and elegant",
        "image": "nail1"
      },
      {
        "title": "Basic Nails",
        "desc": "Simple and elegant",
        "image": "nail2"
      },
    ],
    "Acrylic": [
      {
        "title": "Acrylic Nail Extensions",
        "desc": "Long-lasting and stylish",
        "image": "nail3"
      },
      {
        "title": "Acrylic Nail Extensions (Customized)",
        "desc": "Unique designs available",
        "image": "nail4"
      },
    ],
    "French": [
      {
        "title": "French Nails",
        "desc": "Timeless beauty",
        "image": "nail5"
      },
      {
        "title": "French Nails (Customized)",
        "desc": "Elegant and classic",
        "image": "nail6"
      },
    ],
    "Stiletto": [
      {
        "title": "Stiletto Nails",
        "desc": "Bold and trendy",
        "image": "nail7"
      },
      {
        "title": "Stiletto Nails (Customized)",
        "desc": "Fierce and stylish",
        "image": "nail8"
      },
    ],
    "Body Massage": [
      {
        "title": "Relaxing Massage (Half hour)",
        "desc": "Relieves stress and tension",
        "image": "massage1"
      },
      {
        "title": "Therapeutic Massage (Half hour)",
        "desc": "Eases muscle pain and improves circulation",
        "image": "massage2"
      },
    ]
  };

  double generateRating() => (_random.nextDouble() * 2) + 3;
  int generatePrice() => (_random.nextInt(4500) + 500);

  void scrollToService(String service) {
    final index = services.indexOf(service);
    _itemScrollController.scrollTo(
      index: index,
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      alignment: 0.0,
    );
  }

  List<Map<String, dynamic>> getFilteredServices() {
    if (searchQuery.isEmpty) {
      return services.map((service) => {
        'service': service,
        'items': subcategories[service]!
      }).toList();
    }

    return services.map((service) {
      final filteredItems = subcategories[service]!.where((item) {
        final title = item['title']!.toLowerCase();
        final desc = item['desc']!.toLowerCase();
        final query = searchQuery.toLowerCase();
        return title.contains(query) || desc.contains(query);
      }).toList();

      return {
        'service': service,
        'items': filteredItems
      };
    }).where((service) => (service['items'] as List).isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).size.height * 0.4;
    final filteredServices = getFilteredServices();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 252, 182, 203),
        title: Text("Nails & Massage Services", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/massagemain.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
              decoration: InputDecoration(
                hintText: "Search services...",
                hintStyle: TextStyle(color: Color.fromARGB(255, 88, 49, 35)),
                prefixIcon: Icon(Icons.search, color: Color.fromARGB(255, 88, 49, 35)),
                filled: true,
                fillColor: const Color.fromARGB(255, 248, 246, 246),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
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
                    scrollToService(service);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: selectedService == service
                          ? Color.fromARGB(255, 243, 189, 207).withOpacity(0.2)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          service == "Body Massage" 
                            ? Icons.spa 
                            : Icons.brush,
                          size: 20,
                          color: Color.fromARGB(255, 187, 137, 145),
                        ),
                        SizedBox(width: 5),
                        Text(service),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ScrollablePositionedList.builder(
              itemScrollController: _itemScrollController,
              itemCount: filteredServices.length,
              padding: EdgeInsets.only(bottom: bottomPadding),
              itemBuilder: (context, index) {
                final service = filteredServices[index]['service'];
                final items = filteredServices[index]['items'];
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        service,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...items.map((item) {
                      final rating = generateRating();
                      final price = generatePrice();
                      return Card(
                        margin: EdgeInsets.all(10),
                        color: Color(0xFFF8F1E5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {},
                            child: Text("Book Now"),
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
