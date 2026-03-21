import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ConsultationScreen extends StatelessWidget {
  const ConsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        title: const Text('Personal Consultation'),
        backgroundColor: AppColors.navyDark,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Personal Consultation Module'),
      ),
    );
  }
}
