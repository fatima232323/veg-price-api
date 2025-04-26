import 'package:flutter/material.dart';
import 'dart:ui';

class EventDecorDialog extends StatelessWidget {
  final List<Map<String, dynamic>> eventDecorSubCategories = [
    {"name": "Birthday Parties", "image": "assets/bday.png"},
    {"name": "Small Gatherings", "image": "assets/eve.png"},
  ];

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
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: eventDecorSubCategories.length,
                    itemBuilder: (context, index) {
                      final subcategory = eventDecorSubCategories[index];
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -18, // Adjusting bottom position
                                right: -10, // Adjusting right position
                                child: Image.asset(
                                  subcategory["image"],
                                  width: 110, // Decreasing image width
                                  height: 120, // Decreasing image height
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
