import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/user_profile_model.dart';

class ProfileStatsRow extends StatelessWidget {
  final UserProfileModel profile;
  const ProfileStatsRow({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(value: '${profile.appointments}',
            label: 'Appointments',
            icon: Icons.calendar_today_outlined,
            color: AppColors.blue),
        const SizedBox(width: 8),
        _StatCard(value: '${profile.records}',
            label: 'Records',
            icon: Icons.folder_outlined,
            color: AppColors.teal),
        const SizedBox(width: 8),
        _StatCard(value: '${profile.prescriptions}',
            label: 'Prescriptions',
            icon: Icons.medication_outlined,
            color: const Color(0xFF534AB7)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _StatCard({required this.value, required this.label,
      required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: const Color(0xFFE3EAF2), width: 0.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
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
