import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../models/chat_message.dart';
import '../services/gemini_service.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/suggestion_chips.dart';
import '../../emergency/screens/emergency_screen.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});
  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _scrollController  = ScrollController();
  final _inputController   = TextEditingController();
  final List<ChatMessage>  _messages = [];
  bool _isTyping = false;

  static const _suggestions = [
    '📋 Explain my ECG report',
    '💊 Side effects of Amlodipine',
    '🩸 What does my blood sugar mean?',
    '📞 Should I see a doctor today?',
    '🚨 Emergency help',
  ];

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessage(
      id: 'welcome',
      text: "Hello Arjun! 👋 I'm AyurAI, your personal health assistant "
          "powered by Gemini AI.\n\nI can help you understand your symptoms, "
          "medications, and health reports. I also have access to your "
          "medical history.\n\nHow can I help you today?",
      role: MessageRole.ai,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Handle emergency shortcut
    if (text.toLowerCase().contains('emergency')) {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => const EmergencyScreen(),
      ));
      return;
    }

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _isTyping = true;
    });

    _inputController.clear();
    _scrollToBottom();

    try {
      // Build history for Gemini (exclude welcome)
      final history = _messages
          .where((m) => m.id != 'welcome' && m.id != userMsg.id)
          .map((m) => {
                'role': m.role == MessageRole.ai ? 'ai' : 'user',
                'text': m.text,
              })
          .toList();

      final reply = await GeminiService.sendMessage(history, text);

      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: reply,
            role: MessageRole.ai,
            timestamp: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(
            id: 'error',
            text: "Sorry, I couldn't connect right now. "
                "Please check your internet and try again. 🔄",
            role: MessageRole.ai,
            timestamp: DateTime.now(),
          ));
        });
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _TopBar(),
          // Disclaimer
          FadeInDown(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFAEEDA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 15, color: Color(0xFF854F0B)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'AyurAI provides general guidance only. '
                      'Not a substitute for professional medical advice.',
                      style: TextStyle(fontSize: 11,
                          color: Color(0xFF854F0B), height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (_, i) {
                if (i == _messages.length && _isTyping) {
                  return const _TypingIndicator();
                }
                return FadeInUp(
                  duration: const Duration(milliseconds: 300),
                  child: ChatBubble(message: _messages[i]),
                );
              },
            ),
          ),
          // Suggestion chips
          SuggestionChips(
            suggestions: _suggestions,
            onTap: _sendMessage,
          ),
          // Input bar
          _InputBar(
            controller: _inputController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

// ── Top Bar ──────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navyDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16, right: 16, bottom: 14,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40, height: 40,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF534AB7), Color(0xFF185FA5)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AyurAI Doctor',
                  style: TextStyle(color: Colors.white,
                      fontSize: 15, fontWeight: FontWeight.w700)),
                Text('● Online · Powered by Gemini',
                  style: TextStyle(color: Color(0xFF1D9E75),
                      fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('AI ONLY',
              style: TextStyle(color: AppColors.textHint,
                  fontSize: 9, fontWeight: FontWeight.w700,
                  letterSpacing: 0.5)),
          ),
        ],
      ),
    );
  }
}

// ── Typing Indicator ─────────────────────────────────────
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF534AB7), Color(0xFF185FA5)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy_rounded,
                color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
              border: Border.all(
                  color: const Color(0xFFE3EAF2), width: 0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) =>
                AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) {
                    final offset = ((_controller.value * 3) - i)
                        .clamp(0.0, 1.0);
                    final bounce = offset < 0.5
                        ? offset * 2 : (1 - offset) * 2;
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 2),
                      width: 7, height: 7,
                      decoration: BoxDecoration(
                        color: Color.lerp(
                          const Color(0xFF8BAED4),
                          AppColors.blue,
                          bounce,
                        ),
                        shape: BoxShape.circle,
                      ),
                      transform: Matrix4.translationValues(
                          0, -bounce * 5, 0),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSend;
  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 14, right: 14, top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(color: Color(0xFFE3EAF2), width: 0.5)),
      ),
      child: Row(
        children: [
          // Attach button
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.bgPage,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                  color: const Color(0xFFE3EAF2), width: 0.5),
            ),
            child: const Icon(Icons.attach_file_rounded,
                color: AppColors.textSecondary, size: 18),
          ),
          const SizedBox(width: 10),
          // Text field
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.bgPage,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: const Color(0xFFE3EAF2), width: 0.5),
              ),
              child: TextField(
                controller: controller,
                maxLines: 3,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: onSend,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Describe your symptoms…',
                  hintStyle: TextStyle(
                      color: AppColors.textHint, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Send button
          GestureDetector(
            onTap: () => onSend(controller.text),
            child: Container(
              width: 40, height: 40,
              decoration: const BoxDecoration(
                color: AppColors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
