import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/hospital_models.dart';
import '../../models/op_models.dart';
import '../../widgets/hospital_stat_card.dart';
import 'admin_staff_screen.dart';
import 'admin_hospital_edit_screen.dart';
import 'admin_reports_screen.dart';
import 'admin_payments_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentTab = 0;
  final _hospital = HospitalMockData.hospital;
  final List<StaffMember> _staff =
  List.from(HospitalMockData.staff);
  final List<OPRecord> _ops = List.from(mockOPs);

  int get _todayOps => _ops.length;
  int get _completedToday =>
      _ops.where((o) => o.status == OPStatus.completed).length;
  int get _totalDoctors =>
      _staff.where((s) => s.role == HospitalStaffRole.doctor).length;
  int get _totalReceptionists =>
      _staff.where((s) => s.role == HospitalStaffRole.receptionist).length;
  int get _totalReportists =>
      _staff.where((s) => s.role == HospitalStaffRole.reportist).length;
  double get _todayRevenue =>
      _ops.where((o) => o.paymentStatus == PaymentStatus.paid)
          .fold(0, (sum, o) => sum + o.totalBill);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Column(
        children: [
          _buildTopBar(),
          _buildTabBar(),
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: [
                _buildOverviewTab(),
                AdminStaffScreen(
                  staff: _staff,
                  onStaffChanged: (updated) =>
                      setState(() => _staff
                        ..clear()..addAll(updated)),
                ),
                AdminReportsScreen(ops: _ops,
                    onBillEdit: (opId, newBill) {
                      setState(() {
                        final idx = _ops.indexWhere((o) => o.id == opId);
                        if (idx != -1) _ops[idx].totalBill = newBill;
                      });
                    }),
                AdminPaymentsScreen(ops: _ops),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Top Bar ──────────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      color: const Color(0xFF1A1442),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16, right: 16, bottom: 14,
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF534AB7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.admin_panel_settings_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_hospital.name,
                    style: const TextStyle(color: Colors.white,
                        fontSize: 14, fontWeight: FontWeight.w800),
                    overflow: TextOverflow.ellipsis),
                const Text('Admin Dashboard',
                    style: TextStyle(color: Colors.white38,
                        fontSize: 11)),
              ],
            ),
          ),
          // Edit hospital button
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) =>
                    AdminHospitalEditScreen(hospital: _hospital,
                        onSave: (_) => setState(() {})))),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF534AB7).withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: const Color(0xFF534AB7), width: 0.5),
              ),
              child: const Row(
                children: [
                  Icon(Icons.edit_rounded,
                      color: Color(0xFFCECBF6), size: 13),
                  SizedBox(width: 5),
                  Text('Edit Hospital',
                      style: TextStyle(color: Color(0xFFCECBF6),
                          fontSize: 11, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab Bar ───────────────────────────────────────────────
  Widget _buildTabBar() {
    final tabs = [
      (Icons.dashboard_rounded, 'Overview'),
      (Icons.people_rounded, 'Staff'),
      (Icons.folder_open_rounded, 'Reports'),
      (Icons.payment_rounded, 'Payments'),
    ];
    return Container(
      color: const Color(0xFF1A1442),
      padding: const EdgeInsets.only(
          left: 8, right: 8, bottom: 0),
      child: Row(
        children: tabs.asMap().entries.map((e) {
          final i = e.key;
          final tab = e.value;
          final selected = _currentTab == i;
          return Expanded(
            child: GestureDetector(
              onTap: () =>
                  setState(() => _currentTab = i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selected
                          ? const Color(0xFF9F99F0)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(tab.$1,
                        size: 18,
                        color: selected
                            ? const Color(0xFF9F99F0)
                            : Colors.white38),
                    const SizedBox(height: 3),
                    Text(tab.$2,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? const Color(0xFF9F99F0)
                              : Colors.white38,
                        )),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Overview Tab ─────────────────────────────────────────
  Widget _buildOverviewTab() {
    final stats = HospitalMockData.weekStats;
    final maxOp = stats.map((s) => s.totalOps)
        .reduce((a, b) => a > b ? a : b);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Today stats grid
          FadeInUp(
            child: const Text('Today at a glance',
                style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1442))),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12, mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              FadeInUp(delay: const Duration(milliseconds: 80),
                  child: HospitalStatCard(
                    label: 'Total OPs Today',
                    value: '$_todayOps',
                    subtitle: '+12%',
                    color: const Color(0xFF185FA5),
                    bgColor: const Color(0xFFE6F1FB),
                    icon: Icons.people_alt_rounded,
                  )),
              FadeInUp(delay: const Duration(milliseconds: 140),
                  child: HospitalStatCard(
                    label: 'Completed',
                    value: '$_completedToday',
                    subtitle: 'of $_todayOps',
                    color: const Color(0xFF1D9E75),
                    bgColor: const Color(0xFFE1F5EE),
                    icon: Icons.check_circle_rounded,
                  )),
              FadeInUp(delay: const Duration(milliseconds: 200),
                  child: HospitalStatCard(
                    label: "Today's Revenue",
                    value: '₹${_todayRevenue.toStringAsFixed(0)}',
                    subtitle: 'Collected',
                    color: const Color(0xFF534AB7),
                    bgColor: const Color(0xFFEEEDFE),
                    icon: Icons.currency_rupee_rounded,
                  )),
              FadeInUp(delay: const Duration(milliseconds: 260),
                  child: HospitalStatCard(
                    label: 'Pending Payments',
                    value: '${_ops.where((o) => o.paymentStatus == PaymentStatus.pending).length}',
                    subtitle: 'OPs',
                    color: const Color(0xFFBA7517),
                    bgColor: const Color(0xFFFAEEDA),
                    icon: Icons.pending_actions_rounded,
                  )),
            ],
          ),

          const SizedBox(height: 24),

          // Monthly stats
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: const Color(0xFFE3EAF2), width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('This Week — OPs',
                          style: TextStyle(fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1442))),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEDFE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('This Month: 1,240',
                            style: TextStyle(fontSize: 10,
                                color: Color(0xFF534AB7),
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Mini bar chart
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: stats.map((s) {
                      final h = (s.totalOps / maxOp) * 80;
                      return Expanded(
                        child: Column(
                          children: [
                            Text('${s.totalOps}',
                                style: const TextStyle(
                                    fontSize: 9,
                                    color: Color(0xFF534AB7),
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Container(
                              height: h,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7F77DD),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(s.date,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF888780))),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Staff summary
          FadeInUp(
            delay: const Duration(milliseconds: 380),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Staff Overview',
                    style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1442))),
                GestureDetector(
                  onTap: () => setState(() => _currentTab = 1),
                  child: const Text('Manage →',
                      style: TextStyle(fontSize: 12,
                          color: Color(0xFF534AB7),
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: FadeInUp(
                  delay: const Duration(milliseconds: 420),
                  child: _StaffCategoryCard(
                    role: HospitalStaffRole.doctor,
                    count: _totalDoctors,
                    onTap: () => setState(() => _currentTab = 1),
                  ))),
              const SizedBox(width: 10),
              Expanded(child: FadeInUp(
                  delay: const Duration(milliseconds: 460),
                  child: _StaffCategoryCard(
                    role: HospitalStaffRole.receptionist,
                    count: _totalReceptionists,
                    onTap: () => setState(() => _currentTab = 1),
                  ))),
              const SizedBox(width: 10),
              Expanded(child: FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: _StaffCategoryCard(
                    role: HospitalStaffRole.reportist,
                    count: _totalReportists,
                    onTap: () => setState(() => _currentTab = 1),
                  ))),
            ],
          ),

          const SizedBox(height: 24),

          // Recent OPs
          FadeInUp(
            delay: const Duration(milliseconds: 540),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Today's OPs",
                    style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1442))),
                GestureDetector(
                  onTap: () => setState(() => _currentTab = 2),
                  child: const Text('View All →',
                      style: TextStyle(fontSize: 12,
                          color: Color(0xFF534AB7),
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ..._ops.take(4).toList().asMap().entries.map((e) =>
              FadeInUp(
                  delay: Duration(milliseconds: 560 + e.key * 60),
                  child: _OPSummaryRow(op: e.value))),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ── Staff Category Card ──────────────────────────────────
class _StaffCategoryCard extends StatelessWidget {
  final HospitalStaffRole role;
  final int count;
  final VoidCallback onTap;
  const _StaffCategoryCard({
    required this.role, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: role.bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: role.color.withOpacity(0.2), width: 1),
        ),
        child: Column(
          children: [
            Text(role.emoji,
                style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text('$count',
                style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w800, color: role.color)),
            Text(role.label,
                style: TextStyle(fontSize: 10,
                    color: role.color.withOpacity(0.7),
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ── OP Summary Row ────────────────────────────────────────
class _OPSummaryRow extends StatelessWidget {
  final OPRecord op;
  const _OPSummaryRow({required this.op});

  Color get _statusColor {
    switch (op.status) {
      case OPStatus.completed: return const Color(0xFF1D9E75);
      case OPStatus.withDoctor: return const Color(0xFF185FA5);
      case OPStatus.inLab: return const Color(0xFF854F0B);
      case OPStatus.billing: return const Color(0xFF534AB7);
      case OPStatus.waiting: return const Color(0xFF888780);
      case OPStatus.cancelled: return const Color(0xFFA32D2D);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(op.tokenNo.split('-').last,
                  style: TextStyle(fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: _statusColor)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(op.patientName,
                    style: const TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1442))),
                Text('${op.timeSlot} · ${op.assignedDoctorName ?? 'Unassigned'}',
                    style: const TextStyle(fontSize: 11,
                        color: Color(0xFF888780))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(op.status.label,
                    style: TextStyle(fontSize: 10,
                        color: _statusColor,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 4),
              Text('₹${op.totalBill.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1442))),
            ],
          ),
        ],
      ),
    );
  }
}