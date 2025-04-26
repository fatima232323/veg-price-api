import 'package:flutter/material.dart';
import 'package:servicehub/homescreen/freshcart/beef.dart';
import 'package:servicehub/homescreen/freshcart/chicken.dart';
import 'dart:ui';

import 'package:servicehub/homescreen/freshcart/fruits.dart';
import 'package:servicehub/homescreen/freshcart/milk.dart';
import 'package:servicehub/homescreen/freshcart/mutton.dart';
import 'package:servicehub/homescreen/freshcart/vegetables.dart';

class FreshCartDialog extends StatelessWidget {
  final List<Map<String, dynamic>> freshCartSubCategories = [
    {"name": "Fruits", "image": "assets/fruits12.png"},
    {"name": "Vegetables", "image": "assets/vegetables12.png"},
    {"name": "Chicken", "image": "assets/chicken12.png"},
    {"name": "Mutton", "image": "assets/meat12.png"},
    {"name": "Beef", "image": "assets/beef12.png"},
    {"name": "Milk/Yogurt", "image": "assets/milk12.png"},
  ];

  void navigateToScreen(BuildContext context, String category) {
    if (category == "Fruits") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SeasonalFruitsScreen()),
      );
    }
    if (category == "Mutton") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MuttonScreen()),
      );
    }
    if (category == "Milk/Yogurt") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MilkScreen()),
      );
    }
    if (category == "Chicken") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChickenMenuScreen()),
      );
    }
    if (category == "Vegetables") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SeasonalVegetablesScreen()),
      );
    }
    if (category == "Beef") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BeefScreen()),
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
                    itemCount: freshCartSubCategories.length,
                    itemBuilder: (context, index) {
                      final subcategory = freshCartSubCategories[index];
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () =>
                              navigateToScreen(context, subcategory["name"]),
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
                                        : index == 3 || index == 4
                                            ? -10
                                            : -8,
                                right: 15,
                                child: Image.asset(
                                  subcategory["image"],
                                  width: (index == 3 || index == 4)
                                      ? 100
                                      : (index == 2)
                                          ? 130
                                          : 105,
                                  height: (index == 3 || index == 4)
                                      ? 110
                                      : (index == 2)
                                          ? 140
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
