import 'package:flutter/material.dart';

class AIChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Chat"),
        backgroundColor: const Color(0xFFF5F0FF),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message['isUser'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: message['isUser'] ? Color.fromARGB(255, 239, 222, 214): Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      message['text'],
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    ),
                  ),
                ),
                SizedBox(width: 1.0),
                IconButton(
                  icon: Icon(Icons.send),
                  iconSize: 35,
                  color: Color.fromARGB(255, 255, 194, 166),
                  onPressed: () {
                    sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final TextEditingController messageController = TextEditingController();
  final List<Map<String, dynamic>> messages = [
    {"text": "Hello! How can I help you today?", "isUser": false},
  ];

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      messages.add({"text": text, "isUser": true});
      messageController.clear();
      // Add a reply from AI (you can replace this with AI response logic)
      messages.add({"text": "This is an automated response from the AI.", "isUser": false});
    }
  }
}
