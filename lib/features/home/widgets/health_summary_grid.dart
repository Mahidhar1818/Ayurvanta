import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class HealthSummaryGrid extends StatelessWidget {
  const HealthSummaryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: const [
        _HealthCard(label: 'Blood Pressure', value: '120', unit: '/80',
            status: 'Normal', isWarning: false),
        _HealthCard(label: 'Heart Rate', value: '72', unit: ' bpm',
            status: 'Normal', isWarning: false),
        _HealthCard(label: 'Blood Sugar', value: '108', unit: ' mg/dL',
            status: 'Borderline', isWarning: true),
        _HealthCard(label: 'SpO₂', value: '98', unit: '%',
            status: 'Normal', isWarning: false),
      ],
    );
  }
}

class _HealthCard extends StatelessWidget {
  final String label, value, unit, status;
  final bool isWarning;
  const _HealthCard({required this.label, required this.value,
      required this.unit, required this.status, required this.isWarning});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 11,
              color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
              Text(unit, style: const TextStyle(fontSize: 11,
                  color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 4),
          Text(isWarning ? '⚠ $status' : '✓ $status',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                  color: isWarning
                      ? const Color(0xFF854F0B)
                      : const Color(0xFF3B6D11))),
        ],
      ),
    );
  }
}
