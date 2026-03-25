import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/auth_preference_service.dart';
import '../../../core/translations/app_translations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'module_selector_screen.dart';
import 'language_selection_screen.dart';
import 'location_permission_screen.dart';
import '../../home/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _barController;
  late Animation<double> _barAnim;

  @override
  void initState() {
    super.initState();
    _barController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..forward();
    _barAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _barController,
          curve: Curves.easeInOut),
    );
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(
        const Duration(milliseconds: 2800));
    if (!mounted) return;

    final loggedIn =
        await AuthPreferenceService.isLoggedIn();
    final prefs = await SharedPreferences.getInstance();
    final langSet = prefs.containsKey('language');
    final locSet = prefs.containsKey('location_granted');

    if (!langSet) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (_) =>
                  const LanguageSelectionScreen()));
    } else if (!locSet) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (_) =>
                  const LocationPermissionScreen()));
    } else if (!loggedIn) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (_) =>
                  const ModuleSelectorScreen()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (_) => const HomeScreen()));
    }
  }

  @override
  void dispose() {
    _barController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyDark,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            FadeInDown(
              duration: const Duration(
                  milliseconds: 700),
              child: Center(
                child: Container(
                  width: 120, height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.teal.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            FadeInUp(
              delay: const Duration(
                  milliseconds: 300),
              child: const Text('AyurVanta',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                )),
            ),
            const SizedBox(height: 10),
            FadeInUp(
              delay: const Duration(
                  milliseconds: 500),
              child: const Text(
                'Your Health. One Identity.',
                style: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 15)),
            ),
            const Spacer(),
            FadeInUp(
              delay: const Duration(
                  milliseconds: 700),
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 52),
                child: Column(
                  children: [
                    const Text(
                      'Unified Healthcare Ecosystem',
                      style: TextStyle(
                          color: Colors.white24,
                          fontSize: 12)),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 120,
                      child: AnimatedBuilder(
                        animation: _barAnim,
                        builder: (_, __) =>
                            ClipRRect(
                          borderRadius:
                              BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _barAnim.value,
                            backgroundColor:
                                Colors.white.withOpacity(
                                    0.1),
                            valueColor:
                                const AlwaysStoppedAnimation(
                                    AppColors.teal),
                            minHeight: 3,
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
    );
  }
}
