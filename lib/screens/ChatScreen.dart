import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mapfeature_project/helper/databasehelper.dart';

class ChatBot extends StatefulWidget {
  final String userId;
  final String userName; // Add userName parameter

  const ChatBot({Key? key, required this.userId, required this.userName})
      : super(key: key);

  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _textEditingController = TextEditingController();
  List<Map<String, dynamic>> _messages =
      []; // Initialize _messages to an empty list
  bool _isBotTyping = false;
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _initMessages();
  }

  Future<void> _initMessages() async {
    _messages = await _databaseHelper.getMessages();
    if (_messages.isEmpty) {
      await _sendInitialMessages();
    }
  }

  Future<void> _sendInitialMessages() async {
    final initialMessages = [
      "Hi there! My name is Ozey and I'm here to support you on your journey to emotional well-being.",
      "How are you feeling today? Feel free to share anything that's on your mind - I'm here to listen and help.",
    ];

    for (final message in initialMessages) {
      await _databaseHelper.insertMessage({
        'message': message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'isUserMessage': false,
      });
    }
    setState(() {
      _messages = initialMessages
          .map((message) => {
                'message': message,
                'timestamp': DateTime.now().millisecondsSinceEpoch,
                'isUserMessage': false,
              })
          .toList();
    });
  }

  Future<String> _callAIModelAPI(String message, String userId) async {
    final url =
        Uri.parse('https://nationally-precise-stork.ngrok-free.app/chat');
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'user_input': message,
          'user_id': userId,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['response'];
      } else {
        throw Exception('Failed to get response from AI model');
      }
    } catch (e) {
      print('Error calling AI model API: $e');
      rethrow;
    }
  }

  Future<void> _sendMessage(String message) async {
    String userId = widget.userId;

    await _databaseHelper.insertMessage({
      'message': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'isUserMessage': true,
      'userId': userId,
    });

    setState(() {
      _isBotTyping = true;
    });

    try {
      final response = await _callAIModelAPI(message, userId);

      await _databaseHelper.insertMessage({
        'message': response,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'isUserMessage': false,
        'userId': userId,
      });

      setState(() {
        _isBotTyping = false;
      });
    } catch (e) {
      // Handle errors from AI model API call
      print('Error sending message: $e');
    }

    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (_messages.isEmpty) {
      return CircularProgressIndicator(); // Show loading indicator while messages are being fetched
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soothe Bot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message['isUserMessage'] as bool;
                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          isUserMessage ? Colors.blueAccent : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isUserMessage ? 16 : 0),
                        topRight: Radius.circular(isUserMessage ? 0 : 16),
                        bottomLeft: const Radius.circular(16),
                        bottomRight: const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      message['message'] as String,
                      style: TextStyle(
                        color: isUserMessage ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _isBotTyping
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Typing...',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          spreadRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _textEditingController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    String message = _textEditingController.text;
                    _sendMessage(message);
                  },
                  icon: const Icon(Icons.send),
                  color: const Color.fromARGB(255, 172, 209, 209),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
