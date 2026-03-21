import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class RecentRecordsList extends StatelessWidget {
  const RecentRecordsList({super.key});

  final _records = const [
    {'name': 'Blood Test Report', 'date': 'Mar 18', 'color': AppColors.blue},
    {'name': 'Prescription – Dr. Ravi', 'date': 'Mar 12', 'color': AppColors.teal},
    {'name': 'ECG Report', 'date': 'Feb 28', 'color': Color(0xFFBA7517)},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _records.map((r) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
        ),
        child: Row(
          children: [
            Container(width: 8, height: 8,
                decoration: BoxDecoration(
                    color: r['color'] as Color, shape: BoxShape.circle)),
            const SizedBox(width: 12),
            Expanded(child: Text(r['name'] as String,
                style: const TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary))),
            Text(r['date'] as String,
                style: const TextStyle(fontSize: 11,
                    color: AppColors.textSecondary)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios,
                size: 12, color: AppColors.textHint),
          ],
        ),
      )).toList(),
    );
  }
}
