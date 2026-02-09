import 'package:chat_ui_app_prelim/core/personas.dart';
import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../ui/type_indicator.dart';
import '../screens/chat_screen.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // 🔹 TYPING INDICATOR
    if (message.text == "__typing__") {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,  // Replaced: Colors.grey[300] -> theme-aware surface color (light grey in light mode, darker in dark)
            borderRadius: BorderRadius.circular(12),
          ),
          child: const TypingIndicator(),
        ),
      );
    }

    if (message.suggestedPersona != null) {
      return Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,  // Replaced: Colors.orange.shade50 -> theme-aware surface (adapts to light/dark)
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).primaryColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),  // Replaced: implicit black -> theme-aware text color
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.switch_account),
              label: Text("Ask ${message.suggestedPersona!}"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,  // Replaced: default -> primaryColor for consistency
                foregroundColor: Colors.white,  // Keep white for contrast
              ),
              onPressed: () {
                // If you have a ChatScreen that expects a Persona object,
                // you might need to map the string to a Persona instance
                final persona = Persona(label: message.suggestedPersona!, id: '', description: '', systemPrompt: '', icon: null);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      persona: persona,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }



    final isUser = message.role == "user";

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser 
            ? Theme.of(context).primaryColor  // Replaced: Colors.blue -> primaryColor (orange for user bubbles)
            : Theme.of(context).cardColor,   // Replaced: Colors.grey[300] -> surfaceVariant for model bubbles
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUser
              ? Colors.white  // Keep white for user text (good contrast on orange)
              : Theme.of(context).textTheme.bodyLarge!.color,  // Replaced: Colors.black -> theme-aware text color
           ),
        ),
      ),
    );
  }
}
