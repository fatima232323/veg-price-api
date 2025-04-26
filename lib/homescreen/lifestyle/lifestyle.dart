/*import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:servicehub/homescreen/lifestyle/maid.dart';

class LifestyleAssistanceDialog extends StatelessWidget {
  final List<Map<String, dynamic>> lifestyleAssistanceSubCategories = [
    {"name": "Maid", "image": "assets/maid12.png"},
    {"name": "Driver", "image": "assets/driver12.png"},
  ];

  void navigateToScreen(BuildContext context, String category) {
    if (category == "Maid") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MaidServiceApp()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Dialog(
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Popular services",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20, // Increased spacing between columns
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: lifestyleAssistanceSubCategories.length,
                    itemBuilder: (context, index) {
                      final subcategory =
                          lifestyleAssistanceSubCategories[index];
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {},
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 150,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: Offset(4, 4),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Text(
                                      subcategory["name"],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: index < 2
                                    ? 5
                                    : index == 2
                                        ? -12
                                        : index == 3
                                            ? -12
                                            : index == 4
                                                ? -15
                                                : -8,
                                right: 15,
                                child: Image.asset(
                                  subcategory["image"],
                                  width: (index == 2)
                                      ? 110
                                      : (index == 3)
                                          ? 120
                                          : (index == 4)
                                              ? 125
                                              : 105,
                                  height: (index == 2)
                                      ? 120
                                      : (index == 3)
                                          ? 125
                                          : (index == 4)
                                              ? 130
                                              : 110,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:servicehub/homescreen/lifestyle/maid.dart'; // Ensure this path is correct

class LifestyleAssistanceDialog extends StatelessWidget {
  final List<Map<String, dynamic>> lifestyleAssistanceSubCategories = [
    {"name": "Maid", "image": "assets/maid12.png"},
    {"name": "Driver", "image": "assets/driver12.png"},
  ];

  void navigateToScreen(BuildContext context, String category) {
    if (category == "Maid") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MaidServiceScreen()), // Corrected navigation
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Dialog(
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Popular Services",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: lifestyleAssistanceSubCategories.length,
                    itemBuilder: (context, index) {
                      final subcategory =
                          lifestyleAssistanceSubCategories[index];
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            navigateToScreen(context, subcategory["name"]);
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 150,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: Offset(4, 4),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Text(
                                      subcategory["name"],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -5,
                                right: 15,
                                child: Image.asset(
                                  subcategory["image"],
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
