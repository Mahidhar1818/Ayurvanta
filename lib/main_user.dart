import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/auth/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
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
        fontFamily: 'SF Pro Display',
      ),
      home: const SplashScreen(),
    );
  }
}
