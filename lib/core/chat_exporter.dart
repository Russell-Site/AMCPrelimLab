import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'persona_chat_engine.dart';
import 'personas.dart';
import 'chat_session_manager.dart';

class ChatExporter {
  static Future<void> exportChatAsText(Persona persona) async {
    final engine = ChatSessionManager.getEngine(persona);
    final history = engine.history;
    // Format as text
    final buffer = StringBuffer();
    buffer.writeln("Chat Export - Persona: ${persona.label}");
    buffer.writeln("Date: ${DateTime.now()}");
    buffer.writeln("---");
    for (final message in history) {
      final role = message.role == "user" ? "You" : persona.label;
      buffer.writeln("$role: ${message.text}");
    }

    final chatText = buffer.toString();

    // Option 1: Share directly (opens share sheet)
    await Share.share(chatText, subject: "Chat Export");

    // Option 2: Save to file and share (for download)
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/chat_export_${persona.id}.txt');
    await file.writeAsString(chatText);
    await Share.shareXFiles([XFile(file.path)], text: "Chat Export");
  }
}