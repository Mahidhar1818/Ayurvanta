import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        title: const Text('Help & Support',
            style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.navyDark,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Need Assistance?',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            const Text(
                'Our support team is always ready to help you with booking, pharmacy, or any technical issues inside AyurVanta.',
                style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5)),
            const SizedBox(height: 24),
            _contactCard(Icons.email_outlined, 'Email Support',
                'support@ayurvanta.com', AppColors.blue),
            const SizedBox(height: 12),
            _contactCard(Icons.headset_mic_rounded, 'Call Us (24/7)',
                '1800-123-4567', AppColors.teal),
            const SizedBox(height: 32),
            const Text('Frequently Asked Questions',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            _faqItem('How do I book a home visit?',
                'Go to the Home Checkup module and select Book Home Visit. Choose your location and preferred doctor.'),
            _faqItem('Is my data secure?',
                'Yes. All your medical data is encrypted and validated using your Aadhar.'),
            _faqItem('Can I change my emergency contacts?',
                'Yes, go to the Solo Safety module to manage your emergency guardians.'),
          ],
        ),
      ),
    );
  }

  Widget _contactCard(
      IconData icon, String title, String detail, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text(detail,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _faqItem(String q, String a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: ExpansionTile(
        title: Text(q,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(a,
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5)),
          ),
        ],
      ),
    );
  }
}
