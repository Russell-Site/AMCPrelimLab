import '../core/chat_exporter.dart';
import 'package:flutter/material.dart';
import '../core/persona_chat_engine.dart';
import 'package:provider/provider.dart';
import '../models/chat_message.dart';
import '../core/theme_provider.dart';
import '../ui/chat_bubble.dart';
import '../core/chat_session_manager.dart';

class ChatScreen extends StatefulWidget {
  final persona;

  const ChatScreen({super.key, required this.persona});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late PersonaChatEngine engine;
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  @override
  void initState() {
    super.initState();
    engine = ChatSessionManager.getEngine(widget.persona);
  }


  IconData _personaIcon(persona) {
    if (persona.id == "lawyer") return Icons.gavel;
    if (persona.id == "web_expert") return Icons.computer;
    if (persona.id == "manny_pacquiao") return Icons.sports_mma;
    if (persona.id == "english_teacher") return Icons.menu_book;
    return Icons.search;
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // 1️⃣ Add USER message to UI
    setState(() {
      _messages.add(ChatMessage(role: "user", text: text));
    });

    _controller.clear();

    // 2️⃣ Add typing indicator (UI only)
    setState(() {
      _messages.add(
        ChatMessage(role: "model", text: "__typing__"),
      );
    });

    try {
      // 3️⃣ Send ONLY real messages to engine
      final ChatMessage reply = await engine.send(text);

      setState(() {
        _messages.removeLast(); // remove "__typing__"
        _messages.add(reply);
      });
    } catch (e) {
      setState(() {
        _messages.removeLast();
        _messages.add(
          ChatMessage(
            role: "model",
            text: "⚠️ Sorry, something went wrong. Please try again.",
          ),
        );
      });

      debugPrint("CHAT ERROR: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,  // Use theme
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,  // Use theme
              child: Icon(
                _personaIcon(widget.persona),
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Text(widget.persona.label),
          ],
        ),
        actions: [
          // Add theme toggle button
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () => themeProvider.toggleTheme(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),  // Or Icons.share
            onPressed: () async {
              await ChatExporter.exportChatAsText(widget.persona);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Chat exported!")),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (_, i) => ChatBubble(message: _messages[i]),
            ),
          ),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _inputBar() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.orange,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          )
        ],
      ),
    );
  }
}