import 'package:flutter/material.dart'; // Import the material package
import 'dart:convert'; // Import the dart:convert library
import 'package:http/http.dart' as http; // Import the http package
import 'package:nuranest/utils/storage_helper.dart'; // Import the getToken function
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import the dotenv package

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  _AIChatPageState createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  List<Map<String, dynamic>> messages = [
    {"isBot": true, "text": "Hi Supun, How can I help you today?"},
  ];

  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  Future<void> sendMessage(String userMessage) async {
    setState(() {
      messages.add({"isBot": false, "text": userMessage});
      isLoading = true;
    });

    final token = getToken();

    final chatApiUrl = dotenv.env['CHAT_API_URL'];

    final url = Uri.parse('$chatApiUrl');

    void addBotMessage(String text) {
      setState(() {
        messages.add({"isBot": true, "text": text});
        isLoading = false;
      });
    }

    if (token == null) {
      addBotMessage("No access token available. Please log in again.");
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({"message": userMessage}),
        //body: json.encode({"query": userMessage}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        addBotMessage(data['response'] ?? "No response from server.");
      } else {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        addBotMessage(errorData['message'] ?? "Failed to process the request.");
      }
    } catch (error) {
      debugPrint("Error sending message: $error");
      addBotMessage("Error connecting to the server. Please try again later.");
    }
  }

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
                      alignment: message['isBot']
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 8.0),
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: message['isBot']
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
                  })),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                    ),
                  ),
                ),
                SizedBox(width: 1.0),
                IconButton(
                  icon: Icon(Icons.send),
                  iconSize: 35,
                  color: Color.fromARGB(255, 255, 194, 166),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      sendMessage(_controller.text.trim());
                      _controller.clear();
                    }
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
