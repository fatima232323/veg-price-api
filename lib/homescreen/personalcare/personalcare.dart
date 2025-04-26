import 'package:flutter/material.dart';
import 'package:servicehub/drawer/sidedrawer.dart';
import 'package:servicehub/homescreen/cart.dart';
import 'package:servicehub/homescreen/personalcare/facial.dart';
import 'package:servicehub/homescreen/personalcare/hair.dart';
import 'package:servicehub/homescreen/personalcare/nail.dart';
import 'package:servicehub/homescreen/personalcare/wax.dart';

class PersonalCareScreen extends StatelessWidget {
  final Map<String, int> itemCounts = {};
  final List<Map<String, dynamic>> personalCareSubCategories = [
    {
      "name": "Facial & Mani/Pedi",
      "image": "assets/facc.jpg",
      "screen": FacialServicesScreen()
    },
    {
      "name": "Waxing & Threading",
      "image": "assets/waxx.jpg",
      "screen": WaxingServicesScreen()
    },
    {
      "name": "Nails & Massage",
      "image": "assets/nailmain.jpg",
      "screen": NailServicesScreen()
    },
    {
      "name": "Hair & Makeup",
      "image": "assets/make.webp",
      "screen": HairServicesScreen()
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F1E5),
      appBar: AppBar(
        title: Text("Personal Care"),
        centerTitle: true,
        backgroundColor:Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart,
                color: const Color.fromARGB(255, 250, 249, 249)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(
                      itemCounts: Map.from(itemCounts),
                      itemImages: {},
                      screenTitle: ""),
                ),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: Text(
                "WHAT ARE\nYOU LOOKING \nFOR?",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 88, 49, 35),
                ),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: Text(
                "Categories",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 88, 49, 35),
                ),
              ),
            ),
            SizedBox(height: 35),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildServiceBox(
                            context, personalCareSubCategories[0], true, false),
                        SizedBox(height: 25),
                        _buildServiceBox(
                            context, personalCareSubCategories[2], false, true),
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      children: [
                        _buildServiceBox(
                            context, personalCareSubCategories[3], false, true),
                        SizedBox(height: 25),
                        _buildServiceBox(
                            context, personalCareSubCategories[1], true, false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceBox(BuildContext context, Map<String, dynamic> category,
      bool isSmall, bool isMedium) {
    return GestureDetector(
      onTap: () {
        if (category["screen"] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => category["screen"],
            ),
          );
        }
      },
      child: Column(
        children: [
          Container(
            height: isSmall
                ? MediaQuery.of(context).size.height * 0.15
                : isMedium
                    ? MediaQuery.of(context).size.height * 0.25
                    : MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width * 0.45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: Image.asset(
                category["image"],
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            category["name"],
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 88, 49, 35),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
