import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../models/user_profile_model.dart';
import '../widgets/ayurid_card.dart';
import '../widgets/profile_stats_row.dart';
import '../widgets/personal_info_card.dart';
import '../widgets/settings_section.dart';
import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _profile = UserProfileModel(
    name: 'Arjun Sharma',
    phone: '+91 98765 43210',
    email: 'arjun@gmail.com',
    ayurId: 'AYR-4829-3810-7642',
    dob: '14 Mar 1990',
    bloodGroup: 'B+',
    gender: 'Male',
    height: 172,
    weight: 74,
    allergies: ['Penicillin'],
    isAadharVerified: true,
    memberSince: 'January 2025',
    appointments: 12,
    records: 24,
    prescriptions: 8,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _TopBar(profile: _profile),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ayur ID card
                  FadeInDown(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          16, 0, 16, 14),
                      child: AyurIdCard(profile: _profile),
                    ),
                  ),

                  // Stats
                  FadeInUp(
                    delay: const Duration(milliseconds: 100),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16),
                      child: ProfileStatsRow(profile: _profile),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Personal info
                  FadeInUp(
                    delay: const Duration(milliseconds: 150),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text('Personal Information',
                            style: TextStyle(fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary)),
                          const SizedBox(height: 10),
                          PersonalInfoCard(profile: _profile),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Settings
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text('Settings',
                            style: TextStyle(fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary)),
                          const SizedBox(height: 10),
                          const SettingsSection(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Logout
                  FadeInUp(
                    delay: const Duration(milliseconds: 250),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          16, 0, 16, 30),
                      child: GestureDetector(
                        onTap: () => _confirmLogout(context),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCEBEB),
                            borderRadius:
                                BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFFF09595),
                              width: 0.5,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout_rounded,
                                  color: Color(0xFFE24B4A),
                                  size: 18),
                              SizedBox(width: 8),
                              Text('Logout',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFE24B4A),
                                )),
                            ],
                          ),
                        ),
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

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout?',
          style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text(
            'Are you sure you want to logout from AyurVanta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE24B4A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

// ── Top Bar ──────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final UserProfileModel profile;
  const _TopBar({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navyDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16, right: 16, bottom: 20,
      ),
      child: Column(
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
                  child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('My Profile',
                  style: TextStyle(color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.edit_outlined,
                          color: Colors.white, size: 14),
                      SizedBox(width: 5),
                      Text('Edit',
                        style: TextStyle(color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.teal,
                    child: Text(
                      profile.name.split(' ')
                          .map((e) => e[0]).take(2).join(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 18, height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.teal,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.navyDark, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt_rounded,
                          color: Colors.white, size: 9),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                    const SizedBox(height: 3),
                    Text(profile.phone,
                      style: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(profile.email,
                      style: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 12)),
                    const SizedBox(height: 5),
                    Text(
                      'Member since \${profile.memberSince}',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.35),
                          fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
