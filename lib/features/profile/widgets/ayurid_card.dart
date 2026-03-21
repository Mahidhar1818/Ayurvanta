import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../models/user_profile_model.dart';

class AyurIdCard extends StatelessWidget {
  final UserProfileModel profile;
  const AyurIdCard({super.key, required this.profile});

  void _copyId(BuildContext context) {
    Clipboard.setData(ClipboardData(text: profile.ayurId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Ayur ID copied to clipboard'),
        backgroundColor: AppColors.navyMid,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.navyDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('AYUR ID',
            style: TextStyle(
                color: AppColors.textHint,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text(profile.ayurId,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 3)),
          const SizedBox(height: 14),
          Row(
            children: [
              // Verified badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.teal.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColors.teal, width: 0.5),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified_rounded,
                        color: AppColors.teal, size: 13),
                    SizedBox(width: 5),
                    Text('Aadhar Verified',
                      style: TextStyle(
                          color: AppColors.teal,
                          fontSize: 10,
                          fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const Spacer(),
              // Copy button
              GestureDetector(
                onTap: () => _copyId(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.copy_rounded,
                          color: AppColors.textHint, size: 13),
                      SizedBox(width: 4),
                      Text('Copy',
                        style: TextStyle(
                            color: AppColors.textHint,
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Share button
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.share_outlined,
                          color: AppColors.textHint, size: 13),
                      SizedBox(width: 4),
                      Text('Share',
                        style: TextStyle(
                            color: AppColors.textHint,
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Encrypted notice
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.lock_outlined,
                    color: Colors.white38, size: 13),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Aadhar linked via AES-256 encryption. '
                    'Your identity is safe.',
                    style: TextStyle(color: Colors.white38,
                        fontSize: 10, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
