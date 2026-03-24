import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/translations/tr_extension.dart';
import '../../../core/services/auth_preference_service.dart';
import '../../onboarding/screens/language_selection_screen.dart';
import '../../onboarding/screens/module_selector_screen.dart';
import '../../../core/translations/app_translations.dart';
import '../../solo_safety/screens/solo_safety_screen.dart';
import 'edit_profile_screen.dart';
import 'privacy_screen.dart';
import 'help_support_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsOn = true;
  bool _sosSafetyOn     = true;

  void _copyAyurId() {
    Clipboard.setData(
        const ClipboardData(text: 'AYR-4829-3810-7642'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('ayur_id') +
            ' copied to clipboard'),
        backgroundColor: AppColors.navyMid,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text(context.tr('logout'),
          style: const TextStyle(
              fontWeight: FontWeight.w700)),
        content: Text(context.tr('logout_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('cancel'))),
          ElevatedButton(
            onPressed: () async {
              await AuthPreferenceService.logout();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) =>
                    const ModuleSelectorScreen()),
                (_) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFFE24B4A),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10)),
            ),
            child: Text(context.tr('logout'))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Ayur ID card
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        16, 0, 16, 14),
                    child: _buildAyurIdCard(context),
                  ),

                  // Stats
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16),
                    child: _buildStats(context),
                  ),
                  const SizedBox(height: 16),

                  // Personal info
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('personal_info'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          )),
                        const SizedBox(height: 10),
                        _buildPersonalInfo(context),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Settings
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(context.tr('settings'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          )),
                        const SizedBox(height: 10),
                        _buildSettings(context),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Logout
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        16, 0, 16, 30),
                    child: GestureDetector(
                      onTap: _confirmLogout,
                      child: Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFFCEBEB),
                          borderRadius:
                              BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(
                                0xFFF09595),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            const Icon(
                                Icons.logout_rounded,
                                color: Color(0xFFE24B4A),
                                size: 18),
                            const SizedBox(width: 8),
                            Text(context.tr('logout'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.w700,
                                color: Color(0xFFE24B4A),
                              )),
                          ],
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

  Widget _buildTopBar(BuildContext context) {
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
              const Expanded(
                child: Text('My Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  )),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: 14),
                      const SizedBox(width: 5),
                      Text(context.tr('edit'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.teal,
                    child: Text('AS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      )),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 18, height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.teal,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.navyDark,
                            width: 2),
                      ),
                      child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 9),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text('Arjun Sharma',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      )),
                    const SizedBox(height: 2),
                    const Text('+91 98765 43210',
                      style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 12)),
                    Text(
                      'Member since Jan 2025',
                      style: TextStyle(
                        color: Colors.white
                            .withOpacity(0.35),
                        fontSize: 11,
                      )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAyurIdCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navyDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr('ayur_id'),
            style: const TextStyle(
              color: AppColors.textHint,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            )),
          const SizedBox(height: 8),
          const Text('AYR-4829-3810-7642',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 3,
            )),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color:
                      AppColors.teal.withOpacity(0.15),
                  borderRadius:
                      BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColors.teal,
                      width: 0.5),
                ),
                child: Row(
                  children: [
                    const Icon(
                        Icons.verified_rounded,
                        color: AppColors.teal,
                        size: 13),
                    const SizedBox(width: 5),
                    Text(
                      context.tr('aadhar_verified'),
                      style: const TextStyle(
                        color: AppColors.teal,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      )),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _copyAyurId,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.08),
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.copy_rounded,
                          color: AppColors.textHint,
                          size: 13),
                      const SizedBox(width: 4),
                      Text(context.tr('copy'),
                        style: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Row(
      children: [
        _StatCard('12', context.tr('book_appt'),
            Icons.calendar_today_outlined,
            AppColors.blue),
        const SizedBox(width: 8),
        _StatCard('24', context.tr('records'),
            Icons.folder_outlined, AppColors.teal),
        const SizedBox(width: 8),
        _StatCard('8', context.tr('prescriptions'),
            Icons.medication_outlined,
            const Color(0xFF534AB7)),
      ],
    );
  }

  Widget _buildPersonalInfo(BuildContext context) {
    final rows = [
      (context.tr('full_name'), 'Arjun Sharma'),
      (context.tr('date_of_birth'),
          '14 Mar 1990 (36 yrs)'),
      (context.tr('blood_group'), 'B+'),
      (context.tr('gender'), 'Male'),
      (context.tr('height_weight'),
          '172 cm / 74 kg'),
      (context.tr('allergies'), 'Penicillin'),
      (context.tr('phone'), '+91 98765 43210'),
      (context.tr('email'), 'arjun@gmail.com'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFE3EAF2),
            width: 0.5),
      ),
      child: Column(
        children: rows.asMap().entries.map((e) {
          final isLast = e.key == rows.length - 1;
          return Container(
            padding: const EdgeInsets.symmetric(
                vertical: 10),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(
                      bottom: BorderSide(
                          color: Color(0xFFF0F4F8),
                          width: 0.5)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  child: Text(e.value.$1,
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary)),
                ),
                Expanded(
                  child: Text(e.value.$2,
                    style: const TextStyle(
                        fontSize: 13,
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

  Widget _buildSettings(BuildContext context) {
    return Column(
      children: [
        _ToggleTile(
          icon: Icons.notifications_outlined,
          iconBg: AppColors.blueLight,
          iconColor: AppColors.blue,
          label: context.tr('notifications'),
          value: _notificationsOn,
          onToggle: (v) =>
              setState(() => _notificationsOn = v),
        ),
        const SizedBox(height: 8),
        _ToggleTile(
          icon: Icons.shield_outlined,
          iconBg: const Color(0xFFEAF3DE),
          iconColor: AppColors.teal,
          label: context.tr('solo_safety'),
          subtitle: context.tr('solo_safety_sub'),
          value: _sosSafetyOn,
          onToggle: (v) =>
              setState(() => _sosSafetyOn = v),
        ),
        const SizedBox(height: 8),

        // Language nav tile
        _NavTile(
          icon: Icons.language_rounded,
          iconBg: const Color(0xFFEEEDFE),
          iconColor: const Color(0xFF534AB7),
          label: context.tr('language'),
          subtitle: _getLangName(context),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      const LanguageSelectionScreen())),
        ),
        const SizedBox(height: 8),
        _NavTile(
          icon: Icons.family_restroom_rounded,
          iconBg: const Color(0xFFFAEEDA),
          iconColor: const Color(0xFFBA7517),
          label: context.tr('guardians'),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SoloSafetyScreen())),
        ),
        const SizedBox(height: 8),
        _NavTile(
          icon: Icons.lock_outline_rounded,
          iconBg: const Color(0xFFE3EAF2),
          iconColor: AppColors.navyLight,
          label: context.tr('privacy'),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyScreen())),
        ),
        const SizedBox(height: 8),
        _NavTile(
          icon: Icons.help_outline_rounded,
          iconBg: const Color(0xFFE3EAF2),
          iconColor: AppColors.navyLight,
          label: context.tr('help'),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen())),
        ),
        const SizedBox(height: 8),
        _NavTile(
          icon: Icons.info_outline_rounded,
          iconBg: const Color(0xFFE3EAF2),
          iconColor: AppColors.navyLight,
          label: context.tr('about'),
          subtitle: 'Version 1.0.0',
          onTap: () {},
        ),
      ],
    );
  }

  String _getLangName(BuildContext context) {
    final code = AppTranslations.instance.currentLang;
    const names = {
      'en': 'English', 'hi': 'हिन्दी',
      'te': 'తెలుగు', 'ta': 'தமிழ்',
      'kn': 'ಕನ್ನಡ', 'ml': 'മലയാളം',
      'mr': 'मराठी', 'bn': 'বাংলা',
      'gu': 'ગુજરાતી',
    };
    return names[code] ?? 'English';
  }
}

// ── Shared Widgets ───────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _StatCard(this.value, this.label,
      this.icon, this.color);

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
              color: const Color(0xFFE3EAF2),
              width: 0.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              )),
            const SizedBox(height: 3),
            Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              )),
          ],
        ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onToggle;

  const _ToggleTile({
    required this.icon, required this.iconBg,
    required this.iconColor, required this.label,
    this.subtitle, required this.value,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFFE3EAF2),
            width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  )),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary)),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onToggle,
            activeColor: AppColors.teal,
            materialTapTargetSize:
                MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon, required this.iconBg,
    required this.iconColor, required this.label,
    this.subtitle, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: const Color(0xFFE3EAF2),
              width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius:
                      BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor,
                  size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    )),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary)),
                  ],
                ],
              ),
            ),
            const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
