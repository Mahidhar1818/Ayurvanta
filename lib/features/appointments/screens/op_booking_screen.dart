import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/translations/tr_extension.dart';
import '../../body_map/screens/body_map_screen.dart';
import '../widgets/hospital_card.dart';
import '../models/hospital_model.dart';
import 'op_form_screen.dart';

class OpBookingScreen extends StatefulWidget {
  const OpBookingScreen({super.key});
  @override
  State<OpBookingScreen> createState() =>
      _OpBookingScreenState();
}

class _OpBookingScreenState
    extends State<OpBookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  String _location  = 'Fetching location...';
  String _selectedSpec = 'All';
  final _searchCtrl = TextEditingController();

  final _specializations = [
    'All', 'Cardiology', 'Neurology', 'Orthopedics',
    'Pediatrics', 'Dermatology', 'ENT', 'Gynecology',
    'Ophthalmology', 'Psychiatry', 'Oncology',
    'Urology', 'General Medicine',
  ];

  final _hospitals = [
    HospitalModel(id:'1', name:'Apollo Hospitals',
        address:'Jubilee Hills, Hyderabad',
        distance:'1.2 km', rating:4.8,
        reviews:1240, specializations:['Cardiology',
        'Neurology','Orthopedics','General Medicine'],
        isOpen:true, consultationFee:800,
        imageEmoji:'🏥',
        waitTime:'~30 min'),
    HospitalModel(id:'2', name:'Yashoda Hospitals',
        address:'Secunderabad, Hyderabad',
        distance:'2.4 km', rating:4.6,
        reviews:987, specializations:['Pediatrics',
        'Gynecology','General Medicine','Oncology'],
        isOpen:true, consultationFee:600,
        imageEmoji:'🏥',
        waitTime:'~45 min'),
    HospitalModel(id:'3', name:'KIMS Hospital',
        address:'Begumpet, Hyderabad',
        distance:'3.1 km', rating:4.7,
        reviews:1560, specializations:['Neurology',
        'Orthopedics','Urology','Cardiology'],
        isOpen:true, consultationFee:700,
        imageEmoji:'🏥',
        waitTime:'~20 min'),
    HospitalModel(id:'4', name:'Rainbow Hospital',
        address:'Banjara Hills, Hyderabad',
        distance:'1.8 km', rating:4.5,
        reviews:780, specializations:['Pediatrics',
        'General Medicine','ENT','Ophthalmology'],
        isOpen:false, consultationFee:500,
        imageEmoji:'🏥',
        waitTime:'Closed'),
    HospitalModel(id:'5', name:'Care Hospitals',
        address:'Nampally, Hyderabad',
        distance:'4.2 km', rating:4.4,
        reviews:620, specializations:['Dermatology',
        'Psychiatry','General Medicine','Cardiology'],
        isOpen:true, consultationFee:550,
        imageEmoji:'🏥',
        waitTime:'~15 min'),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      setState(() =>
          _location =
              '${pos.latitude.toStringAsFixed(3)},'
              ' ${pos.longitude.toStringAsFixed(3)}');
    } catch (_) {
      setState(() =>
          _location = 'Jubilee Hills, Hyderabad');
    }
  }

  List<HospitalModel> get _filtered {
    return _hospitals.where((h) {
      final matchSpec = _selectedSpec == 'All' ||
          h.specializations.contains(_selectedSpec);
      final q = _searchCtrl.text.toLowerCase();
      final matchSearch = q.isEmpty ||
          h.name.toLowerCase().contains(q) ||
          h.address.toLowerCase().contains(q);
      return matchSpec && matchSearch;
    }).toList();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _buildTopBar(context),
          _buildSpecChips(),
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _buildHospitalList(),
                _buildBodyMapTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: AppColors.navyDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 14, right: 14, bottom: 0,
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
                    color: Colors.white
                        .withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(context.tr('book_appt'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      )),
                    Row(
                      children: [
                        const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.teal,
                            size: 12),
                        const SizedBox(width: 4),
                        Text(_location,
                          style: const TextStyle(
                            color: AppColors.textHint,
                            fontSize: 11,
                          )),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _getLocation,
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  child: const Icon(
                      Icons.my_location_rounded,
                      color: AppColors.textHint,
                      size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.09),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.search,
                    color: AppColors.textHint,
                    size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13),
                    decoration: InputDecoration(
                      hintText: context
                          .tr('search_doctor'),
                      hintStyle: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 13),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(
                              vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          TabBar(
            controller: _tabCtrl,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: AppColors.blue,
            unselectedLabelColor: Colors.white54,
            labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700),
            padding: const EdgeInsets.all(4),
            overlayColor: MaterialStateProperty.all(
                Colors.transparent),
            tabs: [
              Tab(text:
                  context.tr('nearby_hospitals')),
              Tab(text: context.tr('tap_body')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecChips() {
    return Container(
      height: 44,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
          vertical: 6, horizontal: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _specializations.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 7),
        itemBuilder: (_, i) {
          final s = _specializations[i];
          final isActive = s == _selectedSpec;
          return GestureDetector(
            onTap: () =>
                setState(() => _selectedSpec = s),
            child: AnimatedContainer(
              duration:
                  const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.blue
                    : const Color(0xFFF4F7FB),
                borderRadius:
                    BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? AppColors.blue
                      : const Color(0xFFE3EAF2),
                  width: 0.5,
                ),
              ),
              child: Text(s,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isActive
                      ? Colors.white
                      : AppColors.navyLight,
                )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHospitalList() {
    if (_filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_hospital_outlined,
                size: 48, color: AppColors.textHint),
            const SizedBox(height: 12),
            Text(
              'No hospitals found',
              style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: _filtered.length + 1,
      itemBuilder: (_, i) {
        if (i == 0) {
          return Padding(
            padding:
                const EdgeInsets.only(bottom: 12),
            child: Text(
              '${_filtered.length} '
              '${context.tr("doctors_available")}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              )),
          );
        }
        return FadeInUp(
          delay: Duration(milliseconds: i * 60),
          child: HospitalCard(
            hospital: _filtered[i - 1],
            onBook: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                OpFormScreen(
                  hospital: _filtered[i - 1]))),
          ),
        );
      },
    );
  }

  Widget _buildBodyMapTab(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Text(
            'Tap the body part that needs attention — '
            'we\'ll show matching specialists',
            style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: BodyMapScreen(gender: 'male'),
        ),
      ],
    );
  }
}
