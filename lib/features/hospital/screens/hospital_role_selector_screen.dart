import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/app_module.dart';
import 'hospital_login_screen.dart';

class HospitalRoleSelectorScreen extends StatelessWidget {
  const HospitalRoleSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          // Top Bar
          Container(
            color: const Color(0xFF0A1F12),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16, right: 16, bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D9E75),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Center(
                        child: Text('🏥',
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('Hospital Portal',
                        style: TextStyle(color: Colors.white,
                            fontSize: 17, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 20),
                FadeInLeft(
                  child: const Text('Who are you?',
                      style: TextStyle(color: Colors.white,
                          fontSize: 26, fontWeight: FontWeight.w800)),
                ),
                const SizedBox(height: 6),
                FadeInLeft(
                  delay: const Duration(milliseconds: 100),
                  child: const Text(
                      'Select your role to access the\n'
                          'Hospital Management System.',
                      style: TextStyle(color: Colors.white54,
                          fontSize: 13, height: 1.55)),
                ),
              ],
            ),
          ),

          // Role cards
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  ...HospitalRoleInfo.all.asMap().entries.map((e) {
                    final role = e.value;
                    return FadeInUp(
                      delay: Duration(milliseconds: e.key * 100),
                      child: _RoleCard(
                        info: role,
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) =>
                                HospitalLoginScreen(role: role))),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),

                  // Notice card
                  FadeInUp(
                    delay: const Duration(milliseconds: 450),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: const Color(0xFFE3EAF2), width: 0.5),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.lock_outline_rounded,
                              color: AppColors.textSecondary, size: 16),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Access is restricted to authorised hospital '
                                  'staff only. Credentials are issued by your '
                                  'Hospital Admin.',
                              style: TextStyle(fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final HospitalRoleInfo info;
  final VoidCallback onTap;
  const _RoleCard({required this.info, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: info.bgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: info.borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            // Role icon container
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: info.iconBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                  child: Text(info.emoji,
                      style: const TextStyle(fontSize: 26))),
            ),
            const SizedBox(width: 16),

            // Role info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(info.name,
                      style: TextStyle(fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: info.textColor)),
                  const SizedBox(height: 4),
                  Text(info.description,
                      style: TextStyle(fontSize: 12,
                          color: info.textColor.withOpacity(0.65),
                          height: 1.4)),
                ],
              ),
            ),

            // Arrow
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: info.iconBg.withOpacity(0.15),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: info.textColor),
            ),
          ],
        ),
      ),
    );
  }
}