import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/translations/app_translations.dart';
import '../../../core/services/auth_preference_service.dart';
import '../../../core/widgets/ayurvanta_logo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'module_selector_screen.dart';
import '../../home/screens/home_screen.dart';
import 'location_permission_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final bool isFirstTime;
  const LanguageSelectionScreen({Key? key, this.isFirstTime = true}) : super(key: key);

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selected = 'en';
  bool _isLoading = false;

  final _languages = [
    {'code': 'en', 'name': 'English',    'native': 'English',    'flag': '🇬🇧'},
    {'code': 'te', 'name': 'Telugu',     'native': 'తెలుగు',     'flag': '🇮🇳'},
    {'code': 'hi', 'name': 'Hindi',      'native': 'हिन्दी',      'flag': '🇮🇳'},
    {'code': 'ta', 'name': 'Tamil',      'native': 'தமிழ்',      'flag': '🇮🇳'},
    {'code': 'mr', 'name': 'Marathi',    'native': 'मరాઠી',      'flag': '🇮🇳'},
    {'code': 'kn', 'name': 'Kannada',    'native': 'ಕನ್ನಡ',      'flag': '🇮🇳'},
    {'code': 'ml', 'name': 'Malayalam',  'native': 'മലയാളം',     'flag': '🇮🇳'},
    {'code': 'bn', 'name': 'Bengali',    'native': 'বাংলা',      'flag': '🇮🇳'},
    {'code': 'pa', 'name': 'Punjabi',    'native': 'ਪੰਜਾਬੀ',     'flag': '🇮🇳'},
    {'code': 'gu', 'name': 'Gujarati',   'native': 'ગુજરાતી',    'flag': '🇮🇳'},
  ];

  Future<void> _continue() async {
    setState(() => _isLoading = true);
    await AppTranslations.instance.setLanguage(_selected);
    
    final prefs = await SharedPreferences.getInstance();
    final locSet = prefs.containsKey('location_granted');
    final loggedIn = await AuthPreferenceService.isLoggedIn();
    
    if (!mounted) return;
    setState(() => _isLoading = false);
    
    if (widget.isFirstTime) {
      if (!locSet) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LocationPermissionScreen(),
          ),
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => loggedIn ? const HomeScreen() : const ModuleSelectorScreen(),
          ),
          (_) => false,
        );
      }
    } else {
      Navigator.pop(context);
    }
  }

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
              // Logo Section
              Expanded(
                flex: 2,
                child: Center(
                  child: FadeInDown(
                    child: const AyurVantaLogo(
                      size: 100,
                      showText: true,
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ),
              // Language Selection Section
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isFirstTime 
                            ? 'Choose Your Language' 
                            : 'Select Language',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A5F7A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.isFirstTime
                            ? 'Select your preferred language for the app'
                            : 'Change your app language',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _languages.length,
                          itemBuilder: (context, index) {
                            final lang = _languages[index];
                            final isSelected = _selected == lang['code'];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected 
                                      ? const Color(0xFF1A5F7A) 
                                      : Colors.grey[300]!,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: RadioListTile<String>(
                                value: lang['code']!,
                                groupValue: _selected,
                                onChanged: (value) {
                                  setState(() {
                                    _selected = value!;
                                  });
                                },
                                title: Row(
                                  children: [
                                    Text(
                                      lang['flag']!,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lang['name']!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          lang['native']!,
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
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _continue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A5F7A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24, height: 24,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2.5))
                              : Text(
                                  widget.isFirstTime ? 'Continue' : 'Apply',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
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
