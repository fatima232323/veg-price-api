import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:servicehub/drawer/sidedrawer.dart';
import 'package:servicehub/homescreen/orderlist.dart';

class ScheduleServiceScreen extends StatefulWidget {
  final Map<String, int> orderedItems;

  ScheduleServiceScreen({Key? key, required this.orderedItems})
      : super(key: key);

  @override
  _ScheduleServiceScreenState createState() => _ScheduleServiceScreenState();
}

class _ScheduleServiceScreenState extends State<ScheduleServiceScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  List<DateTime> getDates() {
    return List.generate(
      14,
      (index) {
        DateTime now = DateTime.now().add(Duration(days: index));
        return DateTime(now.year, now.month, now.day);
      },
    );
  }

  void _confirmSchedule() {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select both a date and time."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Format date and time for passing
    String formattedDate = DateFormat("EEEE, MMMM d").format(selectedDate!);
    String formattedTime = selectedTime!.format(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderListScreen(
          scheduledDate: formattedDate,
          scheduledTime: formattedTime,
          orderedItems: widget.orderedItems,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> dates = getDates();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Schedule Service"),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text("Select Date:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    DateTime date = dates[index];
                    bool isSelected = selectedDate != null &&
                        selectedDate!.year == date.year &&
                        selectedDate!.month == date.month &&
                        selectedDate!.day == date.day;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                      child: Container(
                        width: 110,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        margin: EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.brown,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Color.fromARGB(255, 241, 238, 237)
                                : Colors.brown,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat("EEE").format(date),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.brown : Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              DateFormat("MMM d").format(date),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.brown : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              if (selectedDate != null)
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Selected Date: ${DateFormat("EEEE, MMMM d").format(selectedDate!)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: 40),
              Text("Select Time:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              SizedBox(
                height: 180,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime.now(),
                  use24hFormat: false,
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      selectedTime = TimeOfDay(
                        hour: newDateTime.hour,
                        minute: newDateTime.minute,
                      );
                    });
                  },
                ),
              ),
              SizedBox(height: 10),
              if (selectedTime != null)
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Selected Time: ${selectedTime!.format(context)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: 70),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _confirmSchedule,
          child: Text("Confirm Schedule"),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
            minimumSize: Size(double.infinity, 50),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
