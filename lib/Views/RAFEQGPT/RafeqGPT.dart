import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RafeqGPT extends StatefulWidget {
  @override
  _RafeqGPTState createState() => _RafeqGPTState();
}

class _RafeqGPTState extends State<RafeqGPT> {
  final TextEditingController _textController = TextEditingController();
  List<String> _messages = ["RafeqGPT: " + "hi lovely", "You: " + "hi stupid ai"];

  void _sendMessage(String text) async {
    if (text.isNotEmpty) {
      setState(() {
        _messages.add("You: $text");
      });

      _textController.clear();
      var response = await http.post(
        Uri.parse('https://api.openai.com/v1/engines/gpt-3.5-turbo/completions'), // Adjusted endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer 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' // Replace with your API key
        },
        body: jsonEncode({
          'prompt': text,
          'max_tokens': 150,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _messages.add("RafeqGPT: " + data['choices'][0]['text']);
        });
      } else {
        setState(() {
          _messages.add("RafeqGPT: Error getting response");
        });
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter ChatGPT'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) => Container(
                padding: EdgeInsets.all(5),
                // if contains RafeqGPT, margin right 10 else margin left 10
                margin: _messages[index].contains("RafeqGPT") ? EdgeInsets.only(left: 10, right: 40, bottom: 20) : EdgeInsets.only(left: 40, right: 10, bottom: 20),
                decoration: BoxDecoration(
                  color: _messages[index].contains("RafeqGPT") ? Colors.blue[200] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: _messages[index].contains("RafeqGPT") ? Alignment.centerLeft : Alignment.centerRight,
                child: Text(_messages[index]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: _sendMessage,
                    decoration: InputDecoration(
                      labelText: 'Send a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_textController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
