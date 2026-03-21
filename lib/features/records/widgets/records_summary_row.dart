import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class RecordsSummaryRow extends StatelessWidget {
  final int total, prescriptions, scans;
  const RecordsSummaryRow({
    super.key,
    required this.total,
    required this.prescriptions,
    required this.scans,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SummaryCard(value: '$total',    label: 'Total Records'),
        const SizedBox(width: 8),
        _SummaryCard(value: '$prescriptions', label: 'Prescriptions'),
        const SizedBox(width: 8),
        _SummaryCard(value: '$scans',    label: 'Scans'),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String value, label;
  const _SummaryCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: const Color(0xFFE3EAF2), width: 0.5),
        ),
        child: Column(
          children: [
            Text(value,
              style: const TextStyle(fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary)),
            const SizedBox(height: 3),
            Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
