import 'package:flutter/material.dart';
import '../../core/translations/tr_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/translations/app_translations.dart';

class OrthoExercisesScreen extends StatelessWidget {
  const OrthoExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We expect translations for: 'ortho_exercises', 'ortho_desc', etc.
    // If they don't exist, fallback to English.
    
    final exercises = [
      {
        'title': context.tr('knee_extension') ?? 'Knee Extension',
        'desc': context.tr('knee_extension_desc') ?? 'Sit on a chair and slowly straighten one leg. Hold for 5 seconds.',
        'reps': '3 sets x 10 reps',
        'icon': Icons.airline_seat_legroom_extra,
        'color': const Color(0xFF185FA5),
      },
      {
        'title': context.tr('shoulder_shrugs') ?? 'Shoulder Shrugs',
        'desc': context.tr('shoulder_shrugs_desc') ?? 'Stand straight, lift shoulders towards ears, hold, and release downwards.',
        'reps': '3 sets x 15 reps',
        'icon': Icons.accessibility_new_rounded,
        'color': const Color(0xFF0F6E56),
      },
      {
        'title': context.tr('ankle_pumps') ?? 'Ankle Pumps',
        'desc': context.tr('ankle_pumps_desc') ?? 'Pump your ankles up and down continuously to improve circulation.',
        'reps': '2 sets x 20 reps',
        'icon': Icons.nordic_walking,
        'color': const Color(0xFFD85A30),
      },
      {
        'title': context.tr('wall_slides') ?? 'Wall Slides',
        'desc': context.tr('wall_slides_desc') ?? 'Lean back against a wall and slowly slide down into a half-squat, then back up.',
        'reps': '3 sets x 8 reps',
        'icon': Icons.sports_gymnastics,
        'color': const Color(0xFF534AB7),
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        title: Text(context.tr('ortho_exercises') ?? 'Ortho Exercises'),
        backgroundColor: AppColors.navyDark,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final ex = exercises[i];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: (ex['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(ex['icon'] as IconData,
                      color: ex['color'] as Color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ex['title'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        )),
                      const SizedBox(height: 4),
                      Text(ex['desc'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        )),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.teal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(ex['reps'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.teal,
                          )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
