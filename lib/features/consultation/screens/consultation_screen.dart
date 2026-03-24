import 'package:flutter/material.dart';
import '../../chat/screens/ai_chat_screen.dart';

class ConsultationScreen extends StatelessWidget {
  const ConsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AiChatScreen(),
    );
  }
}
