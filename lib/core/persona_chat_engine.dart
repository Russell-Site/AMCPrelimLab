import '../models/chat_message.dart';
import 'gemini_service.dart';
import 'personas.dart';

class PersonaChatEngine {
  Persona persona;
  final List<ChatMessage> _history = [];

  PersonaChatEngine({required this.persona});

  void changePersona(Persona newPersona) {
    persona = newPersona;
    _history.clear();
  }

  /// MAIN CHAT ENTRY
  Future<ChatMessage> send(String userMessage) async {
    // 1️⃣ Check persona scope
    final allowed = await _isQuestionWithinPersonaScope(userMessage);

    if (!allowed) {
      final suggested = await _recommendPersona(userMessage);

      return ChatMessage(
        role: "system",
        text: "I'm not the right persona for that question.",
        type: MessageType.personaRedirect,
        suggestedPersona: suggested,
      );
    }

    // 2️⃣ Convert history to Gemini format (NO typing messages)
    final geminiHistory = _history
        .where((m) => m.text != "__typing__")
        .map((m) => {
      "role": m.role,
      "text": m.text,
    })
        .toList();

    // 3️⃣ Call Gemini with NAMED arguments (IMPORTANT)
    final responseText = await GeminiService.sendMessage(
      systemPrompt: persona.systemPrompt,
      history: geminiHistory,
      userMessage: userMessage,
    );

    // 4️⃣ Save messages AFTER successful response
    final userMsg = ChatMessage(role: "user", text: userMessage);
    final modelMsg = ChatMessage(role: "model", text: responseText);

    _history.add(userMsg);
    _history.add(modelMsg);

    return modelMsg;
  }

  /// 🔍 CHECK IF QUESTION FITS CURRENT PERSONA
  Future<bool> _isQuestionWithinPersonaScope(String question) async {
    final prompt = """
You are a strict classifier AI.

Persona:
${persona.label}

Description:
${persona.description}

User question:
"$question"

Rules:
- Respond with ONLY "YES" or "NO"
- No explanations

Examples:
- "How do I code a website?" for Web Expert -> YES
- "What is the weather?" for Web Expert -> NO
""";

    final result = await GeminiService.sendRawPrompt(prompt);
    return result.trim().toUpperCase() == "YES";
  }

  /// 🎯 FIND THE CORRECT PERSONA
  Future<String> _recommendPersona(String question) async {
    final prompt = """
You are a routing AI.

Available personas:
- Lawyer
- Web Expert
- English Teacher
- Manny Pacquiao
- Historian

User question:
"$question"

Rules:
- Respond with ONLY ONE persona name from the list
- No explanations
""";

    final result = await GeminiService.sendRawPrompt(prompt);
    return result.trim();
  }

  List<ChatMessage> get history => _history;
}
