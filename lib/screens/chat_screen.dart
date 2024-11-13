import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chatPartner;

  ChatScreen(this.chatPartner);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final List<Map<String, dynamic>> messages = [
    {"text": "Hello!", "isUser": false},
    {"text": "Hi there! How can I help?", "isUser": true},
  ];

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add({"text": text, "isUser": true});
      });
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatPartner),
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
                  alignment:
                      message['isUser'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: message['isUser']
                          ? Color.fromARGB(255, 239, 222, 214)
                          : Colors.grey[300],
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Color.fromARGB(255, 255, 194, 166),
                  iconSize: 30,
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
}
