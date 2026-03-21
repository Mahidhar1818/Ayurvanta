import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../models/doctor_rating_model.dart';

class DoctorRankingsScreen extends StatefulWidget {
  const DoctorRankingsScreen({super.key});

  @override
  State<DoctorRankingsScreen> createState() => _DoctorRankingsScreenState();
}

class _DoctorRankingsScreenState extends State<DoctorRankingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedSpecialty = 'All';

  final List<String> _specialties = [
    'All',
    'Cardiologist',
    'Dermatologist',
    'Neurologist',
    'Pediatrician',
    'Orthopedic',
    'Gynecologist',
    'General Medicine',
    'Ophthalmologist',
    'ENT Specialist',
    'Psychiatrist',
  ];

  // Mock doctors data with ratings
  final List<Doctor> _doctors = [
    Doctor(
      id: '1',
      name: 'Dr. Ravi Kumar',
      specialty: 'Cardiologist',
      hospital: 'Apollo Hospitals',
      imageInitials: 'RK',
      color: const Color(0xFF185FA5),
      averageRating: 4.8,
      totalReviews: 312,
      reviews: [],
    ),
    Doctor(
      id: '2',
      name: 'Dr. Sneha Patel',
      specialty: 'Dermatologist',
      hospital: 'Yashoda Hospital',
      imageInitials: 'SP',
      color: const Color(0xFF1D9E75),
      averageRating: 4.7,
      totalReviews: 218,
      reviews: [],
    ),
    Doctor(
      id: '3',
      name: 'Dr. Aruna Mehta',
      specialty: 'Neurologist',
      hospital: 'KIMS Hospital',
      imageInitials: 'AM',
      color: const Color(0xFF534AB7),
      averageRating: 4.9,
      totalReviews: 187,
      reviews: [],
    ),
    Doctor(
      id: '4',
      name: 'Dr. Vikram Rao',
      specialty: 'Pediatrician',
      hospital: 'Rainbow Hospital',
      imageInitials: 'VR',
      color: const Color(0xFFD85A30),
      averageRating: 4.6,
      totalReviews: 294,
      reviews: [],
    ),
    Doctor(
      id: '5',
      name: 'Dr. Priya Sharma',
      specialty: 'Gynecologist',
      hospital: 'Fernandez Hospital',
      imageInitials: 'PS',
      color: const Color(0xFFE8243A),
      averageRating: 4.9,
      totalReviews: 456,
      reviews: [],
    ),
    Doctor(
      id: '6',
      name: 'Dr. Suresh Kumar',
      specialty: 'Orthopedic',
      hospital: 'Sunshine Hospitals',
      imageInitials: 'SK',
      color: const Color(0xFF0F6E56),
      averageRating: 4.5,
      totalReviews: 178,
      reviews: [],
    ),
    Doctor(
      id: '7',
      name: 'Dr. Meena Devi',
      specialty: 'General Medicine',
      hospital: 'Care Hospitals',
      imageInitials: 'MD',
      color: const Color(0xFFBA7517),
      averageRating: 4.7,
      totalReviews: 203,
      reviews: [],
    ),
    Doctor(
      id: '8',
      name: 'Dr. Anil Reddy',
      specialty: 'Ophthalmologist',
      hospital: 'LV Prasad Eye Institute',
      imageInitials: 'AR',
      color: const Color(0xFF3B6D11),
      averageRating: 4.8,
      totalReviews: 156,
      reviews: [],
    ),
  ];

  List<Doctor> get _filteredDoctors {
    if (_selectedSpecialty == 'All') {
      return _doctors
        ..sort((a, b) => b.averageRating.compareTo(a.averageRating));
    }
    return _doctors.where((d) => d.specialty == _selectedSpecialty).toList()
      ..sort((a, b) => b.averageRating.compareTo(a.averageRating));
  }

  Map<String, DoctorRanking> get _rankingsBySpecialty {
    final map = <String, DoctorRanking>{};
    for (final specialty in _specialties.where((s) => s != 'All')) {
      final doctorsInSpecialty =
          _doctors.where((d) => d.specialty == specialty).toList();
      if (doctorsInSpecialty.isNotEmpty) {
        final avgRating = doctorsInSpecialty
                .map((d) => d.averageRating)
                .reduce((a, b) => a + b) /
            doctorsInSpecialty.length;
        map[specialty] = DoctorRanking(
          specialty: specialty,
          doctors: doctorsInSpecialty
            ..sort((a, b) => b.averageRating.compareTo(a.averageRating)),
          totalDoctors: doctorsInSpecialty.length,
          averageSpecialtyRating: avgRating,
        );
      }
    }
    return map;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _buildTopBar(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRankingsTab(),
                _buildLeaderboardTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: AppColors.navyDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        bottom: 14,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Doctor Rankings',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                Text('Based on patient feedback',
                    style: TextStyle(color: AppColors.textHint, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.navyDark,
          borderRadius: BorderRadius.circular(0),
          border: const Border(
            bottom: BorderSide(color: AppColors.teal, width: 2),
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: const Color(0xFFE3EAF2),
        labelColor: AppColors.blue,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        tabs: const [
          Tab(text: 'Specialty Rankings'),
          Tab(text: 'Top Doctors'),
        ],
      ),
    );
  }

  Widget _buildRankingsTab() {
    final rankings = _rankingsBySpecialty;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rankings.length,
      itemBuilder: (_, i) {
        final entry = rankings.entries.elementAt(i);
        final ranking = entry.value;
        return FadeInUp(
          delay: Duration(milliseconds: i * 80),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
            ),
            child: ExpansionTile(
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _getSpecialtyColor(ranking.specialty),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(_getSpecialtyIcon(ranking.specialty),
                      style: const TextStyle(fontSize: 20)),
                ),
              ),
              title: Text(ranking.specialty,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              subtitle: Row(
                children: [
                  const Icon(Icons.star, size: 12, color: Color(0xFFBA7517)),
                  const SizedBox(width: 4),
                  Text(ranking.averageSpecialtyRating.toStringAsFixed(1),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 8),
                  Text('${ranking.totalDoctors} doctors',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
              children: [
                ...ranking.doctors.map((doctor) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: _DoctorRankRow(
                          doctor: doctor,
                          rank: ranking.doctors.indexOf(doctor) + 1),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeaderboardTab() {
    return Column(
      children: [
        // Specialty filter chips
        Container(
          color: Colors.white,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _specialties.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final spec = _specialties[i];
              final isSelected = spec == _selectedSpecialty;
              return GestureDetector(
                onTap: () => setState(() => _selectedSpecialty = spec),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.blue : const Color(0xFFF4F7FB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          isSelected ? AppColors.blue : const Color(0xFFE3EAF2),
                      width: 0.5,
                    ),
                  ),
                  child: Text(spec,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.navyLight,
                      )),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredDoctors.length,
            itemBuilder: (_, i) => FadeInUp(
              delay: Duration(milliseconds: i * 60),
              child: _DoctorLeaderboardCard(
                doctor: _filteredDoctors[i],
                rank: i + 1,
                onTap: () => _showDoctorDetails(_filteredDoctors[i]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDoctorDetails(Doctor doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE3EAF2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: doctor.color,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(doctor.imageInitials,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(doctor.name,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary)),
                  Text(doctor.specialty,
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.textSecondary)),
                  Text(doctor.hospital,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textHint)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star,
                          size: 20, color: Color(0xFFBA7517)),
                      const SizedBox(width: 6),
                      Text(doctor.averageRating.toStringAsFixed(1),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w800)),
                      const SizedBox(width: 8),
                      Text('(${doctor.totalReviews} reviews)',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatItem(label: 'Experience', value: '15+ yrs'),
                        _StatItem(label: 'Consultation', value: '₹800'),
                        _StatItem(label: 'Patients', value: '5,000+'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (doctor.reviews.isNotEmpty) ...[
                    const Divider(),
                    const SizedBox(height: 12),
                    const Text('Recent Reviews',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    ...doctor.reviews.take(3).map((review) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _ReviewTile(review: review),
                        )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSpecialtyColor(String specialty) {
    switch (specialty) {
      case 'Cardiologist':
        return const Color(0xFF185FA5);
      case 'Dermatologist':
        return const Color(0xFF1D9E75);
      case 'Neurologist':
        return const Color(0xFF534AB7);
      case 'Pediatrician':
        return const Color(0xFFD85A30);
      case 'Gynecologist':
        return const Color(0xFFE8243A);
      default:
        return const Color(0xFF0F6E56);
    }
  }

  String _getSpecialtyIcon(String specialty) {
    switch (specialty) {
      case 'Cardiologist':
        return '❤️';
      case 'Dermatologist':
        return '🧴';
      case 'Neurologist':
        return '🧠';
      case 'Pediatrician':
        return '👶';
      case 'Gynecologist':
        return '👩';
      default:
        return '🏥';
    }
  }
}

class _DoctorRankRow extends StatelessWidget {
  final Doctor doctor;
  final int rank;
  const _DoctorRankRow({required this.doctor, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: rank <= 3 ? const Color(0xFFBA7517) : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('#$rank',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: rank <= 3 ? Colors.white : Colors.grey[600],
                  )),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: doctor.color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(doctor.imageInitials,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doctor.name,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700)),
                Text(doctor.hospital,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star, size: 14, color: Color(0xFFBA7517)),
              const SizedBox(width: 4),
              Text(doctor.averageRating.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DoctorLeaderboardCard extends StatelessWidget {
  final Doctor doctor;
  final int rank;
  final VoidCallback onTap;
  const _DoctorLeaderboardCard({
    required this.doctor,
    required this.rank,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getRankColor(rank),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: rank <= 3
                    ? Icon(_getRankIcon(rank), color: Colors.white, size: 20)
                    : Text('#$rank',
                        style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: doctor.color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(doctor.imageInitials,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctor.name,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary)),
                  Text(doctor.specialty,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Color(0xFFBA7517)),
                    const SizedBox(width: 4),
                    Text(doctor.averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800)),
                  ],
                ),
                Text('${doctor.totalReviews} reviews',
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textHint)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return const Color(0xFFFFD700);
    if (rank == 2) return const Color(0xFFC0C0C0);
    if (rank == 3) return const Color(0xFFCD7F32);
    return const Color(0xFFF4F7FB);
  }

  IconData _getRankIcon(int rank) {
    if (rank == 1) return Icons.emoji_events;
    if (rank == 2) return Icons.military_tech;
    return Icons.workspace_premium; // rank 3
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        Text(label,
            style:
                const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final Review review;

  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(review.patientName,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Color(0xFFBA7517)),
                  const SizedBox(width: 4),
                  Text(review.rating.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(review.feedback,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
          if (review.tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: review.tags
                  .map((tag) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(tag, style: const TextStyle(fontSize: 10)),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
