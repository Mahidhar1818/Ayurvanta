import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../localization/app_localizations.dart';

class VoiceFieldTranslated {
  final String label;
  final TextEditingController controller;
  final String prompt;
  
  VoiceFieldTranslated({
    required this.label,
    required this.controller,
    required this.prompt,
  });
}

class VoiceFormAssistantTranslated extends StatefulWidget {
  final List<VoiceFieldTranslated> fields;
  final VoidCallback onComplete;
  
  const VoiceFormAssistantTranslated({
    Key? key,
    required this.fields,
    required this.onComplete,
  }) : super(key: key);
  
  @override
  _VoiceFormAssistantTranslatedState createState() => 
      _VoiceFormAssistantTranslatedState();
}

class _VoiceFormAssistantTranslatedState 
    extends State<VoiceFormAssistantTranslated> {
  
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
    final savedLocale = await AppLocalizations.getSavedLocale();
    switch (savedLocale.languageCode) {
      case 'hi':
        _currentLanguage = 'hi-IN';
        await _flutterTts.setLanguage('hi-IN');
        break;
      case 'te':
        _currentLanguage = 'te-IN';
        await _flutterTts.setLanguage('te-IN');
        break;
      case 'ta':
        _currentLanguage = 'ta-IN';
        await _flutterTts.setLanguage('ta-IN');
        break;
      default:
        _currentLanguage = 'en-IN';
        await _flutterTts.setLanguage('en-IN');
    }
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
        _speakError(AppLocalizations.of(context)!.translate('voice_error'));
      },
    );
  }
  
  Future<void> _startVoiceAssistant() async {
    await _speakPrompt(widget.fields[_currentFieldIndex].prompt);
  }
  
  Future<void> _speakPrompt(String prompt) async {
    setState(() {
      _isSpeaking = true;
    });
    
    await _flutterTts.speak(prompt);
    
    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
        _startListening();
      }
    });
  }
  
  Future<void> _startListening() async {
    if (!_speech.isAvailable) {
      if (mounted) {
        _speakError(AppLocalizations.of(context)!.translate('speech_unavailable'));
      }
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
      listenFor: Duration(seconds: 10),
      pauseFor: Duration(seconds: 2),
      partialResults: true,
      localeId: _currentLanguage,
    );
  }
  
  Future<void> _processVoiceInput() async {
    if (!mounted) return;
    final t = AppLocalizations.of(context)!;
    
    if (_currentText.isNotEmpty) {
      widget.fields[_currentFieldIndex].controller.text = _currentText;
      
      if (_currentFieldIndex < widget.fields.length - 1) {
        _currentFieldIndex++;
        await _speakPrompt(widget.fields[_currentFieldIndex].prompt);
      } else {
        await _speakPrompt(t.translate('voice_complete'));
        widget.onComplete();
      }
    } else {
      await _speakPrompt(t.translate('voice_no_input'));
      _startListening();
    }
  }
  
  Future<void> _speakError(String message) async {
    await _flutterTts.speak(message);
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        _startListening();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    var appLoc = AppLocalizations.of(context);
    if (appLoc == null) {
        return const SizedBox.shrink(); // safety fallback
    }
    final t = appLoc;
    
    return AlertDialog(
      title: Text(t.translate('voice_assistant')),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isSpeaking)
              Column(
                children: [
                  Icon(
                    Icons.volume_up,
                    size: 50,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 16),
                  Text(t.translate('speaking')),
                ],
              ),
            if (_isListening)
              Column(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: _isListening ? 80 : 50,
                    height: _isListening ? 80 : 50,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.mic,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    t.translate('listening'),
                    style: TextStyle(color: Colors.red),
                  ),
                  if (_currentText.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        _currentText,
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: (_currentFieldIndex + 1) / widget.fields.length,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 8),
            Text(
              '${t.translate('step')} ${_currentFieldIndex + 1} ${t.translate('of')} ${widget.fields.length}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
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
          child: Text(t.translate('cancel')),
        ),
        TextButton(
          onPressed: () {
            _flutterTts.stop();
            widget.onComplete();
          },
          child: Text(t.translate('skip')),
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
