import 'package:flutter/material.dart';
import '../../core/translations/tr_extension.dart';
import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../core/translations/app_translations.dart';
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
  final _scrollController = ScrollController();
  final _inputController  = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping   = false;
  bool _isCooling  = false;
  File? _imageFile;
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  int  _coolSeconds = 0;
  Timer? _coolTimer;

  static const _suggestions = [
    '🥗 Diet for Diabetes',
    '❤️ Heart healthy foods',
    '📋 Explain my ECG report',
    '💊 Side effects of Amlodipine',
    '😴 I have chest pain since morning',
    '🚨 Emergency help',
  ];

  @override
  void initState() {
    super.initState();
    _speech.initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_messages.isEmpty) {
      _addWelcomeMessage();
    }
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(ChatMessage(
        id: 'welcome',
        text: context.tr('ai_welcome') ?? '''Hello! I'm AyurAI, your personal health assistant.\n\nHow can I help you today?''',
        role: MessageRole.ai,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _startCooldown(int seconds) {
    if (!mounted) return;
    setState(() { _isCooling = true; _coolSeconds = seconds; });
    _coolTimer?.cancel();
    _coolTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {
          _coolSeconds--;
          if (_coolSeconds <= 0) {
            t.cancel();
            _isCooling = false;
          }
        });
      } else {
        t.cancel();
      }
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null && mounted) {
      setState(() => _imageFile = File(picked.path));
    }
  }
  
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available && mounted) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          if (mounted) {
            setState(() {
              _inputController.text = val.recognizedWords;
            });
          }
        });
      }
    } else {
      if (mounted) setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty && _imageFile == null) return;

    if (_isCooling) {
      _showCooldownSnack();
      return;
    }

    // Emergency shortcut
    if (trimmed.toLowerCase().contains('emergency') ||
        trimmed.toLowerCase().contains('sos')) {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => const EmergencyScreen(),
      ));
      return;
    }

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: trimmed.isEmpty ? 'Sent an image.' : trimmed,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _isTyping = true;
      _imageFile = null;
    });

    _inputController.clear();
    _scrollToBottom();

    try {
      // FIX: Convert ChatMessage objects to List<Map<String, String>> for the API
      final history = _messages
          .where((m) => m.id != 'welcome' && m.id != userMsg.id)
          .map((m) => {
            'role': m.role == MessageRole.user ? 'user' : 'ai',
            'text': m.text,
          })
          .toList();

      final reply = await GeminiService.chat(history, trimmed);

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
        _startCooldown(3);
        _scrollToBottom();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(
            id: 'err_${DateTime.now().millisecondsSinceEpoch}',
            text: "I'm having trouble connecting right now. "
                "Please check your internet and try again. 🔄",
            role: MessageRole.ai,
            timestamp: DateTime.now(),
          ));
        });
      }
    }
  }

  void _showCooldownSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please wait $_coolSeconds seconds...'),
        backgroundColor: AppColors.navyMid,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 120), () {
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
    _coolTimer?.cancel();
    _scrollController.dispose();
    _inputController.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _buildTopBar(),
          _buildDisclaimer(),
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
          SuggestionChips(
            suggestions: _suggestions,
            onTap: _sendMessage,
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    return Container(
      color: AppColors.navyDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16, right: 16, bottom: 14,
      ),
      child: Row(
        children: [
          if (canPop) ...[
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
          ],
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF534AB7), Color(0xFF185FA5)],
              ),
              borderRadius: BorderRadius.circular(50),
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
                Text('● Online · Powered by Gemini 1.5 Flash',
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

  Widget _buildDisclaimer() {
    return FadeInDown(
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
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 14, right: 14, top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(
            color: Color(0xFFE3EAF2), width: 0.5)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: _imageFile != null ? AppColors.teal.withOpacity(0.2) : AppColors.bgPage,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    color: _imageFile != null ? AppColors.teal : const Color(0xFFE3EAF2), width: 0.5),
              ),
              child: Icon(_imageFile != null ? Icons.image : Icons.attach_file_rounded,
                  color: _imageFile != null ? AppColors.teal : AppColors.textSecondary, size: 18),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: _listen,
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: _isListening ? Colors.red.withOpacity(0.1) : AppColors.bgPage,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    color: _isListening ? Colors.red : const Color(0xFFE3EAF2), width: 0.5),
              ),
              child: Icon(_isListening ? Icons.mic : Icons.mic_none_outlined,
                  color: _isListening ? Colors.red : AppColors.textSecondary, size: 18),
            ),
          ),
          const SizedBox(width: 10),
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
                controller: _inputController,
                maxLines: 3, minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: _sendMessage,
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
          GestureDetector(
            onTap: _isCooling
                ? _showCooldownSnack
                : () => _sendMessage(_inputController.text),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: _isCooling
                    ? AppColors.textHint
                    : AppColors.blue,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: _isCooling
                    ? Text(
                        '$_coolSeconds',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      )
                    : const Icon(Icons.send_rounded,
                        color: Colors.white, size: 18),
              ),
            ),
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
  State<_TypingIndicator> createState() =>
      _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
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
                  animation: _ctrl,
                  builder: (_, __) {
                    final t = ((_ctrl.value * 3) - i)
                        .clamp(0.0, 1.0);
                    final bounce =
                        t < 0.5 ? t * 2 : (1 - t) * 2;
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 2),
                      width: 7, height: 7,
                      decoration: BoxDecoration(
                        color: Color.lerp(
                          const Color(0xFF8BAED4),
                          AppColors.blue, bounce,
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
