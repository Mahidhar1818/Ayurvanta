import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class DispatchStatusCard extends StatelessWidget {
  const DispatchStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: Colors.white.withOpacity(0.1), width: 0.5),
      ),
      child: Column(
        children: [
          // Ambulance row
          _DispatchRow(
            icon: Icons.airport_shuttle_rounded,
            title: 'Ambulance Dispatched',
            subtitle: 'Unit AY-042 · 1.2 km away',
            badgeText: 'En Route',
            badgeColor: AppColors.teal,
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 14),

          // Hospital row
          _DispatchRow(
            icon: Icons.local_hospital_rounded,
            title: '3 Hospitals Alerted',
            subtitle: 'Apollo · Yashoda · KIMS',
            badgeText: 'Notified',
            badgeColor: AppColors.blue,
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 14),

          // ETA stats
          Row(
            children: [
              _EtaStat(value: '4 min', label: 'ETA'),
              _Divider(),
              _EtaStat(value: '1.2 km', label: 'Distance'),
              _Divider(),
              _EtaStat(value: '3', label: 'Hospitals'),
              _Divider(),
              _EtaStat(value: 'AYR-4829', label: 'Ayur ID'),
            ],
          ),
        ],
      ),
    );
  }
}

class _DispatchRow extends StatelessWidget {
  final IconData icon;
  final String title, subtitle, badgeText;
  final Color badgeColor;
  const _DispatchRow({
    required this.icon, required this.title,
    required this.subtitle, required this.badgeText,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: AppColors.emergency.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon,
              color: AppColors.emergency, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                style: const TextStyle(color: Colors.white,
                    fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle,
                style: const TextStyle(color: Colors.white38,
                    fontSize: 11)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(badgeText,
            style: const TextStyle(color: Colors.white,
                fontSize: 10, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

class _EtaStat extends StatelessWidget {
  final String value, label;
  const _EtaStat({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
            style: const TextStyle(color: Colors.white,
                fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(label,
            style: const TextStyle(color: Colors.white38,
                fontSize: 10)),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      width: 0.5, height: 28,
      color: Colors.white.withOpacity(0.1));
}
