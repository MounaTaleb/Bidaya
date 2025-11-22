import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isBot;

  ChatMessage({required this.text, required this.isBot});
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isBot = message.isBot;

    return Row(
      mainAxisAlignment:
          isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: const BoxConstraints(maxWidth: 270),
          decoration: BoxDecoration(
            color: isBot ? Colors.blue.shade200 : Colors.pink.shade300,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: isBot ? Radius.zero : const Radius.circular(20),
              bottomRight: isBot ? const Radius.circular(20) : Radius.zero,
            ),
          ),
          child: Text(
            message.text,
            style: TextStyle(
              color: isBot ? Colors.black87 : Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
