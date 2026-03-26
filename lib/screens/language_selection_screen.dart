import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/localization/app_localizations.dart';
import '../bloc/locale/locale_cubit.dart';
import '../core/widgets/ayurvanta_logo.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final bool isFirstTime;

  const LanguageSelectionScreen({Key? key, this.isFirstTime = false}) : super(key: key);

  @override
  _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final List<Map<String, dynamic>> _languages = [
    {'code': 'en', 'name': 'English', 'native': 'English', 'flag': '🇺🇸'},
    {'code': 'hi', 'name': 'Hindi', 'native': 'हिन्दी', 'flag': '🇮🇳'},
    {'code': 'te', 'name': 'Telugu', 'native': 'తెలుగు', 'flag': '🇮🇳'},
    {'code': 'ta', 'name': 'Tamil', 'native': 'தமிழ்', 'flag': '🇮🇳'},
    {'code': 'kn', 'name': 'Kannada', 'native': 'ಕನ್ನಡ', 'flag': '🇮🇳'},
    {'code': 'ml', 'name': 'Malayalam', 'native': 'മലയാളం', 'flag': '🇮🇳'},
    {'code': 'mr', 'name': 'Marathi', 'native': 'मరాठी', 'flag': '🇮🇳'},
    {'code': 'bn', 'name': 'Bengali', 'native': 'বাংলা', 'flag': '🇮🇳'},
  ];

  String _selectedLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A5F7A),
              Color(0xFF159957),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              if (widget.isFirstTime)
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: AyurVantaLogo(
                    size: 100,
                    showText: true,
                    textColor: Colors.white,
                  ),
                ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isFirstTime ? 'Choose Your Language' : 'Select Language',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A5F7A),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.isFirstTime
                            ? 'Select your preferred language for the app'
                            : 'Change your app language',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _languages.length,
                          itemBuilder: (context, index) {
                            final lang = _languages[index];
                            final isSelected = _selectedLanguage == lang['code'];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF1A5F7A) : Colors.grey[300]!,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: RadioListTile<String>(
                                value: lang['code'],
                                groupValue: _selectedLanguage,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedLanguage = value!;
                                  });
                                },
                                title: Row(
                                  children: [
                                    Text(
                                      lang['flag'],
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lang['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          lang['native'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                activeColor: const Color(0xFF1A5F7A),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final locale = Locale(_selectedLanguage);
                          await AppLocalizations.saveLocale(locale);
                          if (context.mounted) {
                            context.read<LocaleCubit>().setLocale(locale);
                            
                            if (widget.isFirstTime) {
                              Navigator.pushReplacementNamed(context, '/login');
                            } else {
                              Navigator.pop(context);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A5F7A),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(
                          widget.isFirstTime ? 'Continue' : 'Apply',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
