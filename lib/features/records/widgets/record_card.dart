import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/record_model.dart';

class RecordCard extends StatelessWidget {
  final RecordModel record;
  const RecordCard({super.key, required this.record});

  Color get _statusColor {
    switch (record.status) {
      case RecordStatus.normal:     return const Color(0xFF3B6D11);
      case RecordStatus.borderline: return const Color(0xFF854F0B);
      case RecordStatus.review:     return const Color(0xFF993556);
      default:                      return AppColors.blue;
    }
  }

  Color get _statusBg {
    switch (record.status) {
      case RecordStatus.normal:     return const Color(0xFFEAF3DE);
      case RecordStatus.borderline: return const Color(0xFFFAEEDA);
      case RecordStatus.review:     return const Color(0xFFFBEAF0);
      default:                      return AppColors.blueLight;
    }
  }

  String get _statusText {
    switch (record.status) {
      case RecordStatus.normal:     return 'Normal';
      case RecordStatus.borderline: return 'Borderline';
      case RecordStatus.review:     return 'Review';
      default:                      return 'Active';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: record.iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(record.icon,
                    color: AppColors.blue, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(record.title,
                      style: const TextStyle(fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text('\${record.date} · \${record.doctor}',
                      style: const TextStyle(fontSize: 11,
                          color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_statusText,
                  style: TextStyle(fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFFF0F4F8), height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.local_hospital_outlined,
                  size: 13, color: AppColors.textHint),
              const SizedBox(width: 5),
              Text(record.hospital,
                style: const TextStyle(fontSize: 11,
                    color: AppColors.textSecondary)),
              const Spacer(),
              _ActionBtn(
                icon: Icons.visibility_outlined,
                label: 'View',
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _ActionBtn(
                icon: Icons.download_rounded,
                label: 'Download',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.bgPage,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 13,
                color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(label,
              style: const TextStyle(fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
