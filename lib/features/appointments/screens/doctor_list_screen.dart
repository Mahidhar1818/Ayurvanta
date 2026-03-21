import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/specialty_chip_bar.dart';
import '../widgets/doctor_card.dart';
import '../models/doctor_model.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});
  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  String _selectedSpecialty = 'All';
  final _searchController = TextEditingController();

  final _doctors = [
    DoctorModel(
      id: '1', initials: 'RK', name: 'Dr. Ravi Kumar',
      specialty: 'Cardiologist', hospital: 'Apollo Hospitals, Jubilee Hills',
      rating: 4.9, reviews: 312, experience: 18, fee: 800,
      color: AppColors.blue,
      slots: ['9:00 AM', '10:30 AM', '11:00 AM', '2:00 PM', '3:30 PM'],
      bookedSlots: ['9:00 AM', '3:30 PM'],
    ),
    DoctorModel(
      id: '2', initials: 'SP', name: 'Dr. Sneha Patel',
      specialty: 'Dermatologist', hospital: 'Yashoda Hospital, Secunderabad',
      rating: 4.7, reviews: 218, experience: 12, fee: 600,
      color: AppColors.teal,
      slots: ['10:00 AM', '11:30 AM', '1:00 PM', '4:00 PM'],
      bookedSlots: ['1:00 PM'],
    ),
    DoctorModel(
      id: '3', initials: 'AM', name: 'Dr. Aruna Mehta',
      specialty: 'Neurologist', hospital: 'KIMS Hospital, Begumpet',
      rating: 4.8, reviews: 187, experience: 22, fee: 1200,
      color: const Color(0xFF534AB7),
      slots: ['9:30 AM', '12:00 PM', '3:00 PM', '5:00 PM'],
      bookedSlots: ['9:30 AM', '5:00 PM'],
    ),
    DoctorModel(
      id: '4', initials: 'VR', name: 'Dr. Vikram Rao',
      specialty: 'Pediatrician', hospital: 'Rainbow Hospital, Banjara Hills',
      rating: 4.6, reviews: 294, experience: 15, fee: 700,
      color: const Color(0xFFD85A30),
      slots: ['8:30 AM', '10:00 AM', '11:30 AM', '3:00 PM'],
      bookedSlots: ['8:30 AM'],
    ),
  ];

  List<DoctorModel> get _filtered {
    return _doctors.where((d) {
      final matchSpec = _selectedSpecialty == 'All' ||
          d.specialty == _selectedSpecialty;
      final matchSearch = d.name.toLowerCase()
          .contains(_searchController.text.toLowerCase()) ||
          d.specialty.toLowerCase()
              .contains(_searchController.text.toLowerCase());
      return matchSpec && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _TopBar(controller: _searchController,
              onChanged: (_) => setState(() {})),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    child: SpecialtyChipBar(
                      selected: _selectedSpecialty,
                      onSelected: (s) =>
                          setState(() => _selectedSpecialty = s),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeInLeft(
                    child: Text(
                      '\${_filtered.length} Doctors Available',
                      style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._filtered.asMap().entries.map((e) =>
                    FadeInUp(
                      delay: Duration(milliseconds: e.key * 100),
                      child: DoctorCard(doctor: e.value),
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

// ── Top Bar ──────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _TopBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navyDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16, right: 16, bottom: 16,
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
                child: Text('Find a Doctor',
                    style: TextStyle(color: Colors.white,
                        fontSize: 18, fontWeight: FontWeight.w700)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.tune_rounded,
                        color: AppColors.textHint, size: 16),
                    SizedBox(width: 4),
                    Text('Filter', style: TextStyle(
                        color: AppColors.textHint, fontSize: 12,
                        fontWeight: FontWeight.w600)),
                  ],
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
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Search by name, specialty…',
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
        ],
      ),
    );
  }
}
