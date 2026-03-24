import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/translations/app_translations.dart';
import '../../../core/services/auth_preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'module_selector_screen.dart';
import '../../home/screens/home_screen.dart';

import 'location_permission_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});
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
    {'code': 'mr', 'name': 'Marathi',    'native': 'मराठी',      'flag': '🇮🇳'},
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyDark,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Logo + title
            FadeInDown(
              child: Column(
                children: [
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.teal,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.health_and_safety_rounded,
                        color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 14),
                  const Text('AyurVanta',
                      style: TextStyle(color: Colors.white,
                          fontSize: 26, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  const Text(
                    'Choose Your Language\nభాష ఎంచుకోండి • भाषा चुनें',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textHint,
                        fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Language list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _languages.length,
                itemBuilder: (_, i) {
                  final lang = _languages[i];
                  final isSelected = _selected == lang['code'];
                  return FadeInUp(
                    delay: Duration(milliseconds: i * 50),
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _selected = lang['code']!),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.teal.withOpacity(0.15)
                              : Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.teal
                                : Colors.white.withOpacity(0.1),
                            width: isSelected ? 1.5 : 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(lang['flag']!,
                                style: const TextStyle(fontSize: 24)),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(lang['native']!,
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppColors.teal
                                            : Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      )),
                                  Text(lang['name']!,
                                      style: const TextStyle(
                                          color: AppColors.textHint,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 22, height: 22,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.teal
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.teal
                                      : Colors.white30,
                                  width: 1.5,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check_rounded,
                                      color: Colors.white, size: 13)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Continue button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _continue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22, height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5))
                        : const Text('Continue  •  కొనసాగించు  •  जारी रखें',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
