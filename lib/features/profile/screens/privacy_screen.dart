import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        title: const Text('Privacy & Security',
            style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.navyDark,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.shield_rounded, color: AppColors.teal, size: 48),
            const SizedBox(height: 16),
            const Text('Your Health Data is Secured',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            const Text(
                'AyurVanta uses state-of-the-art encryption to ensure your medical records, personal information, and identity details (Aadhar) remain completely private and secure.\n\n'
                '• End-to-end encryption for all medical reports.\n'
                '• Strict no-sharing policy with third-party advertisers.\n'
                '• Aadhar data is validated and hashed securely.',
                style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
              ),
              child: Column(
                children: [
                  _policyItem(Icons.lock_rounded, 'End-to-End Encryption',
                      'Your data is fully encrypted.'),
                  const SizedBox(height: 12),
                  _policyItem(Icons.visibility_off_rounded, 'Strict Access Control',
                      'Only authorized doctors can view your health records.'),
                  const SizedBox(height: 12),
                  _policyItem(Icons.fingerprint_rounded, 'Biometric Security',
                      'App access locked behind device biometrics.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _policyItem(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.blue, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text(desc,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}
