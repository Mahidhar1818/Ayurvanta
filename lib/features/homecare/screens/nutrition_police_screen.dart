import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';

// ═══════════════════════════════════════════════════════════
// NUTRITION & POLICE SERVICES SCREEN
// ═══════════════════════════════════════════════════════════

class NutritionPoliceScreen extends StatefulWidget {
  const NutritionPoliceScreen({super.key});

  @override
  State<NutritionPoliceScreen> createState() => _NutritionPoliceScreenState();
}

class _NutritionPoliceScreenState extends State<NutritionPoliceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Police Services State
  String _currentState = 'Loading Location...';
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _detectLocation();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _detectLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _currentState = 'Location Denied - Showing National Help';
            _isLoadingLocation = false;
          });
          return;
        }
      }

      // Mock getting the state based on location (in a real app we'd reverse geocode)
      // Since we don't have a geocoding package here, we'll just mock it after a delay
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        setState(() {
          _currentState = 'Telangana'; // Example detected state
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentState = 'Location Error - Showing National Help';
          _isLoadingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildNutritionTab(),
                  _buildPoliceTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7FB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 18, color: AppColors.navyDark),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Home Checkup',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary)),
                Text('Nutrition & Safety',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.home_work_outlined,
                color: AppColors.teal, size: 22),
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
        indicatorColor: AppColors.teal,
        indicatorWeight: 3,
        labelColor: AppColors.teal,
        unselectedLabelColor: AppColors.textHint,
        labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        tabs: const [
          Tab(text: 'Nutrition (ICMR)'),
          Tab(text: 'Police Services'),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // NUTRITION TAB
  // ═══════════════════════════════════════════════════════════

  Widget _buildNutritionTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        FadeInDown(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B6D11), AppColors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: AppColors.teal.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8))
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('ICMR 2024 Guidelines',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                      ),
                      const SizedBox(height: 12),
                      const Text('Healthy Indian\nDiet Plate',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.2)),
                      const SizedBox(height: 8),
                      Text('Proper nutrition to prevent NCDs',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8))),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🥗', style: TextStyle(fontSize: 40)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text('The Ideal Plate Split',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        FadeInUp(
          delay: const Duration(milliseconds: 100),
          child: _buildNutritionCard(
            'Vegetables & Fruits',
            '50% of your plate',
            'Colorful veggies, seasonal fruits. Provides essential vitamins, minerals, and dietary fibers.',
            '🥦',
            const Color(0xFFEAF3DE),
            const Color(0xFF3B6D11),
          ),
        ),
        FadeInUp(
          delay: const Duration(milliseconds: 200),
          child: _buildNutritionCard(
            'Cereals & Millets',
            '25% of your plate',
            'Wholegrains like brown rice, wheat, and millets (jowar, bajra) instead of refined grains.',
            '🌾',
            const Color(0xFFFFF4E5),
            const Color(0xFFD67D00),
          ),
        ),
        FadeInUp(
          delay: const Duration(milliseconds: 300),
          child: _buildNutritionCard(
            'Proteins (Pulses/Flesh Foods)',
            '25% of your plate',
            'Lentils, beans, eggs, fish, and lean meat. Essential for muscle and immunity.',
            '🥚',
            const Color(0xFFEBF4FF),
            AppColors.blue,
          ),
        ),
        const SizedBox(height: 24),
        const Text('Dietary Restrictions (ICMR)',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        FadeInUp(
          delay: const Duration(milliseconds: 400),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFCEBEB)),
            ),
            child: Column(
              children: [
                _buildRestriction('🧂 Salt', 'Max 5g (1 tsp) per day'),
                const Divider(height: 20, color: Color(0xFFF0F4F8)),
                _buildRestriction('🍬 Sugar', 'Max 25g (5 tsp) per day'),
                const Divider(height: 20, color: Color(0xFFF0F4F8)),
                _buildRestriction('🛢️ Oils & Fats', 'Change oil types. Avoid trans fats.'),
                const Divider(height: 20, color: Color(0xFFF0F4F8)),
                _buildRestriction('🥤 Packaged Food', 'Read labels. Avoid ultra-processed foods.'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildNutritionCard(String title, String subtitle, String desc,
      String emoji, Color bgColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
        boxShadow: const [
          BoxShadow(
              color: Color(0x05000000), blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: textColor)),
                const SizedBox(height: 6),
                Text(desc,
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestriction(String icon, String text) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // POLICE SERVICES TAB
  // ═══════════════════════════════════════════════════════════

  Widget _buildPoliceTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        // Location Banner
        FadeInDown(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1628),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your Location',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.white70)),
                      const SizedBox(height: 2),
                      _isLoadingLocation
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : Text(_currentState,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() => _isLoadingLocation = true);
                    _detectLocation();
                  },
                  child: const Icon(Icons.refresh_rounded,
                      color: Colors.white70, size: 20),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Emergency Helplines',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        FadeInUp(
          delay: const Duration(milliseconds: 100),
          child: Row(
            children: [
              Expanded(
                child: _buildEmergencyBox('Police (All)', '112', Icons.local_police_rounded, const Color(0xFFE24B4A)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEmergencyBox('Ambulance', '108', Icons.medical_services_rounded, const Color(0xFF3B6D11)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        FadeInUp(
          delay: const Duration(milliseconds: 200),
          child: Row(
            children: [
              Expanded(
                child: _buildEmergencyBox('Women Help', '1091', Icons.pregnant_woman_rounded, const Color(0xFFB12D75)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEmergencyBox('Cyber Crime', '1930', Icons.security_rounded, AppColors.blue),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('Online Services',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        FadeInUp(
          delay: const Duration(milliseconds: 300),
          child: _buildServiceItem(
            'Lodge e-FIR',
            'File complaints for lost items online',
            Icons.edit_document,
            'https://citizen.tspolice.gov.in',
          ),
        ),
        FadeInUp(
          delay: const Duration(milliseconds: 400),
          child: _buildServiceItem(
            'Cyber Crime Portal',
            'Report cyber frauds immediately',
            Icons.computer_rounded,
            'https://cybercrime.gov.in',
          ),
        ),
        FadeInUp(
          delay: const Duration(milliseconds: 500),
          child: _buildServiceItem(
            'Traffic Challan',
            'Check and pay traffic penalties',
            Icons.traffic_rounded,
            'https://echallan.tspolice.gov.in/publicview/',
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildEmergencyBox(String label, String number, IconData icon, Color color) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse('tel:$number');
        if (await canLaunchUrl(url)) await launchUrl(url);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 12),
            Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(number,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(String title, String subtitle, IconData icon, String url) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) await launchUrl(uri);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
          boxShadow: const [
            BoxShadow(
                color: Color(0x05000000), blurRadius: 10, offset: Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.navyDark, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.open_in_new_rounded,
                color: AppColors.textHint, size: 16),
          ],
        ),
      ),
    );
  }
}
