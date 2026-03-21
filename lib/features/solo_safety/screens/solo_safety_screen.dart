import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../emergency/screens/emergency_screen.dart';

class SoloSafetyScreen extends StatefulWidget {
  const SoloSafetyScreen({super.key});
  @override
  State<SoloSafetyScreen> createState() =>
      _SoloSafetyScreenState();
}

class _SoloSafetyScreenState
    extends State<SoloSafetyScreen> {
  bool _isEnabled       = false;
  bool _shareHistory    = true;
  bool _alertContacts   = true;
  bool _alertAmbulance  = true;

  final _contacts = [
    ('Priya Sharma', '+91 98765 11111', 'Wife'),
    ('Ramesh Sharma', '+91 87654 22222', 'Father'),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      _isEnabled    = p.getBool('solo_safety') ?? false;
      _shareHistory = p.getBool('solo_share_history')
          ?? true;
      _alertContacts =
          p.getBool('solo_alert_contacts') ?? true;
      _alertAmbulance =
          p.getBool('solo_alert_ambulance') ?? true;
    });
  }

  Future<void> _toggle(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('solo_safety', v);
    setState(() => _isEnabled = v);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.navyDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Solo Safety System 🛡️',
          style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // Main toggle card
            FadeInDown(
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _isEnabled
                      ? AppColors.teal.withOpacity(0.1)
                      : Colors.white,
                  borderRadius:
                      BorderRadius.circular(18),
                  border: Border.all(
                    color: _isEnabled
                        ? AppColors.teal
                        : const Color(0xFFE3EAF2),
                    width: _isEnabled ? 1.5 : 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 54, height: 54,
                      decoration: BoxDecoration(
                        color: _isEnabled
                            ? AppColors.teal
                            : AppColors.bgMuted,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shield_rounded,
                        color: _isEnabled
                            ? Colors.white
                            : AppColors.textHint,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isEnabled
                                ? 'ACTIVE — Listening'
                                : 'Solo Safety OFF',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: _isEnabled
                                  ? AppColors.teal
                                  : AppColors.textPrimary,
                            )),
                          const SizedBox(height: 3),
                          Text(
                            _isEnabled
                                ? 'App is listening for emergency keywords'
                                : 'Enable to activate background emergency detection',
                            style: TextStyle(
                              fontSize: 12,
                              color: _isEnabled
                                  ? AppColors.teal
                                  : AppColors.textSecondary,
                            )),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isEnabled,
                      onChanged: _toggle,
                      activeColor: AppColors.teal,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // How it works
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F1FB),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📖 How it works',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue,
                      )),
                    const SizedBox(height: 8),
                    ...[
                      'App listens in background for keywords',
                      'Keywords: "Help", "Emergency", "Save me"',
                      'On detection: alerts your contacts',
                      'Sends your live location automatically',
                      'Shares medical history (if enabled)',
                      'Dispatches nearest ambulance',
                    ].map((s) => Padding(
                      padding:
                          const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Icon(
                              Icons.circle,
                              size: 6,
                              color: AppColors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(s,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.blue,
                                height: 1.4,
                              ))),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Settings
            const Text('Settings',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              )),
            const SizedBox(height: 10),

            _SettingTile(
              icon: Icons.history_rounded,
              label: 'Share Medical History',
              subtitle:
                  'Send your Ayur ID record on SOS',
              value: _shareHistory,
              onToggle: (v) async {
                final p = await SharedPreferences
                    .getInstance();
                await p.setBool(
                    'solo_share_history', v);
                setState(() => _shareHistory = v);
              },
            ),
            const SizedBox(height: 8),
            _SettingTile(
              icon: Icons.contacts_rounded,
              label: 'Alert Emergency Contacts',
              subtitle:
                  'SMS + notification to your guardians',
              value: _alertContacts,
              onToggle: (v) async {
                final p = await SharedPreferences
                    .getInstance();
                await p.setBool(
                    'solo_alert_contacts', v);
                setState(() => _alertContacts = v);
              },
            ),
            const SizedBox(height: 8),
            _SettingTile(
              icon: Icons.local_taxi_rounded,
              label: 'Auto-dispatch Ambulance',
              subtitle:
                  'Nearest ambulance booked on detection',
              value: _alertAmbulance,
              onToggle: (v) async {
                final p = await SharedPreferences
                    .getInstance();
                await p.setBool(
                    'solo_alert_ambulance', v);
                setState(() => _alertAmbulance = v);
              },
            ),
            const SizedBox(height: 16),

            // Emergency contacts
            const Text('Emergency Contacts',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              )),
            const SizedBox(height: 10),
            ..._contacts.map((c) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFE3EAF2),
                    width: 0.5),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.blueLight,
                    child: Text(c.$1[0],
                      style: const TextStyle(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w700,
                      ))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(c.$1,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          )),
                        Text('${c.$2} · ${c.$3}',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const Icon(
                      Icons.phone_rounded,
                      color: AppColors.teal, size: 20),
                ],
              ),
            )),
            const SizedBox(height: 16),

            // Test SOS
            FadeInUp(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.push(context,
                        MaterialPageRoute(builder: (_) =>
                            const EmergencyScreen())),
                  icon: const Icon(
                      Icons.emergency_share_rounded),
                  label: const Text('Test Emergency SOS'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.emergency,
                    side: const BorderSide(
                        color: AppColors.emergency,
                        width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final bool value;
  final ValueChanged<bool> onToggle;
  const _SettingTile({
    required this.icon, required this.label,
    required this.subtitle, required this.value,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: AppColors.blueLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.blue,
                size: 18)),
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
                Text(subtitle,
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary)),
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
