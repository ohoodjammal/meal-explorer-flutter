 
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
 import 'chat_message.dart';
import 'dart:convert'; // changed
 import 'package:http/http.dart' as http; // changed
 class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController cont = TextEditingController();

  final List<ChatMessage> messages = [];

  bool isLoading = false;

  final String apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? '';

  final String systemPrompt = '''
You are Meal Explorer Assistant.

You are an AI assistant for the Meal Explorer food application.

You ONLY answer questions related to:
- Cooking
- Recipes
- Ingredients
- Meal preparation
- Food
- Meal categories
- Meal suggestions
- The Meal Explorer application
- How to use the application's features

If the user asks about something unrelated to food, cooking, recipes,
or the Meal Explorer app, politely say that you can only help with
cooking, meals, recipes, and the Meal Explorer application.

Do not answer unrelated questions.
''';
Future<void> getData(String text) async {
  setState(() {
    messages.add(
      ChatMessage(
        role: 'user',
        text: text,
      ),
    );

    isLoading = true;
  });

  cont.clear();

  final url = Uri.parse(
    'https://openrouter.ai/api/v1/chat/completions',
  );

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'openrouter/free',
        'messages': [
          {
            'role': 'system',
            'content': systemPrompt,
          },
          ...messages.map(
            (m) => {
              'role': m.role,
              'content': m.text,
            },
          ),
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final reply = data['choices'][0]['message']['content'];

      setState(() {
        messages.add(
          ChatMessage(
            role: 'assistant',
            text: reply,
          ),
        );

        isLoading = false;
      });
    } else {
      setState(() {
        messages.add(
          ChatMessage(
            role: 'assistant',
            text: 'Error: ${response.body}',
          ),
        );

        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      messages.add(
        ChatMessage(
          role: 'assistant',
          text: 'Something went wrong: $e',
        ),
      );

      isLoading = false;
    });
  }
}

  Widget buildMessage(ChatMessage msg) {
    final bool isUser = msg.role == 'user';

    return Align(
      alignment:
          isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(
          maxWidth: 320,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? const Color(0xFFFF6B3D)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    cont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F7F4),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Meal Assistant',
          style: TextStyle(
                            color: Color(0xFFFF6B3D),

            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFFF6B3D),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return buildMessage(messages[index]);
              },
            ),
          ),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(
                color: Color(0xFFFF6B3D),
              ),
            ),

          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cont,
                    decoration: InputDecoration(
                      hintText: 'Ask about meals or recipes...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color(0xFFFF6B3D),
                        ),
                      ),
                    ),
                    onSubmitted: (value) {
                      final text = value.trim();

                      if (text.isNotEmpty && !isLoading) {
                        getData(text);
                      }
                    },
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          final text = cont.text.trim();

                          if (text.isNotEmpty) {
                            getData(text);
                          }
                        },
                  icon: const Icon(
                    Icons.send,
                    color: Color(0xFFFF6B3D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}