enum MessageType {
  normal,
  personaRedirect,
}

class ChatMessage {
  final String role; // user | model | system
  final String text;

  // 🔥 NEW (OPTIONAL)
  final MessageType type;
  final String? suggestedPersona;

  ChatMessage({
    required this.role,
    required this.text,
    this.type = MessageType.normal,
    this.suggestedPersona,
  });
}

