import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../translations/tr_extension.dart';

class VoiceField {
  final String label;
  final TextEditingController controller;
  final String prompt;
  
  VoiceField({
    required this.label,
    required this.controller,
    required this.prompt,
  });
}

class VoiceFormAssistant extends StatefulWidget {
  final List<VoiceField> fields;
  final VoidCallback onComplete;
  
  const VoiceFormAssistant({
    Key? key,
    required this.fields,
    required this.onComplete,
  }) : super(key: key);
  
  @override
  _VoiceFormAssistantState createState() => _VoiceFormAssistantState();
}

class _VoiceFormAssistantState extends State<VoiceFormAssistant> {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  
  int _currentFieldIndex = 0;
  bool _isListening = false;
  bool _isSpeaking = false;
  String _currentText = '';
  String _currentLanguage = 'en-IN';
  
  @override
  void initState() {
    super.initState();
    _initSpeech();
    _setLanguage();
  }
  
  Future<void> _setLanguage() async {
    // Determine language by reading context using our unified AppTranslations or use default
    _currentLanguage = 'en-IN';
    await _flutterTts.setLanguage('en-IN');
    _startVoiceAssistant();
  }
  
  Future<void> _initSpeech() async {
    await _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening' && _isListening) {
          setState(() {
            _isListening = false;
          });
          _processVoiceInput();
        }
      },
      onError: (error) {
        setState(() {
          _isListening = false;
        });
        // We will pass translation strings inline 
        _speakError(context.tr('voice_error'));
      },
    );
  }
  
  Future<void> _startVoiceAssistant() async {
    if (widget.fields.isNotEmpty) {
      await _speakPrompt(widget.fields[_currentFieldIndex].prompt);
    }
  }
  
  Future<void> _speakPrompt(String prompt) async {
    setState(() {
      _isSpeaking = true;
    });
    
    await _flutterTts.speak(prompt);
    
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
      _startListening();
    });
  }
  
  Future<void> _startListening() async {
    if (!_speech.isAvailable) {
      _speakError(context.tr('speech_unavailable'));
      return;
    }
    
    setState(() {
      _isListening = true;
      _currentText = '';
    });
    
    await _speech.listen(
      onResult: (result) {
        setState(() {
          _currentText = result.recognizedWords;
        });
      },
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 2),
      partialResults: true,
      localeId: _currentLanguage,
    );
  }
  
  Future<void> _processVoiceInput() async {
    if (_currentText.isNotEmpty) {
      widget.fields[_currentFieldIndex].controller.text = _currentText;
      
      if (_currentFieldIndex < widget.fields.length - 1) {
        _currentFieldIndex++;
        await _speakPrompt(widget.fields[_currentFieldIndex].prompt);
      } else {
        await _speakPrompt(context.tr('voice_complete'));
        widget.onComplete();
      }
    } else {
      await _speakPrompt(context.tr('voice_no_input'));
      _startListening();
    }
  }
  
  Future<void> _speakError(String message) async {
    await _flutterTts.speak(message);
    Future.delayed(const Duration(seconds: 2), () {
      _startListening();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr('voice_assistant')),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isSpeaking)
              Column(
                children: [
                  const Icon(
                    Icons.volume_up,
                    size: 50,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  Text(context.tr('speaking')),
                ],
              ),
            if (_isListening)
              Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: _isListening ? 80 : 50,
                    height: _isListening ? 80 : 50,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mic,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.tr('listening'),
                    style: const TextStyle(color: Colors.red),
                  ),
                  if (_currentText.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        _currentText,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: widget.fields.isEmpty ? 0 : (_currentFieldIndex + 1) / widget.fields.length,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              '${context.tr('step')} ${_currentFieldIndex + 1} ${context.tr('of')} ${widget.fields.length}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _flutterTts.stop();
            Navigator.pop(context);
          },
          child: Text(context.tr('cancel')),
        ),
        TextButton(
          onPressed: () {
            _flutterTts.stop();
            widget.onComplete();
          },
          child: Text(context.tr('skip')),
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    _speech.stop();
    _flutterTts.stop();
    super.dispose();
  }
}
