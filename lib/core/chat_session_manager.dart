import 'persona_chat_engine.dart';
import 'personas.dart';

class ChatSessionManager {
  static final Map<String, PersonaChatEngine> _sessions = {};

  static PersonaChatEngine getEngine(Persona persona) {
    return _sessions.putIfAbsent(
      persona.id,
          () => PersonaChatEngine(persona: persona),
    );
  }
}
