import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class EmergencyTypeGrid extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const EmergencyTypeGrid({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _types = [
    {'label': 'Ambulance', 'icon': Icons.airport_shuttle_rounded},
    {'label': 'Hospital',  'icon': Icons.local_hospital_rounded},
    {'label': 'Cardiac',   'icon': Icons.favorite_rounded},
    {'label': 'Accident',  'icon': Icons.car_crash_rounded},
    {'label': 'Fire',      'icon': Icons.local_fire_department_rounded},
    {'label': 'Other',     'icon': Icons.warning_amber_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.3,
      children: _types.map((t) {
        final label = t['label'] as String;
        final icon  = t['icon']  as IconData;
        final isSelected = selected == label;
        return GestureDetector(
          onTap: () => onSelected(label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.emergency.withOpacity(0.2)
                  : Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.emergency
                    : Colors.white.withOpacity(0.1),
                width: isSelected ? 1.5 : 0.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                  color: isSelected
                      ? AppColors.emergency
                      : Colors.white54,
                  size: 24,
                ),
                const SizedBox(height: 5),
                Text(label,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.white54,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
