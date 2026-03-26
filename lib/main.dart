import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'core/translations/app_translations.dart';
import 'features/onboarding/screens/splash_screen.dart';
import 'features/pharmacy/providers/cart_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  // Keep splash screen visible while loading
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  await AppTranslations.instance.load();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const AyurVantaApp(),
    ),
  );
  
  // Remove splash screen after app loads
  FlutterNativeSplash.remove();
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
