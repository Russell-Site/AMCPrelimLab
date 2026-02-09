import 'package:flutter/material.dart';
import '../core/personas.dart';
import '../screens/chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,  // Dynamic
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "Hi, Welcome 👋",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Choose a persona to talk to",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _personaRow(
                    context,
                    icon: Icons.gavel,
                    label: "Lawyer",
                    persona: Personas.lawyer,
                  ),
                  _personaRow(
                    context,
                    icon: Icons.computer,
                    label: "Web Expert",
                    persona: Personas.webExpert,
                  ),
                  _personaRow(
                    context,
                    icon: Icons.sports_mma,
                    label: "Manny Pacquiao",
                    persona: Personas.mannyPacquiao,
                  ),
                  _personaRow(
                    context,
                    icon: Icons.menu_book,
                    label: "English Teacher",
                    persona: Personas.englishTeacher,
                  ),
                  _personaRow(
                    context,
                    icon: Icons.search,
                    label: "Historian",
                    persona: Personas.historian,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _personaRow(
      BuildContext context, {
        required IconData icon,
        required String label,
        required persona,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(persona: persona),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: Icon(icon, color: Colors.orange),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }


  Widget _personaTile(
      BuildContext context, {
        required IconData icon,
        required String label,
        required persona,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(persona: persona),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
