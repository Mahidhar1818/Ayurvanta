import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SpecialtyChipBar extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const SpecialtyChipBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _specialties = [
    'All', 'Cardiologist', 'Dermatologist',
    'Neurologist', 'Pediatrician', 'Orthopedic',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _specialties.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final s = _specialties[i];
          final isActive = s == selected;
          return GestureDetector(
            onTap: () => onSelected(s),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.blue : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? AppColors.blue
                      : const Color(0xFFE3EAF2),
                  width: 0.5,
                ),
              ),
              child: Text(s,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? Colors.white
                      : AppColors.navyLight,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
