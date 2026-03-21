import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../models/record_model.dart';
import '../widgets/records_summary_row.dart';
import '../widgets/record_card.dart';
import '../widgets/prescription_card.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});
  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _query = '';

  final _records = const [
    RecordModel(
      id: '1', title: 'Complete Blood Count',
      doctor: 'Dr. Ravi Kumar', hospital: 'Apollo Hospitals',
      date: 'Mar 18, 2026', type: RecordType.report,
      status: RecordStatus.normal,
      iconBg: Color(0xFFE6F1FB),
      icon: Icons.bloodtype_rounded,
    ),
    RecordModel(
      id: '2', title: 'ECG Report',
      doctor: 'Dr. Ravi Kumar', hospital: 'Apollo Hospitals',
      date: 'Feb 28, 2026', type: RecordType.report,
      status: RecordStatus.review,
      iconBg: Color(0xFFFAEEDA),
      icon: Icons.monitor_heart_rounded,
    ),
    RecordModel(
      id: '3', title: 'Blood Sugar (HbA1c)',
      doctor: 'Dr. Sneha Patel', hospital: 'Yashoda Hospital',
      date: 'Feb 14, 2026', type: RecordType.report,
      status: RecordStatus.borderline,
      iconBg: Color(0xFFEEEDFE),
      icon: Icons.science_rounded,
    ),
    RecordModel(
      id: '4', title: 'Chest X-Ray',
      doctor: 'Dr. Aruna Mehta', hospital: 'KIMS Hospital',
      date: 'Jan 20, 2026', type: RecordType.scan,
      status: RecordStatus.normal,
      iconBg: Color(0xFFEAF3DE),
      icon: Icons.medical_information_rounded,
    ),
  ];

  final _prescriptions = const [
    PrescriptionModel(
      id: '1', doctorName: 'Dr. Ravi Kumar',
      doctorInitials: 'RK', specialty: 'Cardiologist',
      hospital: 'Apollo Hospitals', date: 'Mar 12, 2026',
      isActive: true,
      medicines: [
        MedicineModel(name: 'Amlodipine 5mg',
            dosage: '1-0-0', duration: '30 days'),
        MedicineModel(name: 'Atorvastatin 10mg',
            dosage: '0-0-1', duration: '30 days'),
        MedicineModel(name: 'Aspirin 75mg',
            dosage: '1-0-0', duration: '30 days'),
      ],
    ),
    PrescriptionModel(
      id: '2', doctorName: 'Dr. Sneha Patel',
      doctorInitials: 'SP', specialty: 'Dermatologist',
      hospital: 'Yashoda Hospital', date: 'Feb 05, 2026',
      isActive: false,
      medicines: [
        MedicineModel(name: 'Betamethasone Cream',
            dosage: 'Apply twice', duration: '14 days'),
        MedicineModel(name: 'Cetirizine 10mg',
            dosage: '0-0-1', duration: '10 days'),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<RecordModel> get _filteredRecords => _records.where((r) =>
    r.title.toLowerCase().contains(_query.toLowerCase()) ||
    r.doctor.toLowerCase().contains(_query.toLowerCase())
  ).toList();

  List<RecordModel> get _reports =>
      _filteredRecords.where((r) => r.type == RecordType.report).toList();

  List<RecordModel> get _scans =>
      _filteredRecords.where((r) => r.type == RecordType.scan).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _TopBar(
            controller: _searchController,
            onChanged: (v) => setState(() => _query = v),
            tabController: _tabController,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _AllTab(records: _filteredRecords,
                    prescriptions: _prescriptions),
                _RecordsTab(records: _reports, label: 'Reports'),
                _PrescriptionsTab(prescriptions: _prescriptions),
                _RecordsTab(records: _scans, label: 'Scans'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Top Bar ──────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final TabController tabController;
  const _TopBar({required this.controller,
      required this.onChanged, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navyDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16, right: 16, bottom: 0,
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
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Medical Records',
                  style: TextStyle(color: Colors.white,
                      fontSize: 18, fontWeight: FontWeight.w700)),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.upload_rounded,
                          color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('Upload',
                        style: TextStyle(color: Colors.white,
                            fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.09),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.search,
                    color: AppColors.textHint, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Search records, prescriptions…',
                      hintStyle: TextStyle(
                          color: AppColors.textHint, fontSize: 13),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TabBar(
            controller: tabController,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: AppColors.blue,
            unselectedLabelColor: Colors.white54,
            labelStyle: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700),
            padding: const EdgeInsets.all(4),
            overlayColor:
                MaterialStateProperty.all(Colors.transparent),
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Reports'),
              Tab(text: 'Rx'),
              Tab(text: 'Scans'),
            ],
          ),
        ],
      ),
    );
  }
}

// ── All Tab ──────────────────────────────────────────────
class _AllTab extends StatelessWidget {
  final List<RecordModel> records;
  final List<PrescriptionModel> prescriptions;
  const _AllTab({required this.records, required this.prescriptions});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(child: RecordsSummaryRow(
            total: records.length + prescriptions.length,
            prescriptions: prescriptions.length,
            scans: records.where(
                (r) => r.type == RecordType.scan).length,
          )),
          const SizedBox(height: 16),
          const Text('Recent Reports',
            style: TextStyle(fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          ...records.asMap().entries.map((e) => FadeInUp(
            delay: Duration(milliseconds: e.key * 80),
            child: RecordCard(record: e.value),
          )),
          const SizedBox(height: 16),
          const Text('Prescriptions',
            style: TextStyle(fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          ...prescriptions.asMap().entries.map((e) => FadeInUp(
            delay: Duration(milliseconds: e.key * 80),
            child: PrescriptionCard(prescription: e.value),
          )),
        ],
      ),
    );
  }
}

// ── Records Tab ──────────────────────────────────────────
class _RecordsTab extends StatelessWidget {
  final List<RecordModel> records;
  final String label;
  const _RecordsTab({required this.records, required this.label});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_open_rounded,
                size: 48, color: AppColors.textHint),
            const SizedBox(height: 12),
            Text('No \$label found',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 15)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: records.length,
      itemBuilder: (_, i) => FadeInUp(
        delay: Duration(milliseconds: i * 80),
        child: RecordCard(record: records[i]),
      ),
    );
  }
}

// ── Prescriptions Tab ────────────────────────────────────
class _PrescriptionsTab extends StatelessWidget {
  final List<PrescriptionModel> prescriptions;
  const _PrescriptionsTab({required this.prescriptions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: prescriptions.length,
      itemBuilder: (_, i) => FadeInUp(
        delay: Duration(milliseconds: i * 80),
        child: PrescriptionCard(prescription: prescriptions[i]),
      ),
    );
  }
}
