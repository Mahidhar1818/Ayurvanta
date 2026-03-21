import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/sos_button.dart';
import '../widgets/quick_access_grid.dart';
import '../widgets/upcoming_appointment_card.dart';
import '../widgets/health_summary_grid.dart';
import '../widgets/recent_records_list.dart';
import '../../records/screens/records_screen.dart';
import '../../chat/screens/ai_chat_screen.dart';
import '../../pharmacy/screens/pharmacy_screen.dart';
import '../../profile/screens/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _TopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(child: const SosButton()),
                  const SizedBox(height: 16),
                  FadeInUp(delay: const Duration(milliseconds: 100),
                      child: const _SectionLabel('Quick Access')),
                  const SizedBox(height: 10),
                  FadeInUp(delay: const Duration(milliseconds: 150),
                      child: const QuickAccessGrid()),
                  const SizedBox(height: 16),
                  FadeInUp(delay: const Duration(milliseconds: 200),
                      child: const _SectionLabel('Upcoming Appointment')),
                  const SizedBox(height: 10),
                  FadeInUp(delay: const Duration(milliseconds: 250),
                      child: const UpcomingAppointmentCard()),
                  const SizedBox(height: 16),
                  FadeInUp(delay: const Duration(milliseconds: 300),
                      child: const _SectionLabel('Health Summary')),
                  const SizedBox(height: 10),
                  FadeInUp(delay: const Duration(milliseconds: 350),
                      child: const HealthSummaryGrid()),
                  const SizedBox(height: 16),
                  FadeInUp(delay: const Duration(milliseconds: 400),
                      child: const _SectionLabel('Recent Records')),
                  const SizedBox(height: 10),
                  FadeInUp(delay: const Duration(milliseconds: 450),
                      child: const RecentRecordsList()),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const _BottomNav(),
    );
  }
}

// ── Top Bar ──────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navyDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 18, right: 18, bottom: 18,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Good morning,',
                        style: TextStyle(color: AppColors.textHint,
                            fontSize: 12)),
                    const SizedBox(height: 2),
                    const Text('Arjun Sharma',
                        style: TextStyle(color: Colors.white,
                            fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.09),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('AYR-4829-3810-7642',
                          style: TextStyle(color: AppColors.textHint,
                              fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.teal,
                    child: const Text('AS',
                        style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.w700, fontSize: 14)),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.notifications_outlined,
                        color: AppColors.textHint, size: 16),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.09),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: AppColors.textHint, size: 18),
                SizedBox(width: 10),
                Text('Search doctors, medicines, tests…',
                    style: TextStyle(color: AppColors.textHint, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Label ────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary));
}

// ── Bottom Nav ───────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  const _BottomNav();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE3EAF2), width: 0.5)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              _NavItem(icon: Icons.home_rounded, label: 'Home', active: true, onTap: () {}),
              _NavItem(
                icon: Icons.folder_outlined,
                label: 'Records',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const RecordsScreen(),
                  ));
                },
              ),
              _NavItem(
                icon: Icons.chat_bubble_outline,
                label: 'Chat',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const AiChatScreen(),
                  ));
                },
              ),
              _NavItem(
                icon: Icons.shopping_bag_outlined,
                label: 'Orders',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const PharmacyScreen(),
                  ));
                },
              ),
              _NavItem(
                icon: Icons.person_outline,
                label: 'Profile',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label, required this.onTap, this.active = false});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22,
                color: active ? AppColors.blue : AppColors.textHint),
            const SizedBox(height: 3),
            Text(label,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
                    color: active ? AppColors.blue : AppColors.textHint)),
            if (active) ...[
              const SizedBox(height: 3),
              Container(width: 4, height: 4,
                  decoration: const BoxDecoration(
                      color: AppColors.blue, shape: BoxShape.circle)),
            ],
          ],
        ),
      ),
    );
  }
}
