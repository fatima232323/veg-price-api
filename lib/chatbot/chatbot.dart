import 'package:dialogflow_flutter/dialogflowFlutter.dart';
import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:dialogflow_flutter/language.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:servicehub/drawer/sidedrawer.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // ScrollController
  List<Map> messages = [];

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add(
            {'data': 0, 'message': _controller.text}); // Add message to end
      });

      AuthGoogle authGoogle =
          await AuthGoogle(fileJson: "assets/json/dialog_flow_auth.json")
              .build();
      DialogFlow dialogflow =
          DialogFlow(authGoogle: authGoogle, language: Language.english);
      AIResponse response = await dialogflow.detectIntent(_controller.text);

      setState(() {
        messages.add({
          'data': 1,
          'message': response.getMessage()
        }); // Add bot response to end
      });

      _controller.clear();

      // Scroll to the bottom after adding the message
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("How can we help?"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Set the scroll controller here
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: messages[index]['data'] == 0
                      ? Alignment.centerRight // User's message
                      : Alignment.centerLeft, // Bot's response
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: messages[index]['data'] == 0
                            ? Colors.brown // User message color (brown)
                            : Colors.brown[
                                100], // Bot message color (lighter brown)
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Text(
                        messages[index]['message'],
                        style: TextStyle(
                          color: messages[index]['data'] == 0
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.brown[50], // Light brown background
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 128, 100, 91)),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.brown[700]),
                  onPressed: _sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<TextEditingController>('_controller', _controller));
  }
}
