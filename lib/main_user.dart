import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/translations/app_translations.dart';
import 'features/onboarding/screens/splash_screen.dart';
import 'features/pharmacy/providers/cart_provider.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: '.env');
  
  final translations = AppTranslations.instance;
  await translations.load();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: translations),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const AyurVantaApp(),
    ),
  );
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
