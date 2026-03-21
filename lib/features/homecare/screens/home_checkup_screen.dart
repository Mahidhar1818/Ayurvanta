import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class HomeCheckupScreen extends StatelessWidget {
  const HomeCheckupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.navyDark,
        title: const Text('Home Checkup',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: const Center(
        child: Text('Home Checkup Screen — Coming Soon',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
      ),
    );
  }
}
