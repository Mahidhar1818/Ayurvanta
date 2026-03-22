import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/translations/tr_extension.dart';
import '../../appointments/screens/op_booking_screen.dart';
import '../../consultation/screens/consultation_screen.dart';
import '../../medicines/screens/medicine_screen.dart';
import '../../homecare/screens/symptom_diet_screen.dart';
import '../../emergency/screens/emergency_screen.dart';
import '../../chat/screens/ai_chat_screen.dart';
import '../../diet/screens/diet_map_screen.dart';
import '../../schemes/screens/schemes_screen.dart';
import '../../opportunities/screens/opportunities_screen.dart';
import '../../records/screens/records_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../solo_safety/screens/solo_safety_screen.dart';
import '../../solo_safety/screens/sensor_sos_screen.dart';
import '../../medicines/screens/medicine_reminder_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int    _tab      = 0;
  String _userName = 'User';
  bool   _soloOn   = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      _userName = p.getString('user_name') ?? 'User';
      _soloOn   = p.getBool('solo_safety') ?? false;
    });
  }

  // All 5 bottom nav tabs
  Widget _page(int i) {
    switch (i) {
      case 0: return _HomeTab(
          userName: _userName, soloOn: _soloOn,
          onSoloToggle: (v) async {
            final p = await SharedPreferences.getInstance();
            await p.setBool('solo_safety', v);
            setState(() => _soloOn = v);
          });
      case 1: return const RecordsScreen();
      case 2: return const AiChatScreen();
      case 3: return const MedicineScreen();
      case 4: return const ProfileScreen();
      default: return _HomeTab(
          userName: 'User', soloOn: false,
          onSoloToggle: null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: _page(_tab),
      // Floating SOS button
      floatingActionButton: _tab == 0
          ? _SosFloatingButton() : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: _BottomNav(
        current: _tab,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}

// ── Floating SOS ─────────────────────────────────────────
class _SosFloatingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: GestureDetector(
        onTap: () => Navigator.push(context,
          MaterialPageRoute(
              builder: (_) => const EmergencyScreen())),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.emergency,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.emergency
                    .withOpacity(0.5),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.emergency_share_rounded,
                  color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('EMERGENCY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                )),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Bottom Nav ───────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;
  const _BottomNav(
      {required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_rounded,         context.tr('home')),
      (Icons.folder_outlined,      context.tr('records')),
      (Icons.smart_toy_outlined,   context.tr('ai_doctor')),
      (Icons.medication_outlined,  context.tr('medicines')),
      (Icons.person_outline,       context.tr('profile')),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(
            color: Color(0xFFE3EAF2), width: 0.5)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: items.asMap().entries.map((e) {
              final i      = e.key;
              final active = current == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(e.value.$1, size: 22,
                        color: active
                            ? AppColors.blue
                            : AppColors.textHint),
                      const SizedBox(height: 3),
                      Text(e.value.$2,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: active
                              ? AppColors.blue
                              : AppColors.textHint,
                        )),
                      if (active) ...[
                        const SizedBox(height: 3),
                        Container(width: 4, height: 4,
                          decoration: const BoxDecoration(
                            color: AppColors.blue,
                            shape: BoxShape.circle)),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ── Home Tab ─────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  final String userName;
  final bool soloOn;
  final ValueChanged<bool>? onSoloToggle;
  const _HomeTab({
    required this.userName,
    required this.soloOn,
    required this.onSoloToggle,
  });

  String _greet(BuildContext ctx) {
    final h = DateTime.now().hour;
    if (h < 12) return ctx.tr('good_morning');
    if (h < 17) return ctx.tr('good_afternoon');
    return ctx.tr('good_evening');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _TopBar(greet: _greet(context),
              userName: userName,
              soloOn: soloOn,
              onSoloToggle: onSoloToggle),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                  16, 16, 16, 90),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // Solo Safety Banner
                  if (soloOn)
                    FadeInDown(child: _SoloBanner()),

                  // Main modules grid
                  FadeInUp(
                    delay: const Duration(
                        milliseconds: 50),
                    child: _sectionLabel(
                        context, 'quick_access'),
                  ),
                  const SizedBox(height: 10),
                  FadeInUp(
                    delay: const Duration(
                        milliseconds: 100),
                    child: _MainModulesGrid(),
                  ),
                  const SizedBox(height: 20),

                  // Health services
                  FadeInUp(
                    delay: const Duration(
                        milliseconds: 150),
                    child: _sectionLabel(
                        context, 'health_services'),
                  ),
                  const SizedBox(height: 10),
                  FadeInUp(
                    delay: const Duration(
                        milliseconds: 200),
                    child: _HealthServicesRow(),
                  ),
                  const SizedBox(height: 20),

                  // Upcoming appointment
                  FadeInUp(
                    delay: const Duration(
                        milliseconds: 250),
                    child: _sectionLabel(
                        context, 'upcoming_appt'),
                  ),
                  const SizedBox(height: 10),
                  FadeInUp(
                    delay: const Duration(
                        milliseconds: 300),
                    child: _UpcomingApptCard(),
                  ),
                  const SizedBox(height: 20),

                  // Health Summary
                  FadeInUp(
                    delay: const Duration(
                        milliseconds: 350),
                    child: _sectionLabel(
                        context, 'health_summary'),
                  ),
                  const SizedBox(height: 10),
                  FadeInUp(
                    delay: const Duration(
                        milliseconds: 400),
                    child: _HealthStatusGrid(),
                  ),
                  const SizedBox(height: 20),

                  // Explore
                  FadeInUp(
                    delay: const Duration(
                        milliseconds: 450),
                    child: _sectionLabel(
                        context, 'explore'),
                  ),
                  const SizedBox(height: 10),
                  FadeInUp(
                    delay: const Duration(
                        milliseconds: 500),
                    child: _ExploreRow(),
                  ),
                  const SizedBox(height: 20),

                  // Recent records
                  FadeInUp(
                    delay: const Duration(
                        milliseconds: 550),
                    child: _sectionLabel(
                        context, 'recent_records'),
                  ),
                  const SizedBox(height: 10),
                  FadeInUp(
                    delay: const Duration(
                        milliseconds: 600),
                    child: _RecentRecords(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(BuildContext ctx, String key) =>
      Text(ctx.tr(key),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ));
}

// ── Top Bar ──────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final String greet, userName;
  final bool soloOn;
  final ValueChanged<bool>? onSoloToggle;
  const _TopBar({required this.greet,
      required this.userName, required this.soloOn,
      required this.onSoloToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navyDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16, right: 16, bottom: 14,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(greet,
                      style: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      )),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.09),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'AYR-4829-3810-7642',
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        )),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.teal,
                    child: Text('AS',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14)),
                  ),
                  const SizedBox(height: 6),
                  // Solo Safety toggle button
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) =>
                          const SoloSafetyScreen())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: soloOn
                            ? AppColors.teal
                                .withOpacity(0.2)
                            : Colors.white
                                .withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(8),
                        border: Border.all(
                          color: soloOn
                              ? AppColors.teal
                              : Colors.transparent,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shield_rounded,
                            size: 12,
                            color: soloOn
                                ? AppColors.teal
                                : AppColors.textHint),
                          const SizedBox(width: 3),
                          Text(
                            soloOn ? 'SOLO ON' : 'SOLO',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: soloOn
                                  ? AppColors.teal
                                  : AppColors.textHint,
                            )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Search bar
          GestureDetector(
            onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                  const OpBookingScreen())),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.09),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search,
                      color: AppColors.textHint,
                      size: 18),
                  const SizedBox(width: 10),
                  Text(context.tr('search_hint'),
                    style: const TextStyle(
                        color: AppColors.textHint,
                        fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Solo Safety Banner ───────────────────────────────────
class _SoloBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.teal, width: 0.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_rounded,
              color: AppColors.teal, size: 16),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Solo Safety System is ACTIVE — '
              'listening for emergency keywords',
              style: TextStyle(
                color: AppColors.teal,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              )),
          ),
          const Icon(
              Icons.radio_button_checked_rounded,
              color: AppColors.teal, size: 14),
        ],
      ),
    );
  }
}

