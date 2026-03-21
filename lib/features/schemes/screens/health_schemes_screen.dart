import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../data/schemes_data.dart';
import '../models/health_scheme_model.dart';

class HealthSchemesScreen extends StatefulWidget {
  const HealthSchemesScreen({super.key});

  @override
  State<HealthSchemesScreen> createState() => _HealthSchemesScreenState();
}

class _HealthSchemesScreenState extends State<HealthSchemesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String _detectedState = '';
  String _selectedState = '';
  bool _isLocating = false;
  bool _locationError = false;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  // All unique Indian states from our data
  final List<String> _allStates = [
    'Andhra Pradesh', 'Assam', 'Bihar', 'Chhattisgarh', 'Delhi',
    'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand',
    'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Odisha',
    'Punjab', 'Rajasthan', 'Tamil Nadu', 'Telangana', 'Uttar Pradesh',
    'Uttarakhand', 'West Bengal',
  ];

  // Category filters
  final List<String> _categories = [
    'All', 'Health Insurance', 'Universal Health', 'Primary Healthcare',
    'Maternal Health', 'Critical Illness', 'Govt Employee',
    'Child Health', 'Cancer Care', 'Digital Health',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _detectLocation();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Location detection ─────────────────────────────
  Future<void> _detectLocation() async {
    setState(() { _isLocating = true; _locationError = false; });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setDefaultState();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _setDefaultState();
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _setDefaultState();
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );

      final state = _getStateFromCoordinates(pos.latitude, pos.longitude);
      setState(() {
        _detectedState = state;
        _selectedState = state;
        _isLocating = false;
      });
    } catch (_) {
      _setDefaultState();
    }
  }

  void _setDefaultState() {
    setState(() {
      _isLocating = false;
      _locationError = true;
      _detectedState = 'Telangana';
      _selectedState = 'Telangana';
    });
  }

  // ── Coordinate → State mapping ─────────────────────
  String _getStateFromCoordinates(double lat, double lng) {
    // Bounding box approach for Indian states
    if (lat >= 12.5 && lat <= 19.5 && lng >= 76.5 && lng <= 84.5) {
      if (lat >= 12.5 && lat <= 16.0 && lng >= 76.5 && lng <= 80.5)
        return 'Andhra Pradesh';
      if (lat >= 15.8 && lat <= 19.5 && lng >= 77.0 && lng <= 81.5)
        return 'Telangana';
    }
    if (lat >= 11.5 && lat <= 14.0 && lng >= 74.0 && lng <= 80.5)
      return 'Tamil Nadu';
    if (lat >= 11.5 && lat <= 18.5 && lng >= 74.0 && lng <= 78.5)
      return 'Karnataka';
    if (lat >= 8.0 && lat <= 12.5 && lng >= 74.5 && lng <= 77.5)
      return 'Kerala';
    if (lat >= 15.5 && lat <= 22.5 && lng >= 72.5 && lng <= 80.5)
      return 'Maharashtra';
    if (lat >= 20.0 && lat <= 24.5 && lng >= 68.0 && lng <= 74.5)
      return 'Gujarat';
    if (lat >= 23.0 && lat <= 30.5 && lng >= 69.5 && lng <= 78.5)
      return 'Rajasthan';
    if (lat >= 23.5 && lat <= 30.5 && lng >= 77.0 && lng <= 84.5)
      return 'Madhya Pradesh';
    if (lat >= 19.0 && lat <= 24.5 && lng >= 80.0 && lng <= 84.5)
      return 'Chhattisgarh';
    if (lat >= 17.5 && lat <= 22.5 && lng >= 81.5 && lng <= 87.5)
      return 'Odisha';
    if (lat >= 21.5 && lat <= 27.5 && lng >= 83.5 && lng <= 88.5)
      return 'West Bengal';
    if (lat >= 24.5 && lat <= 27.5 && lng >= 83.5 && lng <= 88.5)
      return 'Jharkhand';
    if (lat >= 24.0 && lat <= 27.5 && lng >= 84.0 && lng <= 88.5)
      return 'Bihar';
    if (lat >= 23.5 && lat <= 31.5 && lng >= 77.0 && lng <= 85.0)
      return 'Uttar Pradesh';
    if (lat >= 27.5 && lat <= 31.5 && lng >= 77.5 && lng <= 81.5)
      return 'Uttarakhand';
    if (lat >= 27.5 && lat <= 31.5 && lng >= 74.5 && lng <= 77.5)
      return 'Himachal Pradesh';
    if (lat >= 30.0 && lat <= 33.5 && lng >= 73.5 && lng <= 76.5)
      return 'Punjab';
    if (lat >= 27.5 && lat <= 30.5 && lng >= 74.5 && lng <= 77.5)
      return 'Haryana';
    if (lat >= 28.0 && lat <= 29.0 && lng >= 76.5 && lng <= 77.5)
      return 'Delhi';
    if (lat >= 25.5 && lat <= 28.5 && lng >= 88.0 && lng <= 92.5)
      return 'Assam';
    if (lat >= 14.5 && lat <= 15.8 && lng >= 73.5 && lng <= 74.5)
      return 'Goa';
    return 'Telangana'; // default fallback
  }

  // ── Get schemes for selected state ─────────────────
  List<HealthScheme> get _stateSchemesList {
    final data = stateSchemes[_selectedState];
    return data?.schemes ?? [];
  }

  List<HealthScheme> get _filteredStateSchemes {
    var list = _stateSchemesList;
    if (_selectedCategory != 'All') {
      list = list.where((s) => s.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      list = list.where((s) =>
          s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.description.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return list;
  }

  List<HealthScheme> get _filteredCentralSchemes {
    var list = centralSchemes.toList();
    if (_selectedCategory != 'All') {
      list = list.where((s) => s.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      list = list.where((s) =>
          s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.description.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return list;
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open $url'),
            backgroundColor: AppColors.navyMid,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _buildTopBar(),
          if (_isLocating) _buildLocatingBanner(),
          if (!_isLocating) _buildLocationCard(),
          _buildSearchBar(),
          _buildCategoryChips(),
          _buildTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildStateSchemesList(),
                _buildCentralSchemesList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Top Bar ─────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      color: AppColors.navyDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16, right: 16, bottom: 14,
      ),
      child: Row(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Govt Health Schemes',
                    style: TextStyle(color: Colors.white,
                        fontSize: 17, fontWeight: FontWeight.w700)),
                Text('India — All States & Central',
                    style: TextStyle(color: AppColors.textHint,
                        fontSize: 11)),
              ],
            ),
          ),
          GestureDetector(
            onTap: _detectLocation,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.teal.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.teal, width: 0.5),
              ),
              child: const Row(
                children: [
                  Icon(Icons.my_location_rounded,
                      color: AppColors.teal, size: 14),
                  SizedBox(width: 4),
                  Text('Detect', style: TextStyle(
                      color: AppColors.teal, fontSize: 11,
                      fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Locating Banner ─────────────────────────────────
  Widget _buildLocatingBanner() {
    return Container(
      color: AppColors.navyMid,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: const Row(
        children: [
          SizedBox(
            width: 14, height: 14,
            child: CircularProgressIndicator(
                color: AppColors.teal, strokeWidth: 2),
          ),
          SizedBox(width: 10),
          Text('Detecting your location…',
              style: TextStyle(color: AppColors.textHint, fontSize: 12)),
        ],
      ),
    );
  }

  // ── Location Card ───────────────────────────────────
  Widget _buildLocationCard() {
    return Container(
      color: AppColors.navyMid,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
        children: [
          Icon(
            _locationError
                ? Icons.location_off_outlined
                : Icons.location_on_rounded,
            color: _locationError ? Colors.orange : AppColors.teal,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _locationError
                      ? 'Location unavailable — showing default state'
                      : 'Detected: $_detectedState',
                  style: TextStyle(
                      color: _locationError
                          ? Colors.orange
                          : AppColors.teal,
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const Text('Tap state to change',
                    style: TextStyle(color: AppColors.textHint,
                        fontSize: 10)),
              ],
            ),
          ),
          // State picker dropdown
          GestureDetector(
            onTap: _showStatePicker,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.white.withOpacity(0.15), width: 0.5),
              ),
              child: Row(
                children: [
                  Text(_selectedState,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 12,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Colors.white54, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── State picker bottom sheet ───────────────────────
  void _showStatePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE3EAF2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Select State',
                  style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _allStates.length,
                itemBuilder: (_, i) {
                  final state = _allStates[i];
                  final isSelected = state == _selectedState;
                  return ListTile(
                    title: Text(state,
                        style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? AppColors.blue : AppColors.textPrimary)),
                    trailing: isSelected
                        ? const Icon(Icons.check_rounded,
                            color: AppColors.teal)
                        : null,
                    onTap: () {
                      setState(() => _selectedState = state);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Search Bar ──────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.bgPage,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.textHint, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _searchQuery = v),
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Search schemes…',
                  hintStyle: TextStyle(
                      color: AppColors.textHint, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchCtrl.clear();
                  setState(() => _searchQuery = '');
                },
                child: const Icon(Icons.close_rounded,
                    color: AppColors.textHint, size: 18),
              ),
          ],
        ),
      ),
    );
  }

  // ── Category Chips ──────────────────────────────────
  Widget _buildCategoryChips() {
    return Container(
      color: Colors.white,
      height: 42,
      padding: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = _categories[i];
          final isActive = cat == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? AppColors.blue : AppColors.bgPage,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? AppColors.blue : const Color(0xFFE3EAF2),
                  width: 0.5,
                ),
              ),
              child: Text(cat,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? Colors.white : AppColors.navyLight)),
            ),
          );
        },
      ),
    );
  }

  // ── Tabs ────────────────────────────────────────────
  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.navyDark,
          borderRadius: BorderRadius.circular(0),
          border: const Border(
              bottom: BorderSide(color: AppColors.teal, width: 2)),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: const Color(0xFFE3EAF2),
        labelColor: AppColors.blue,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w700),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on_outlined, size: 14),
                const SizedBox(width: 4),
                Text('$_selectedState (${_filteredStateSchemes.length})'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.public_outlined, size: 14),
                const SizedBox(width: 4),
                Text('Central (${_filteredCentralSchemes.length})'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── State Schemes List ──────────────────────────────
  Widget _buildStateSchemesList() {
    final schemes = _filteredStateSchemes;
    if (schemes.isEmpty) {
      return _buildEmptyState(
          'No state schemes found',
          stateSchemes.containsKey(_selectedState)
              ? 'Try changing the category filter'
              : 'Schemes data for $_selectedState coming soon');
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: schemes.length,
      itemBuilder: (_, i) => FadeInUp(
        delay: Duration(milliseconds: i * 60),
        child: _SchemeCard(
          scheme: schemes[i],
          onTapLink: _launchUrl,
        ),
      ),
    );
  }

  // ── Central Schemes List ────────────────────────────
  Widget _buildCentralSchemesList() {
    final schemes = _filteredCentralSchemes;
    if (schemes.isEmpty) {
      return _buildEmptyState(
          'No central schemes found', 'Try changing the category filter');
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: schemes.length,
      itemBuilder: (_, i) => FadeInUp(
        delay: Duration(milliseconds: i * 60),
        child: _SchemeCard(
          scheme: schemes[i],
          onTapLink: _launchUrl,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.health_and_safety_outlined,
              size: 56, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

// ── Scheme Card Widget ──────────────────────────────────
class _SchemeCard extends StatefulWidget {
  final HealthScheme scheme;
  final void Function(String) onTapLink;

  const _SchemeCard({required this.scheme, required this.onTapLink});

  @override
  State<_SchemeCard> createState() => _SchemeCardState();
}

class _SchemeCardState extends State<_SchemeCard> {
  bool _expanded = false;

  Color get _typeColor => widget.scheme.type == 'central'
      ? AppColors.blue
      : AppColors.teal;

  Color get _typeBg => widget.scheme.type == 'central'
      ? AppColors.blueLight
      : const Color(0xFFEAF3DE);

  Color get _categoryColor {
    switch (widget.scheme.category) {
      case 'Health Insurance': return AppColors.blue;
      case 'Universal Health': return AppColors.teal;
      case 'Maternal Health': return const Color(0xFFD4537E);
      case 'Critical Illness': return const Color(0xFFE24B4A);
      case 'Primary Healthcare': return const Color(0xFF0F6E56);
      case 'Govt Employee': return const Color(0xFF534AB7);
      case 'Child Health': return const Color(0xFFD85A30);
      default: return AppColors.navyLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(
                          color: _typeBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          widget.scheme.type == 'central'
                              ? Icons.account_balance_rounded
                              : Icons.location_city_rounded,
                          color: _typeColor, size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.scheme.name,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _typeBg,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    widget.scheme.type == 'central'
                                        ? 'Central' : 'State',
                                    style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: _typeColor),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _categoryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(widget.scheme.category,
                                      style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          color: _categoryColor)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textHint, size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Coverage badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3DE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_rounded,
                            color: Color(0xFF3B6D11), size: 13),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(widget.scheme.coverage,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF3B6D11))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded details
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Color(0xFFF0F4F8), height: 1),
                  const SizedBox(height: 12),

                  // Description
                  Text(widget.scheme.description,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.6)),
                  const SizedBox(height: 10),

                  // Eligibility
                  _DetailRow(
                    icon: Icons.people_outline_rounded,
                    label: 'Eligibility',
                    value: widget.scheme.eligibility,
                  ),
                  const SizedBox(height: 10),

                  // Official link button
                  GestureDetector(
                    onTap: () => widget.onTapLink(widget.scheme.officialUrl),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _typeColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.open_in_new_rounded,
                              color: Colors.white, size: 14),
                          const SizedBox(width: 6),
                          const Text('Visit Official Website',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(widget.scheme.officialUrl,
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.textHint)),
                  ),
                ],
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary)),
            const SizedBox(height: 2),
            SizedBox(
              width: MediaQuery.of(
                      context.findRenderObject()?.paintBounds.size !=
                              null
                          ? context
                          : context)
                  .size
                  .width - 80,
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textPrimary,
                      height: 1.4)),
            ),
          ],
        ),
      ],
    );
  }
}
