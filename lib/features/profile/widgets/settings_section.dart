import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SettingsSection extends StatefulWidget {
  const SettingsSection({super.key});
  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  bool _notifications = true;
  bool _sosSafety     = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ToggleSetting(
          icon: Icons.notifications_outlined,
          iconBg: AppColors.blueLight,
          iconColor: AppColors.blue,
          label: 'Notifications',
          value: _notifications,
          onToggle: (v) => setState(() => _notifications = v),
        ),
        const SizedBox(height: 8),
        _ToggleSetting(
          icon: Icons.shield_outlined,
          iconBg: const Color(0xFFEAF3DE),
          iconColor: AppColors.teal,
          label: 'Solo Safety System',
          subtitle: 'Background SOS keyword detection',
          value: _sosSafety,
          onToggle: (v) => setState(() => _sosSafety = v),
        ),
        const SizedBox(height: 8),
        _NavSetting(
          icon: Icons.family_restroom_rounded,
          iconBg: const Color(0xFFEEEDFE),
          iconColor: const Color(0xFF534AB7),
          label: 'Guardians & Family',
          subtitle: 'Manage emergency contacts',
          onTap: () {},
        ),
        const SizedBox(height: 8),
        _NavSetting(
          icon: Icons.lock_outline_rounded,
          iconBg: const Color(0xFFFAEEDA),
          iconColor: const Color(0xFFBA7517),
          label: 'Privacy & Security',
          subtitle: 'Aadhar, biometrics, data',
          onTap: () {},
        ),
        const SizedBox(height: 8),
        _NavSetting(
          icon: Icons.language_rounded,
          iconBg: AppColors.bgMuted,
          iconColor: AppColors.navyLight,
          label: 'Language',
          subtitle: 'English',
          onTap: () {},
        ),
        const SizedBox(height: 8),
        _NavSetting(
          icon: Icons.help_outline_rounded,
          iconBg: AppColors.bgMuted,
          iconColor: AppColors.navyLight,
          label: 'Help & Support',
          subtitle: 'FAQ, contact us',
          onTap: () {},
        ),
        const SizedBox(height: 8),
        _NavSetting(
          icon: Icons.info_outline_rounded,
          iconBg: AppColors.bgMuted,
          iconColor: AppColors.navyLight,
          label: 'About AyurVanta',
          subtitle: 'Version 1.0.0',
          onTap: () {},
        ),
      ],
    );
  }
}

// ── Toggle Setting ───────────────────────────────────────
class _ToggleSetting extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onToggle;

  const _ToggleSetting({
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
            color: const Color(0xFFE3EAF2), width: 0.5),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                  style: const TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!,
                    style: const TextStyle(fontSize: 11,
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

// ── Nav Setting ──────────────────────────────────────────
class _NavSetting extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _NavSetting({
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
              color: const Color(0xFFE3EAF2), width: 0.5),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                    style: const TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!,
                      style: const TextStyle(fontSize: 11,
                          color: AppColors.textSecondary)),
                  ],
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