// ── Main Modules Grid ────────────────────────────────────
class _MainModulesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.local_hospital_outlined,
          context.tr('book_appt'),
          AppColors.blueLight, AppColors.blue,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                  const OpBookingScreen()))),
      (Icons.person_outlined,
          context.tr('personal_consult'),
          const Color(0xFFEEEDFE),
          const Color(0xFF534AB7),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                  const ConsultationScreen()))),
      (Icons.medication_outlined,
          context.tr('medicines'),
          const Color(0xFFEAF3DE), AppColors.teal,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                  const MedicineScreen()))),
      (Icons.home_work_outlined,
          context.tr('home_checkup'),
          const Color(0xFFFAEEDA),
          const Color(0xFFBA7517),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                  const SymptomSelectorScreen()))),
      (Icons.sensors_rounded,
          'Sensor SOS',
          const Color(0xFFFCEBEB), AppColors.emergency,
          () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => const SensorSosScreen()))),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: items.map((item) =>
        GestureDetector(
          onTap: item.$5,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 10),
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
                    color: item.$3,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  child: Icon(item.$1,
                      color: item.$4, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(item.$2,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    )),
                ),
                const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: AppColors.textHint),
              ],
            ),
          ),
        ),
      ).toList(),
    );
  }
}

// ── Health Services Row ──────────────────────────────────
class _HealthServicesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      ('🤖', context.tr('ai_doctor'),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                  const AiChatScreen()))),
      ('💊', 'Med Reminders',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                  const MedicineReminderScreen()))),
      ('🚑', context.tr('ambulance_module'),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                  const EmergencyScreen()))),
      ('🛡️', 'Solo Safety',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                  const SoloSafetyScreen()))),
    ];

    return Row(
      children: items.map((item) =>
        Expanded(
          child: GestureDetector(
            onTap: item.$3,
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 4),
              padding: const EdgeInsets.symmetric(
                  vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFE3EAF2),
                    width: 0.5),
              ),
              child: Column(
                children: [
                  Text(item.$1,
                      style: const TextStyle(
                          fontSize: 22)),
                  const SizedBox(height: 4),
                  Text(item.$2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navyLight,
                    )),
                ],
              ),
            ),
          ),
        ),
      ).toList(),
    );
  }
}

