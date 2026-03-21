import 'package:flutter/material.dart';
import 'features/onboarding/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Removed dotenv — API key is directly in GeminiService
  runApp(const AyurVantaApp());
}

class AyurVantaApp extends StatelessWidget {
  const AyurVantaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AyurVanta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0B1A2C),
      ),
      home: const SplashScreen(),
    );
  }
}
