import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class UploadRxScreen extends StatelessWidget {
  final bool isEmbedded;
  const UploadRxScreen({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              color: AppColors.blueLight,
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(Icons.upload_file_rounded,
                color: AppColors.blue, size: 48),
          ),
          const SizedBox(height: 20),
          const Text('Upload Prescription',
            style: TextStyle(fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text(
            'Upload your doctor\'s prescription and we\'ll\n'
            'prepare your medicines for 2-hour delivery.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13,
                color: AppColors.textSecondary, height: 1.6),
          ),
          const SizedBox(height: 32),
          _UploadOption(
            icon: Icons.camera_alt_rounded,
            title: 'Take a Photo',
            subtitle: 'Click a clear photo of your prescription',
            color: AppColors.teal,
          ),
          const SizedBox(height: 12),
          _UploadOption(
            icon: Icons.photo_library_rounded,
            title: 'Upload from Gallery',
            subtitle: 'Choose from your phone gallery',
            color: AppColors.blue,
          ),
          const SizedBox(height: 12),
          _UploadOption(
            icon: Icons.folder_outlined,
            title: 'From Medical Records',
            subtitle: 'Use a prescription from your AyurVanta records',
            color: const Color(0xFF534AB7),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFAEEDA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    color: Color(0xFF854F0B), size: 16),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Prescription medicines require a valid Rx from '
                    'a registered doctor. Your Ayur ID helps verify automatically.',
                    style: TextStyle(fontSize: 11,
                        color: Color(0xFF854F0B), height: 1.5),
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

class _UploadOption extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Color color;
  const _UploadOption({required this.icon, required this.title,
      required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: const Color(0xFFE3EAF2), width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: const TextStyle(fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                    style: const TextStyle(fontSize: 12,
                        color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
