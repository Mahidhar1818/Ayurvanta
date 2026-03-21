import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../core/theme/app_colors.dart';

class VoiceMicButton extends StatefulWidget {
  final Function(String recognized, String locale) onResult;
  final Color? color;
  final double size;

  const VoiceMicButton({
    super.key,
    required this.onResult,
    this.color,
    this.size = 70,
  });

  @override
  State<VoiceMicButton> createState() => _VoiceMicButtonState();
}

class _VoiceMicButtonState extends State<VoiceMicButton>
    with SingleTickerProviderStateMixin {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  bool _isAvailable = false;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseCtrl,
          curve: Curves.easeInOut),
    );
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _isAvailable = await _speech.initialize(
      onError: (e) => debugPrint('Speech error: $e'),
      onStatus: (s) {
        debugPrint('Speech status: $s');
        if (s == 'done' || s == 'notListening') {
          setState(() => _isListening = false);
          _pulseCtrl.stop();
          _pulseCtrl.reset();
        }
      },
    );
    setState(() {});
  }

  Future<void> _toggleListening() async {
    if (!_isAvailable) {
      await _initSpeech();
    }

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      _pulseCtrl.stop();
      _pulseCtrl.reset();
    } else {
      setState(() => _isListening = true);
      _pulseCtrl.repeat(reverse: true);

      final systemLocale = await _speech.systemLocale();
      final localeId = systemLocale?.localeId ?? 'en_IN';

      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            widget.onResult(
              result.recognizedWords,
              localeId,
            );
            setState(() => _isListening = false);
            _pulseCtrl.stop();
            _pulseCtrl.reset();
          }
        },
        localeId: localeId,
        pauseFor: const Duration(seconds: 4),
        listenFor: const Duration(seconds: 30),
        cancelOnError: false,
        partialResults: false,
      );
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.color ?? AppColors.emergency;

    return GestureDetector(
      onTap: _toggleListening,
      child: AnimatedBuilder(
        animation: _pulseAnim,
        builder: (_, child) => Transform.scale(
          scale: _isListening ? _pulseAnim.value : 1.0,
          child: child,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring when listening
            if (_isListening)
              Container(
                width: widget.size + 20,
                height: widget.size + 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: activeColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
              ),

            // Main button
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: _isListening
                    ? activeColor
                    : activeColor.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isListening
                      ? activeColor
                      : activeColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isListening
                        ? Icons.mic_rounded
                        : Icons.mic_none_rounded,
                    color: _isListening
                        ? Colors.white
                        : activeColor,
                    size: widget.size * 0.38,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isListening ? 'Listening...' : 'Tap to speak',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: _isListening
                          ? Colors.white
                          : activeColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
