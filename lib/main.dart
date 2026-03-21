import 'package:flutter/material.dart';
import 'core/translations/app_translations.dart';
import 'features/onboarding/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTranslations.instance.load();
  runApp(const AyurVantaApp());
}

class AyurVantaApp extends StatefulWidget {
  const AyurVantaApp({super.key});
  @override
  State<AyurVantaApp> createState() => _AyurVantaAppState();
}

class _AyurVantaAppState extends State<AyurVantaApp> {
  @override
  void initState() {
    super.initState();
    AppTranslations.instance.addListener(() {
      if (mounted) setState(() {});
    });
  }

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
