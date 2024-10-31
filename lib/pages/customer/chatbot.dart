import 'package:ecommercettl/pages/customer/profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerChatbotPage extends StatefulWidget {
  @override
  _CustomerChatbotPageState createState() => _CustomerChatbotPageState();
}

class _CustomerChatbotPageState extends State<CustomerChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> _messages = [];

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    setState(() {
      _messages.add({"sender": "customer", "message": _messageController.text});
    });

    try {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:5000/predict'), // Dùng '10.0.2.2' nếu trên giả lập, hoặc IP máy host nếu trên thiết bị thật.
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({"sentence": _messageController.text}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    String message;

    if (data['message'] is List) {
      message = (data['message'] as List).join(", ");
    } else {
      message = data['message'];
    }

    setState(() {
      _messages.add({"sender": "bot", "message": message});
    });
  } else {
    setState(() {
      _messages.add({"sender": "bot", "message": "Error: Unable to get response from chatbot."});
    });
  }
} catch (e) {
  setState(() {
    _messages.add({"sender": "bot", "message": "Error: $e"});
  });
}

    _messageController.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hỗ trợ '),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Align(
                    alignment: message['sender'] == 'customer'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: message['sender'] == 'customer'
                            ? Color(0xFF15A362)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message['message']!,
                        style: TextStyle(color: Colors.black),
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
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}