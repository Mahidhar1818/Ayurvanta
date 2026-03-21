import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/user_profile_model.dart';

class PersonalInfoCard extends StatelessWidget {
  final UserProfileModel profile;
  const PersonalInfoCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Full Name',       profile.name),
      ('Date of Birth',   '${profile.dob} (36 yrs)'),
      ('Blood Group',     profile.bloodGroup),
      ('Gender',          profile.gender),
      ('Height / Weight', '${profile.height.toInt()} cm '
          '/ ${profile.weight.toInt()} kg'),
      ('Allergies',       profile.allergies.join(', ')),
      ('Phone',           profile.phone),
      ('Email',           profile.email),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        children: rows.asMap().entries.map((e) {
          final isLast = e.key == rows.length - 1;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: isLast ? null : const Border(
                bottom: BorderSide(
                    color: Color(0xFFF0F4F8), width: 0.5),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  child: Text(e.value.$1,
                    style: const TextStyle(fontSize: 12,
                        color: AppColors.textSecondary)),
                ),
                Expanded(
                  child: Text(e.value.$2,
                    style: const TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
