import 'package:flutter/material.dart';
import '../../../core/widgets/ayurvanta_logo.dart';
import '../../../core/services/auth_preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'module_selector_screen.dart';
import 'language_selection_screen.dart';
import 'location_permission_screen.dart';
import '../../home/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    
    _animationController.forward();
    
    // Navigate after splash
    Future.delayed(const Duration(seconds: 3), () {
      _navigateToNextScreen();
    });
  }

  Future<void> _navigateToNextScreen() async {
    if (!mounted) return;

    final loggedIn = await AuthPreferenceService.isLoggedIn();
    final prefs = await SharedPreferences.getInstance();
    final langSet = prefs.containsKey('language');
    final locSet = prefs.containsKey('location_granted');

    if (!langSet) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
      );
    } else if (!locSet) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LocationPermissionScreen()),
      );
    } else if (!loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ModuleSelectorScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: const AyurVantaLogo(
                size: 120,
                showText: true,
                textColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