// ── Upcoming Appt Card ───────────────────────────────────
class _UpcomingApptCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
        MaterialPageRoute(builder: (_) =>
            const OpBookingScreen())),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: const Color(0xFFE3EAF2),
              width: 0.5),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius:
                        BorderRadius.circular(13),
                  ),
                  child: const Center(
                    child: Text('RK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ))),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text('Dr. Ravi Kumar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        )),
                      SizedBox(height: 2),
                      Text(
                        'Cardiologist · Apollo Hospital',
                        style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF3DE),
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  child: Text(
                    context.tr('confirmed'),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3B6D11),
                    ))),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(
                color: Color(0xFFF0F4F8), height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                    Icons.calendar_today_outlined,
                    size: 13,
                    color: AppColors.textSecondary),
                const SizedBox(width: 5),
                const Text('Tomorrow, Mar 22',
                  style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary)),
                const SizedBox(width: 16),
                const Icon(Icons.access_time_rounded,
                    size: 13,
                    color: AppColors.textSecondary),
                const SizedBox(width: 5),
                const Text('10:30 AM',
                  style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Health Status Grid ───────────────────────────────────
class _HealthStatusGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      (context.tr('blood_pressure'), '120/80',
          '', context.tr('normal'), false),
      (context.tr('heart_rate'), '72', ' bpm',
          context.tr('normal'), false),
      (context.tr('blood_sugar'), '108', ' mg/dL',
          context.tr('borderline'), true),
      ('SpO₂', '98', '%',
          context.tr('normal'), false),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: items.map((item) {
        final isWarn = item.$5;
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
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Text(item.$1,
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(item.$2,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    )),
                  Text(item.$3,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                isWarn ? '⚠ ${item.$4}'
                    : '✓ ${item.$4}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isWarn
                      ? const Color(0xFF854F0B)
                      : const Color(0xFF3B6D11),
                )),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── Explore Row ──────────────────────────────────────────
class _ExploreRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      ('🏛️', context.tr('schemes'),
          const Color(0xFFE6F1FB),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                  const SchemesScreen()))),
      ('🥗', context.tr('diet_map'),
          const Color(0xFFEAF3DE),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                  const DietMapScreen()))),
      ('💼', context.tr('opportunities'),
          const Color(0xFFEEEDFE),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                  const OpportunitiesScreen()))),
    ];

    return Column(
      children: items.map((item) =>
        GestureDetector(
          onTap: item.$4,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: item.$3,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: const Color(0xFFE3EAF2),
                  width: 0.5),
            ),
            child: Row(
              children: [
                Text(item.$1,
                    style: const TextStyle(
                        fontSize: 24)),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(item.$2,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ))),
                const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppColors.textHint),
              ],
            ),
          ),
        ),
      ).toList(),
    );
  }
}

// ── Recent Records ───────────────────────────────────────
class _RecentRecords extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final records = [
      ('Blood Test Report', 'Mar 18', AppColors.blue),
      ('Prescription – Dr. Ravi', 'Mar 12',
          AppColors.teal),
      ('ECG Report', 'Feb 28',
          const Color(0xFFBA7517)),
    ];

    return Column(
      children: records.map((r) =>
        GestureDetector(
          onTap: () {
            final homeState =
                context.findAncestorStateOfType<_HomeScreenState>();
            homeState?.setState(
                () => homeState._tab = 1);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color(0xFFE3EAF2),
                  width: 0.5),
            ),
            child: Row(
              children: [
                Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                      color: r.$3,
                      shape: BoxShape.circle)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(r.$1,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ))),
                Text(r.$2,
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary)),
                const SizedBox(width: 8),
                const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: AppColors.textHint),
              ],
            ),
          ),
        ),
      ).toList(),
    );
  }
}
