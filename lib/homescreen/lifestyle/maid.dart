import 'package:flutter/material.dart';

class MaidServiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.brown[400],
        fontFamily: 'Roboto',
      ),
      home: MaidServiceScreen(),
    );
  }
}

class MaidServiceScreen extends StatefulWidget {
  @override
  _MaidServiceScreenState createState() => _MaidServiceScreenState();
}

class _MaidServiceScreenState extends State<MaidServiceScreen> {
  String selectedCategory = "";
  String? selectedSubcategory;
  bool showSubcategories = false;

  List<Map<String, String>> contractSubcategories = [
    {"name": "Contract for a Month"},
    {"name": "Contract for a Year"},
  ];

  List<Map<String, String>> eventSubcategories = [
    {"name": "Wedding Event (3 Days)"},
    {"name": "Dawat"},
  ];

  List<Map<String, String>> services = [
    {"name": "Dishwashing", "image": "assets/dishwash.webp"},
    {"name": "Cleaning", "image": "assets/cleaning.webp"},
    {"name": "Ironing", "image": "assets/iron.jpg"},
    {"name": "Washing", "image": "assets/washing.jpg"},
    {"name": "Cooking", "image": "assets/cooking.jpg"},
    {"name": "Nanny Services", "image": "assets/nanny.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Maid Services"),
        centerTitle: true,
        backgroundColor: Colors.brown[400],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/maidmain.webp"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.brown[300],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildToggleButton(Icons.work, "Contract-Based"),
                _buildToggleButton(Icons.event, "Event-Based"),
              ],
            ),
          ),
          SizedBox(height: 20),
          if (showSubcategories)
            _buildSubcategories(selectedCategory == "Contract-Based"
                ? contractSubcategories
                : eventSubcategories),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              itemCount: services.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (selectedSubcategory != null) {
                      _handleServiceSelection(services[index]["name"]!);
                    } else {
                      _showErrorPopup();
                    }
                  },
                  child: Card(
                    color: Colors.brown[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.brown[200],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: Image.asset(
                              services[index]["image"]!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          services[index]["name"]!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubcategories(List<Map<String, String>> subcategories) {
    return Wrap(
      spacing: 12,
      children: subcategories.map((subcategory) {
        return ChoiceChip(
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              subcategory["name"]!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: selectedSubcategory == subcategory["name"]
                    ? Colors.white
                    : Colors.brown[800],
              ),
            ),
          ),
          backgroundColor: Colors.brown[200],
          selectedColor: Colors.brown[600],
          elevation: 2,
          selected: selectedSubcategory == subcategory["name"],
          onSelected: (bool selected) {
            setState(() {
              selectedSubcategory = selected ? subcategory["name"] : null;
            });
          },
        );
      }).toList(),
    );
  }

  void _handleServiceSelection(String service) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Additional Details"),
          content: _buildServiceQuestions(service),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Selection Required"),
          content: Text("Please select a category before choosing a service."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildToggleButton(IconData icon, String category) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
          selectedSubcategory = null;
          showSubcategories = true;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
        decoration: BoxDecoration(
          color: selectedCategory == category
              ? Colors.brown[600]
              : Colors.brown[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Text(
              category,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceQuestions(String service) {
    String question = "";
    if (service == "Cleaning") {
      question = "How many rooms are in your house? Does it have a bath?";
    } else if (service == "Nanny Services") {
      question = "How many children do you have?";
    } else if (service == "Cooking" || service == "Dishwashing") {
      question = "How many people live in your house?";
    }
    return Text(question, style: TextStyle(fontSize: 16));
  }
}
