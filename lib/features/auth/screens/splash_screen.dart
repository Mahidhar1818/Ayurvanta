import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
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

            // New Premium Logo Design
            FadeInDown(
              duration: const Duration(milliseconds: 1000),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Glow
                    Container(
                      width: 120, height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.teal.withOpacity(0.15),
                      ),
                    ),
                    // Main Logo Container
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF27D095), AppColors.teal],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.teal.withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.eco_rounded, // New Ayurvedic/Nature themed logo
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    // Subtle white border
                    Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // App name
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: const Text(
                'AyurVanta',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Tagline
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: const Text(
                'Your Health. One Identity.',
                style: TextStyle(
                  color: AppColors.textHint,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.8,
                ),
              ),
            ),

            const Spacer(),

            // Bottom badge
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
                      ),
                      child: const Text(
                        'Powered by Ayur ID + Aadhar',
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.teal),
                      strokeWidth: 2.5,
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
