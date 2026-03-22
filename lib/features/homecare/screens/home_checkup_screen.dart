import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/screens/payment_screen.dart';

class CheckupService {
  final String id, title, description, duration, price,
      originalPrice, category, emoji;
  final bool requiresFasting, requiresPrescription;
  final List<String> includes;
  final String reportTime;
  int quantity;

  CheckupService({
    required this.id, required this.title,
    required this.description, required this.duration,
    required this.price, required this.originalPrice,
    required this.category, required this.emoji,
    required this.includes, required this.reportTime,
    this.requiresFasting = false,
    this.requiresPrescription = false,
    this.quantity = 0,
  });

  int get discount =>
      (((int.parse(originalPrice) - int.parse(price)) /
              int.parse(originalPrice)) *
          100)
          .round();
}

class HealthDevice {
  final String id, name, brand, description, emoji,
      category, price, originalPrice;
  final double rating;
  final int reviews;
  final List<String> features;
  final bool isBestseller, isCertified;
  int quantity;

  HealthDevice({
    required this.id, required this.name, required this.brand,
    required this.description, required this.emoji,
    required this.category, required this.price,
    required this.originalPrice, required this.rating,
    required this.reviews, required this.features,
    this.isBestseller = false, this.isCertified = false,
    this.quantity = 0,
  });

  int get discount =>
      (((int.parse(originalPrice) - int.parse(price)) /
              int.parse(originalPrice)) *
          100)
          .round();
}

final List<CheckupService> allCheckups = [
  CheckupService(
    id: 'c01', emoji: '🩸', category: 'Blood Tests',
    title: 'Blood Glucose (Fasting + PP)',
    description: 'Fasting and post-meal blood sugar levels. Essential for diabetes monitoring and early detection.',
    duration: '30 min', price: '149', originalPrice: '299',
    reportTime: 'Same day, 4 hrs', requiresFasting: true,
    includes: ['Fasting glucose', 'Post-prandial glucose', 'HbA1c (if opted)', 'Report via app'],
  ),
  CheckupService(
    id: 'c02', emoji: '❤️', category: 'Vitals',
    title: 'Blood Pressure Monitoring',
    description: 'Certified technician visits with calibrated BP monitor. Takes 3 readings at 5-min intervals for accuracy.',
    duration: '20 min', price: '99', originalPrice: '199',
    reportTime: 'Immediate digital report',
    includes: ['3 BP readings', 'Pulse rate', 'Body weight', 'Digital report with trend'],
  ),
  CheckupService(
    id: 'c03', emoji: '💉', category: 'Blood Tests',
    title: 'Complete Blood Count (CBC)',
    description: 'Comprehensive blood test checking RBC, WBC, platelets, haemoglobin. Detects infections, anaemia, and more.',
    duration: '20 min', price: '199', originalPrice: '450',
    reportTime: '4–6 hours',
    includes: ['Haemoglobin', 'WBC differential', 'RBC count', 'Platelet count', 'PCV/Hematocrit'],
  ),
  CheckupService(
    id: 'c04', emoji: '🧪', category: 'Blood Tests',
    title: 'Thyroid Profile (T3, T4, TSH)',
    description: 'Full thyroid function test to detect hypothyroidism, hyperthyroidism, and thyroid nodules.',
    duration: '20 min', price: '349', originalPrice: '799',
    reportTime: '12–24 hours',
    includes: ['T3 (Triiodothyronine)', 'T4 (Thyroxine)', 'TSH (Thyroid Stimulating Hormone)', 'Free T3, Free T4'],
  ),
  CheckupService(
    id: 'c05', emoji: '🫀', category: 'Cardiac',
    title: 'ECG at Home',
    description: 'Portable 12-lead ECG by certified cardiac technician. Detects arrhythmia, ischemia and conduction abnormalities.',
    duration: '45 min', price: '499', originalPrice: '1200',
    reportTime: '2 hours (cardiologist reviewed)',
    includes: ['12-lead ECG', 'Heart rate analysis', 'Cardiologist interpretation', 'PDF report'],
  ),
  CheckupService(
    id: 'c06', emoji: '🩺', category: 'Cardiac',
    title: 'Lipid Profile (Cholesterol)',
    description: 'Full cholesterol panel including LDL, HDL, triglycerides. Critical for heart disease risk assessment.',
    duration: '20 min', price: '299', originalPrice: '699',
    reportTime: '4–8 hours', requiresFasting: true,
    includes: ['Total cholesterol', 'LDL (bad) cholesterol', 'HDL (good) cholesterol', 'Triglycerides', 'VLDL', 'LDL:HDL ratio'],
  ),
  CheckupService(
    id: 'c07', emoji: '🫁', category: 'Respiratory',
    title: 'Pulse Oximetry + SpO₂',
    description: 'Oxygen saturation levels with pulse rate monitoring. Important for asthma, COPD, and post-COVID check.',
    duration: '15 min', price: '79', originalPrice: '149',
    reportTime: 'Immediate',
    includes: ['SpO₂ reading', 'Pulse rate', '5-minute continuous monitoring', 'Trend chart'],
  ),
  CheckupService(
    id: 'c08', emoji: '🔬', category: 'Urine & Stool',
    title: 'Urine Routine Analysis',
    description: 'Complete urine examination for kidney health, infection, diabetes markers, and protein levels.',
    duration: '15 min (sample)', price: '129', originalPrice: '249',
    reportTime: '4 hours',
    includes: ['Physical examination', 'Chemical analysis', 'Microscopic exam', 'Glucose', 'Protein', 'Ketones'],
  ),
  CheckupService(
    id: 'c09', emoji: '🩻', category: 'Bone & Joint',
    title: 'Vitamin D & B12 Test',
    description: 'Most common deficiencies in Indians. Detects deficiency causing fatigue, bone pain, nerve problems.',
    duration: '20 min', price: '549', originalPrice: '1299',
    reportTime: '24 hours',
    includes: ['25-OH Vitamin D', 'Vitamin B12', 'Deficiency report', 'Doctor consultation note'],
  ),
  CheckupService(
    id: 'c10', emoji: '🫘', category: 'Kidney & Liver',
    title: 'Kidney Function Test (KFT)',
    description: 'Tests creatinine, urea, uric acid to assess kidney health. Recommended for diabetics and hypertensives.',
    duration: '20 min', price: '399', originalPrice: '899',
    reportTime: '6–8 hours',
    includes: ['Serum creatinine', 'Blood urea', 'Uric acid', 'Sodium', 'Potassium', 'eGFR calculation'],
  ),
  CheckupService(
    id: 'c11', emoji: '🧫', category: 'Kidney & Liver',
    title: 'Liver Function Test (LFT)',
    description: 'Complete liver enzyme panel — ALT, AST, ALP, bilirubin. Screens for liver disease and damage.',
    duration: '20 min', price: '349', originalPrice: '799',
    reportTime: '6–8 hours',
    includes: ['SGPT/ALT', 'SGOT/AST', 'ALP', 'Total bilirubin', 'Direct bilirubin', 'Total protein'],
  ),
  CheckupService(
    id: 'c12', emoji: '👁️', category: 'Specialized',
    title: 'Intraocular Pressure (Glaucoma)',
    description: 'Non-contact tonometry to measure eye pressure at home. Early detection of glaucoma.',
    duration: '20 min', price: '399', originalPrice: '899',
    reportTime: '30 min',
    includes: ['Both eye IOP measurement', 'Visual field brief screening', 'Ophthalmologist report'],
  ),
  CheckupService(
    id: 'c13', emoji: '🤰', category: 'Women\'s Health',
    title: 'Antenatal Package (Home)',
    description: 'Complete pregnancy monitoring at home — BP, weight, urine, blood glucose for expecting mothers.',
    duration: '60 min', price: '799', originalPrice: '1999',
    reportTime: '6 hours',
    includes: ['BP & pulse', 'Weight & BMI', 'Urine routine', 'Blood glucose', 'Haemoglobin', 'Foetal heart rate (Doppler)'],
  ),
  CheckupService(
    id: 'c14', emoji: '👴', category: 'Senior Care',
    title: 'Senior Health Package',
    description: 'Comprehensive 65+ health check at home — heart, kidneys, sugar, thyroid, bones, and nutrition.',
    duration: '90 min', price: '1299', originalPrice: '3499',
    reportTime: '24 hours', requiresFasting: true,
    includes: ['CBC', 'Blood glucose', 'Lipid profile', 'KFT', 'LFT', 'Thyroid', 'Vitamin D & B12', 'BP & ECG'],
  ),
  CheckupService(
    id: 'c15', emoji: '👶', category: 'Pediatric',
    title: 'Child Growth & Nutrition Check',
    description: 'Height, weight, BMI, haemoglobin for children 1–15 years. Detects stunting, anaemia, deficiencies.',
    duration: '30 min', price: '299', originalPrice: '699',
    reportTime: '4 hours',
    includes: ['Height & weight', 'BMI & growth percentile', 'Haemoglobin', 'Vitamin D', 'WHO growth chart comparison'],
  ),
];
final List<HealthDevice> allDevices = [
  HealthDevice(
    id: 'd01', emoji: '🩺', category: 'BP Monitors',
    name: 'Omron HEM-7120 BP Monitor',
    brand: 'Omron', price: '1649', originalPrice: '2299',
    description: 'Upper arm BP monitor with memory for 30 readings. Clinically validated, easy one-button operation. Recommended by cardiologists.',
    rating: 4.5, reviews: 12847,
    isBestseller: true, isCertified: true,
    features: ['Clinically validated', '30-reading memory', 'Irregular heartbeat detection', 'Large LCD display', 'AC adapter + 4 AA batteries', '2-year warranty'],
  ),
  HealthDevice(
    id: 'd02', emoji: '🩺', category: 'BP Monitors',
    name: 'Dr. Trust Fully Automatic BP Monitor',
    brand: 'Dr. Trust', price: '1299', originalPrice: '1999',
    description: 'WHO-recommended classification BP monitor with 60-reading memory and voice broadcast in English and Hindi.',
    rating: 4.3, reviews: 8234,
    isBestseller: false, isCertified: true,
    features: ['Voice broadcast Hindi/English', '60-reading memory', 'WHO colour classification', 'Irregular heartbeat alert', 'USB charging'],
  ),
  HealthDevice(
    id: 'd03', emoji: '🩸', category: 'Glucometers',
    name: 'Accu-Chek Active Glucometer',
    brand: 'Roche', price: '599', originalPrice: '999',
    description: 'No coding glucometer with 350-reading memory and 7/14/30-day average. Results in 5 seconds. Gold standard in India.',
    rating: 4.6, reviews: 23491,
    isBestseller: true, isCertified: true,
    features: ['No coding required', '5-second result', '350 reading memory', '7/14/30 day average', 'Alarm reminders', 'PC connectivity'],
  ),
  HealthDevice(
    id: 'd04', emoji: '🩸', category: 'Glucometers',
    name: 'OneTouch Select Plus Flex',
    brand: 'Johnson & Johnson', price: '699', originalPrice: '1199',
    description: 'Smart glucometer with colour-coded ranges — red, yellow, green results. Connects to OneTouch Reveal app via Bluetooth.',
    rating: 4.4, reviews: 9823,
    isBestseller: false, isCertified: true,
    features: ['Colour-coded results', 'Bluetooth app connectivity', '500 reading memory', 'Before/after meal tracking', 'USB charging case'],
  ),
  HealthDevice(
    id: 'd05', emoji: '🫁', category: 'Pulse Oximeters',
    name: 'Dr. Trust Pulse Oximeter',
    brand: 'Dr. Trust', price: '799', originalPrice: '1499',
    description: 'Medical-grade fingertip pulse oximeter with OLED display and 4-direction rotation. Accurate to ±2% SpO₂.',
    rating: 4.5, reviews: 15672,
    isBestseller: true, isCertified: true,
    features: ['±2% SpO₂ accuracy', 'OLED 6-direction display', 'Perfusion index', 'Low battery alert', 'Auto-off in 8 seconds', 'Wrist cord included'],
  ),
  HealthDevice(
    id: 'd06', emoji: '🫁', category: 'Pulse Oximeters',
    name: 'Contec CMS50D Oximeter',
    brand: 'Contec', price: '549', originalPrice: '999',
    description: 'Budget medical oximeter with PI (Perfusion Index) for blood flow quality. Accurate for all skin tones.',
    rating: 4.2, reviews: 5847,
    isBestseller: false, isCertified: true,
    features: ['Perfusion Index display', 'All skin tones accurate', 'Low power consumption', 'Dual-colour OLED', '2 AAA batteries'],
  ),
  HealthDevice(
    id: 'd07', emoji: '🌡️', category: 'Thermometers',
    name: 'Omron MC-720 Forehead Thermometer',
    brand: 'Omron', price: '1299', originalPrice: '2499',
    description: 'Non-contact infrared forehead thermometer. Measures in 1 second. Can also measure object and room temperature. Ideal for children.',
    rating: 4.4, reviews: 7293,
    isBestseller: false, isCertified: true,
    features: ['1-second reading', 'Non-contact (0–5 cm)', '50 memory readings', 'Fever alert beep', 'Object & room mode', 'Silent mode for sleeping children'],
  ),
  HealthDevice(
    id: 'd08', emoji: '🌡️', category: 'Thermometers',
    name: 'Braun ThermoScan Ear Thermometer',
    brand: 'Braun', price: '2499', originalPrice: '3999',
    description: 'Clinically proven most accurate home thermometer. ExacTemp technology with positioning guidance. Paediatrician recommended.',
    rating: 4.7, reviews: 11234,
    isBestseller: true, isCertified: true,
    features: ['ExacTemp technology', 'Pre-warmed tip', 'Age-adjusted fever guidance', '9-reading memory', 'Positioning guidance light', 'Includes 21 lens filters'],
  ),
  HealthDevice(
    id: 'd09', emoji: '😮💨', category: 'Nebulizers',
    name: 'Omron NE-C28 Compressor Nebulizer',
    brand: 'Omron', price: '1799', originalPrice: '2999',
    description: 'Piston compressor nebulizer for asthma and COPD. Virtual Valve Technology for efficient drug delivery with minimal waste.',
    rating: 4.5, reviews: 9342,
    isBestseller: true, isCertified: true,
    features: ['Virtual Valve Technology', 'MMAD 2.5 μm particles', 'Quiet operation', 'Child & adult mask included', 'Auto-off safety', '3-year warranty'],
  ),
  HealthDevice(
    id: 'd10', emoji: '😮💨', category: 'Nebulizers',
    name: 'PHILIPS InnoSpire Mini Mesh Nebulizer',
    brand: 'Philips', price: '4499', originalPrice: '6999',
    description: 'Ultra-portable mesh nebulizer — no compressor, no noise, runs on USB. 3mL medication in 4 minutes.',
    rating: 4.6, reviews: 4521,
    isBestseller: false, isCertified: true,
    features: ['Mesh technology', 'USB-C rechargeable', 'Silent operation', '360° any-angle use', 'Travel-friendly 90g', '4-min nebulization'],
  ),
  HealthDevice(
    id: 'd11', emoji: '❤️', category: 'ECG Monitors',
    name: 'AliveCor KardiaMobile 6L',
    brand: 'AliveCor', price: '8999', originalPrice: '12999',
    description: 'Clinically validated 6-lead personal ECG. Detects AFib, bradycardia, tachycardia in 30 seconds. FDA cleared.',
    rating: 4.4, reviews: 2847,
    isBestseller: false, isCertified: true,
    features: ['6-lead ECG in 30 sec', 'AFib auto-detection', 'FDA 510(k) cleared', 'Works with iOS & Android', 'Sends to cardiologist', 'No subscription for basic'],
  ),
  HealthDevice(
    id: 'd12', emoji: '❤️', category: 'ECG Monitors',
    name: 'Wellue DuoEK Dual-Channel ECG',
    brand: 'Wellue', price: '5999', originalPrice: '8999',
    description: 'Dual-channel ECG monitor with AI analysis. 24-hour continuous monitoring. Connects to Wellue Health app.',
    rating: 4.3, reviews: 1234,
    isBestseller: false, isCertified: true,
    features: ['Dual channel ECG', 'AI rhythm analysis', '24hr continuous monitoring', 'Bluetooth app', '200 mAh battery', 'Export PDF reports'],
  ),
  HealthDevice(
    id: 'd13', emoji: '⚖️', category: 'Smart Scales',
    name: 'Mi Smart Body Composition Scale 2',
    brand: 'Xiaomi', price: '1299', originalPrice: '1999',
    description: 'Measures 13 body metrics — BMI, fat %, muscle mass, bone density, visceral fat, hydration. Syncs with Mi Fit & Apple Health.',
    rating: 4.4, reviews: 18234,
    isBestseller: true, isCertified: false,
    features: ['13 body metrics', 'BMI & body fat %', 'Visceral fat index', 'Bone density', 'Bluetooth & Wi-Fi', 'Unlimited user profiles'],
  ),
  HealthDevice(
    id: 'd14', emoji: '⚖️', category: 'Smart Scales',
    name: 'Health O Meter Clinical Scale',
    brand: 'Health O Meter', price: '2499', originalPrice: '3999',
    description: 'Clinical-grade digital scale accurate to 100g. Used in hospitals. Large platform with BMI chart. Max 200 kg.',
    rating: 4.6, reviews: 5632,
    isBestseller: false, isCertified: true,
    features: ['100g accuracy', 'Max 200 kg capacity', 'BMI indicator', 'Large non-slip platform', 'Clinical-grade accuracy', 'Auto-off'],
  ),
  HealthDevice(
    id: 'd15', emoji: '📡', category: 'CGM & Advanced',
    name: 'FreeStyle Libre 2 Sensor (14-day)',
    brand: 'Abbott', price: '3499', originalPrice: '3999',
    description: 'Continuous glucose monitor — wear a small sensor on upper arm for 14 days. Scan anytime for glucose trend without finger prick.',
    rating: 4.6, reviews: 6734,
    isBestseller: true, isCertified: true,
    features: ['14-day wear', 'No finger prick needed', 'Real-time glucose trends', '8-hr historical data', 'Alarms for low/high', 'Works with LibreLink app'],
  ),
  HealthDevice(
    id: 'd16', emoji: '⌚', category: 'CGM & Advanced',
    name: 'Samsung Galaxy Watch 6 (Health Edition)',
    brand: 'Samsung', price: '22999', originalPrice: '29999',
    description: 'Advanced health smartwatch — ECG, blood pressure (India cleared), SpO₂, sleep apnea detection, skin temperature, stress.',
    rating: 4.5, reviews: 8921,
    isBestseller: false, isCertified: true,
    features: ['ECG + Blood Pressure', 'SpO₂ monitoring', 'Sleep apnea detection', 'Skin temperature', 'Stress & HRV', 'Samsung Health app'],
  ),
  HealthDevice(
    id: 'd17', emoji: '🦴', category: 'Orthopaedic',
    name: 'TENS + EMS Pain Relief Unit',
    brand: 'HealthSense', price: '1999', originalPrice: '3499',
    description: 'Dual-mode TENS (pain relief) + EMS (muscle strengthening) device with 20 intensity levels and 6 preset modes.',
    rating: 4.2, reviews: 3847,
    isBestseller: false, isCertified: false,
    features: ['TENS + EMS dual mode', '20 intensity levels', '6 preset modes', '4 electrode pads', 'Back, knee, shoulder, neck modes', 'USB charging'],
  ),
  HealthDevice(
    id: 'd18', emoji: '💪', category: 'Orthopaedic',
    name: 'Hand Grip Dynamometer',
    brand: 'Exacta', price: '899', originalPrice: '1499',
    description: 'Medical hand grip strength tester — used by physiotherapists for rehabilitation monitoring and muscle assessment.',
    rating: 4.3, reviews: 1234,
    isBestseller: false, isCertified: false,
    features: ['0–90 kg range', 'Peak hold display', 'Adjustable handle', 'Rehabilitation use', 'Medical grade'],
  ),
];

class HomeCheckupScreen extends StatefulWidget {
  const HomeCheckupScreen({super.key});
  @override
  State<HomeCheckupScreen> createState() => _HomeCheckupScreenState();
}

class _HomeCheckupScreenState extends State<HomeCheckupScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _checkupCat = 'All';
  String _deviceCat = 'All';

  final List<CheckupService> _checkupCart = [];
  final List<HealthDevice> _deviceCart = [];

  static const _checkupCats = [
    'All', 'Vitals', 'Blood Tests', 'Cardiac', 'Respiratory',
    'Kidney & Liver', 'Bone & Joint', 'Urine & Stool',
    'Women\'s Health', 'Senior Care', 'Pediatric', 'Specialized',
  ];

  static const _deviceCats = [
    'All', 'BP Monitors', 'Glucometers', 'Pulse Oximeters',
    'Thermometers', 'Nebulizers', 'ECG Monitors',
    'Smart Scales', 'CGM & Advanced', 'Orthopaedic',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<CheckupService> get _filteredCheckups {
    var l = allCheckups.toList();
    if (_checkupCat != 'All') l = l.where((c) => c.category == _checkupCat).toList();
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      l = l.where((c) => c.title.toLowerCase().contains(q) ||
          c.category.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q)).toList();
    }
    return l;
  }

  List<HealthDevice> get _filteredDevices {
    var l = allDevices.toList();
    if (_deviceCat != 'All') l = l.where((d) => d.category == _deviceCat).toList();
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      l = l.where((d) => d.name.toLowerCase().contains(q) ||
          d.brand.toLowerCase().contains(q) ||
          d.category.toLowerCase().contains(q)).toList();
    }
    return l;
  }

  int get _checkupTotal => _checkupCart.fold(0, (s, c) => s + int.parse(c.price));
  int get _deviceTotal => _deviceCart.fold(0, (s, d) => s + (int.parse(d.price) * d.quantity));
  int get _totalCartCount => _checkupCart.length +
      _deviceCart.fold(0, (s, d) => s + d.quantity);

  void _addCheckup(CheckupService s) {
    HapticFeedback.lightImpact();
    if (_checkupCart.any((c) => c.id == s.id)) {
      _snack('Already in cart');
      return;
    }
    setState(() => _checkupCart.add(s));
  }

  void _addDevice(HealthDevice d) {
    HapticFeedback.lightImpact();
    setState(() {
      final existing = _deviceCart.where((x) => x.id == d.id);
      if (existing.isEmpty) {
        d.quantity = 1;
        _deviceCart.add(d);
      } else {
        existing.first.quantity++;
      }
    });
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.navyMid,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(children: [
        _topBar(),
        _searchRow(),
        _tabs(),
        Expanded(child: TabBarView(controller: _tabController, children: [
          _checkupsTab(),
          _devicesTab(),
        ])),
      ]),
      floatingActionButton: _totalCartCount > 0
          ? FadeInUp(child: GestureDetector(
              onTap: () => _showCart(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.teal,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(
                      color: AppColors.teal.withOpacity(0.4),
                      blurRadius: 16, offset: const Offset(0, 4))],
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.shopping_cart_rounded,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text('$_totalCartCount items  ·  '
                      '₹${_checkupTotal + _deviceTotal}',
                      style: const TextStyle(color: Colors.white,
                          fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 18),
                ]))))
          : null,
    );
  }

  // ── Top Bar ─────────────────────────────────────────
  Widget _topBar() => Container(
    color: AppColors.navyDark,
    padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16, right: 16, bottom: 14),
    child: Row(children: [
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(width: 36, height: 36,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 16))),
      const SizedBox(width: 12),
      const Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Home Checkup & Devices',
            style: TextStyle(color: Colors.white,
                fontSize: 17, fontWeight: FontWeight.w700)),
        Text('Lab tests at home · Medical devices delivered',
            style: TextStyle(color: AppColors.textHint, fontSize: 11)),
      ])),
      if (_totalCartCount > 0)
        GestureDetector(
          onTap: () => _showCart(),
          child: Stack(clipBehavior: Clip.none, children: [
            Container(width: 40, height: 40,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.shopping_cart_outlined,
                    color: Colors.white, size: 20)),
            Positioned(top: -6, right: -6,
                child: Container(width: 20, height: 20,
                    decoration: const BoxDecoration(
                        color: AppColors.emergency,
                        shape: BoxShape.circle),
                    child: Center(child: Text('$_totalCartCount',
                        style: const TextStyle(color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800))))),
          ])),
    ]));

  // ── Search Row ───────────────────────────────────────
  Widget _searchRow() => Container(
    color: AppColors.navyDark,
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: Colors.white.withOpacity(0.15), width: 0.5)),
      child: Row(children: [
        const Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
        const SizedBox(width: 10),
        Expanded(child: TextField(
          controller: _searchCtrl,
          onChanged: (v) => setState(() => _query = v),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: const InputDecoration(
            hintText: 'Search tests, devices, brands…',
            hintStyle: TextStyle(color: AppColors.textHint, fontSize: 13),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14)))),
        if (_query.isNotEmpty)
          GestureDetector(
            onTap: () { _searchCtrl.clear(); setState(() => _query = ''); },
            child: const Icon(Icons.close_rounded,
                color: AppColors.textHint, size: 18)),
      ])));

  // ── Tabs ─────────────────────────────────────────────
  Widget _tabs() => Container(
    color: AppColors.navyDark,
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
    child: Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(4),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(9)),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppColors.teal,
        unselectedLabelColor: Colors.white54,
        labelStyle: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w700),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        tabs: const [
          Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('🩺 '), Text('Book Checkup')])),
          Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('📦 '), Text('Order Devices')])),
        ])));

  // ── Checkups Tab ─────────────────────────────────────
  Widget _checkupsTab() => Column(children: [
    _chipRow(_checkupCats, _checkupCat,
        (v) => setState(() => _checkupCat = v)),
    Expanded(child: ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      itemCount: _filteredCheckups.length,
      itemBuilder: (_, i) => FadeInUp(
        delay: Duration(milliseconds: (i % 8) * 50),
        child: _CheckupCard(
          service: _filteredCheckups[i],
          isBooked: _checkupCart.any(
              (c) => c.id == _filteredCheckups[i].id),
          onBook: () => _addCheckup(_filteredCheckups[i]))))),
  ]);

  // ── Devices Tab ──────────────────────────────────────
  Widget _devicesTab() => Column(children: [
    _chipRow(_deviceCats, _deviceCat,
        (v) => setState(() => _deviceCat = v)),
    Expanded(child: GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 10,
        mainAxisSpacing: 10, childAspectRatio: 0.58),
      itemCount: _filteredDevices.length,
      itemBuilder: (_, i) => FadeInUp(
        delay: Duration(milliseconds: (i % 6) * 50),
        child: _DeviceCard(
          device: _filteredDevices[i],
          cartQty: _deviceCart
              .where((d) => d.id == _filteredDevices[i].id)
              .fold(0, (_, d) => d.quantity),
          onAdd: () => _addDevice(_filteredDevices[i]),
          onRemove: () {
            setState(() {
              final idx = _deviceCart.indexWhere(
                  (d) => d.id == _filteredDevices[i].id);
              if (idx != -1) {
                if (_deviceCart[idx].quantity > 1) {
                  _deviceCart[idx].quantity--;
                } else {
                  _deviceCart.removeAt(idx);
                }
              }
            });
          })))),
  ]);

  Widget _chipRow(List<String> cats, String selected,
      Function(String) onSelect) => Container(
    color: Colors.white,
    height: 46,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: cats.length,
      separatorBuilder: (_, __) => const SizedBox(width: 7),
      itemBuilder: (_, i) {
        final c = cats[i];
        final active = c == selected;
        return GestureDetector(
          onTap: () => onSelect(c),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(
                horizontal: 13, vertical: 4),
            decoration: BoxDecoration(
              color: active ? AppColors.teal : AppColors.bgPage,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: active ? AppColors.teal
                      : const Color(0xFFE3EAF2), width: 0.5)),
            child: Text(c, style: TextStyle(fontSize: 11,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : AppColors.navyLight))));
      }));

  // ── Cart Bottom Sheet ────────────────────────────────
  void _showCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => DraggableScrollableSheet(
          initialChildSize: 0.8, maxChildSize: 0.95, minChildSize: 0.5,
          builder: (_, scroll) => Container(
            decoration: const BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24))),
            child: Column(children: [
              Container(width: 40, height: 4,
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                      color: const Color(0xFFE3EAF2),
                      borderRadius: BorderRadius.circular(2))),
              Padding(padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                  child: Row(children: [
                const Text('My Cart', style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
                const Spacer(),
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.blueLight,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text('$_totalCartCount items',
                        style: const TextStyle(fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blue))),
              ])),
              Expanded(child: ListView(
                controller: scroll,
                padding: const EdgeInsets.all(20),
                children: [
                  // Checkup services in cart
                  if (_checkupCart.isNotEmpty) ...[
                    const Text('🩺 Lab Tests & Checkups',
                        style: TextStyle(fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    ..._checkupCart.map((s) => _cartCheckupTile(s, setS)),
                    const SizedBox(height: 14),
                  ],
                  // Devices in cart
                  if (_deviceCart.isNotEmpty) ...[
                    const Text('📦 Health Devices',
                        style: TextStyle(fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    ..._deviceCart.map((d) => _cartDeviceTile(d, setS)),
                  ],
                  // Delivery info
                  const SizedBox(height: 12),
                  Container(padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: const Color(0xFFEAF3DE),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Row(children: [
                        Icon(Icons.access_time_rounded,
                            color: Color(0xFF3B6D11), size: 14),
                        SizedBox(width: 6),
                        Text('Checkup: Technician arrives in 2 hours',
                            style: TextStyle(fontSize: 11,
                                color: Color(0xFF3B6D11),
                                fontWeight: FontWeight.w600)),
                      ]),
                      SizedBox(height: 4),
                      Row(children: [
                        Icon(Icons.local_shipping_outlined,
                            color: Color(0xFF3B6D11), size: 14),
                        SizedBox(width: 6),
                        Text('Devices: Next-day delivery',
                            style: TextStyle(fontSize: 11,
                                color: Color(0xFF3B6D11),
                                fontWeight: FontWeight.w600)),
                      ]),
                    ])),
                  const SizedBox(height: 30),
                ])),
              // Bill summary
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    border: Border(top: BorderSide(
                        color: Color(0xFFE3EAF2), width: 0.5))),
                child: Column(children: [
                  _billRow('Checkups', '₹$_checkupTotal'),
                  const SizedBox(height: 5),
                  _billRow('Devices', '₹$_deviceTotal'),
                  const SizedBox(height: 5),
                  _billRow('Delivery', '₹49'),
                  const SizedBox(height: 5),
                  _billRow('Discount (5%)',
                      '-₹${((_checkupTotal + _deviceTotal) * 0.05).round()}',
                      isGreen: true),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(color: Color(0xFFE3EAF2))),
                  _billRow('Total Payable',
                      '₹${_checkupTotal + _deviceTotal + 49 - ((_checkupTotal + _deviceTotal) * 0.05).round()}',
                      isBold: true),
                  const SizedBox(height: 16),
                  SizedBox(width: double.infinity, height: 52,
                      child: ElevatedButton(
                        onPressed: () => _checkout(ctx),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.teal,
                            foregroundColor: Colors.white, elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14))),
                        child: Text(
                            'Proceed to Pay  ₹${_checkupTotal + _deviceTotal + 49 - ((_checkupTotal + _deviceTotal) * 0.05).round()}',
                            style: const TextStyle(fontSize: 15,
                                fontWeight: FontWeight.w700)))),
                ])),
            ])))));
  }

  Widget _cartCheckupTile(CheckupService s, StateSetter setS) =>
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.bgPage,
            borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Text(s.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.title, style: const TextStyle(fontSize: 12,
                fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            Text('Report in ${s.reportTime}',
                style: const TextStyle(fontSize: 10,
                    color: AppColors.textSecondary)),
          ])),
          Text('₹${s.price}', style: const TextStyle(fontSize: 14,
              fontWeight: FontWeight.w800, color: AppColors.blue)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setS(() => _checkupCart.remove(s)),
            child: const Icon(Icons.close_rounded,
                color: AppColors.textHint, size: 18)),
        ]));

  Widget _cartDeviceTile(HealthDevice d, StateSetter setS) =>
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.bgPage,
            borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Text(d.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d.name, style: const TextStyle(fontSize: 12,
                fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(d.brand, style: const TextStyle(fontSize: 10,
                color: AppColors.textSecondary)),
          ])),
          Row(children: [
            GestureDetector(
              onTap: () => setS(() {
                if (d.quantity > 1) d.quantity--;
                else _deviceCart.remove(d);
              }),
              child: Container(width: 26, height: 26,
                  decoration: BoxDecoration(color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: const Color(0xFFE3EAF2))),
                  child: const Icon(Icons.remove_rounded,
                      size: 13, color: AppColors.textPrimary))),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('${d.quantity}', style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary))),
            GestureDetector(
              onTap: () => setS(() => d.quantity++),
              child: Container(width: 26, height: 26,
                  decoration: BoxDecoration(color: AppColors.teal,
                      borderRadius: BorderRadius.circular(6)),
                  child: const Icon(Icons.add_rounded,
                      size: 13, color: Colors.white))),
          ]),
          const SizedBox(width: 8),
          Text('₹${int.parse(d.price) * d.quantity}',
              style: const TextStyle(fontSize: 13,
                  fontWeight: FontWeight.w800, color: AppColors.blue)),
        ]));

  Widget _billRow(String l, String v,
      {bool isBold = false, bool isGreen = false}) => Row(children: [
    Text(l, style: TextStyle(fontSize: isBold ? 14 : 12,
        fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
        color: AppColors.textSecondary)),
    const Spacer(),
    Text(v, style: TextStyle(fontSize: isBold ? 16 : 13,
        fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
        color: isGreen ? const Color(0xFF3B6D11)
            : isBold ? AppColors.blue : AppColors.textPrimary)),
  ]);

  void _checkout(BuildContext ctx) async {
    Navigator.pop(ctx);
    // Show payment screen
    _showPayment();
  }

  void _showPayment() {
    final total = _checkupTotal + _deviceTotal + 49 -
        ((_checkupTotal + _deviceTotal) * 0.05).round();
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => PaymentScreen(
        total: total,
        itemCount: _totalCartCount,
        onSuccess: () {
          setState(() {
            _checkupCart.clear();
            _deviceCart.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Row(children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Payment Successful!', style: TextStyle(fontWeight: FontWeight.w600)),
            ]),
            backgroundColor: AppColors.teal,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(20),
          ));
        },
      ),
    ));
  }
}

// ═══════════════════════════════════════════════════════════
// CHECKUP CARD
// ═══════════════════════════════════════════════════════════

class _CheckupCard extends StatefulWidget {
  final CheckupService service;
  final bool isBooked;
  final VoidCallback onBook;
  const _CheckupCard({required this.service, required this.isBooked,
      required this.onBook});
  @override
  State<_CheckupCard> createState() => _CheckupCardState();
}

class _CheckupCardState extends State<_CheckupCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.isBooked
                ? AppColors.teal.withOpacity(0.4)
                : const Color(0xFFE3EAF2),
            width: widget.isBooked ? 1.5 : 0.5)),
      child: Column(children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(width: 50, height: 50,
                    decoration: BoxDecoration(
                        color: AppColors.bgPage,
                        borderRadius: BorderRadius.circular(13)),
                    child: Center(child: Text(s.emoji,
                        style: const TextStyle(fontSize: 24)))),
                const SizedBox(width: 12),
                Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(s.title, style: const TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(s.description, style: const TextStyle(fontSize: 11,
                      color: AppColors.textSecondary, height: 1.4),
                      maxLines: _expanded ? 5 : 2,
                      overflow: TextOverflow.ellipsis),
                ])),
                Icon(_expanded ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textHint, size: 20),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                _tag('⏱ ${s.duration}', AppColors.blue, AppColors.blueLight),
                const SizedBox(width: 6),
                _tag('📋 ${s.reportTime}', AppColors.teal,
                    const Color(0xFFEAF3DE)),
                if (s.requiresFasting) ...[
                  const SizedBox(width: 6),
                  _tag('⚡ Fasting', const Color(0xFF854F0B),
                      const Color(0xFFFAEEDA)),
                ],
              ]),
            ]))),
        // Expanded includes
        if (_expanded)
          Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Divider(color: Color(0xFFF0F4F8), height: 1),
                const SizedBox(height: 10),
                const Text('Includes:', style: TextStyle(fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                ...s.includes.map((inc) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(children: [
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.teal, size: 13),
                      const SizedBox(width: 6),
                      Text(inc, style: const TextStyle(fontSize: 11,
                          color: AppColors.textSecondary)),
                    ]))),
              ])),
        // Footer
        Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(
                  color: Color(0xFFF0F4F8), width: 0.5))),
          child: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Row(children: [
                Text('₹${s.price}', style: const TextStyle(fontSize: 18,
                    fontWeight: FontWeight.w800, color: AppColors.blue)),
                const SizedBox(width: 6),
                Text('₹${s.originalPrice}',
                    style: const TextStyle(fontSize: 11,
                        color: AppColors.textHint,
                        decoration: TextDecoration.lineThrough)),
              ]),
              Text('${s.discount}% off · Home visit',
                  style: const TextStyle(fontSize: 10,
                      color: Color(0xFF3B6D11),
                      fontWeight: FontWeight.w600)),
            ]),
            const Spacer(),
            GestureDetector(
              onTap: widget.isBooked ? null : widget.onBook,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 9),
                decoration: BoxDecoration(
                    color: widget.isBooked
                        ? const Color(0xFFEAF3DE)
                        : AppColors.teal,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(widget.isBooked ? '✓ Booked' : 'Book Now',
                    style: TextStyle(fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: widget.isBooked
                            ? const Color(0xFF3B6D11)
                            : Colors.white)))),
          ])),
      ]));
  }

  Widget _tag(String t, Color tc, Color bg) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg,
          borderRadius: BorderRadius.circular(6)),
      child: Text(t, style: TextStyle(fontSize: 10,
          fontWeight: FontWeight.w600, color: tc)));
}

// ═══════════════════════════════════════════════════════════
// DEVICE CARD
// ═══════════════════════════════════════════════════════════

class _DeviceCard extends StatelessWidget {
  final HealthDevice device;
  final int cartQty;
  final VoidCallback onAdd, onRemove;
  const _DeviceCard({required this.device, required this.cartQty,
      required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final d = device;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: cartQty > 0
                ? AppColors.teal.withOpacity(0.4)
                : const Color(0xFFE3EAF2),
            width: cartQty > 0 ? 1.5 : 0.5)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        // Emoji + badges
        Stack(children: [
          Container(width: double.infinity, height: 70,
              decoration: BoxDecoration(color: AppColors.bgPage,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text(d.emoji,
                  style: const TextStyle(fontSize: 34)))),
          if (d.isBestseller)
            Positioned(top: 5, left: 5,
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        color: const Color(0xFFBA7517),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Text('Bestseller',
                        style: TextStyle(fontSize: 8,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)))),
          if (d.isCertified)
            Positioned(top: 5, right: 5,
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                        color: AppColors.blueLight,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Text('✓ Certified',
                        style: TextStyle(fontSize: 7,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blue)))),
        ]),
        const SizedBox(height: 8),
        Text(d.name, style: const TextStyle(fontSize: 11,
            fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            maxLines: 2, overflow: TextOverflow.ellipsis),
        Text(d.brand, style: const TextStyle(fontSize: 10,
            color: AppColors.textHint)),
        const SizedBox(height: 4),
        // Rating
        Row(children: [
          ...List.generate(5, (i) => Icon(
              i < d.rating.floor()
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              size: 11,
              color: const Color(0xFFBA7517))),
          const SizedBox(width: 3),
          Text('(${d.reviews})', style: const TextStyle(
              fontSize: 9, color: AppColors.textHint)),
        ]),
        const Spacer(),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text('₹${d.price}', style: const TextStyle(fontSize: 15,
                fontWeight: FontWeight.w800, color: AppColors.blue)),
            Text('${d.discount}% off', style: const TextStyle(
                fontSize: 9, fontWeight: FontWeight.w600,
                color: Color(0xFF3B6D11))),
          ]),
          const Spacer(),
          if (cartQty == 0)
            GestureDetector(onTap: onAdd,
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.blueLight,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text('+ Add', style: TextStyle(fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue))))
          else Row(children: [
            GestureDetector(onTap: onRemove,
                child: Container(width: 26, height: 26,
                    decoration: BoxDecoration(color: AppColors.bgPage,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                            color: const Color(0xFFE3EAF2))),
                    child: const Icon(Icons.remove_rounded,
                        size: 13, color: AppColors.textPrimary))),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text('$cartQty', style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w800,
                    color: AppColors.teal))),
            GestureDetector(onTap: onAdd,
                child: Container(width: 26, height: 26,
                    decoration: BoxDecoration(color: AppColors.teal,
                        borderRadius: BorderRadius.circular(7)),
                    child: const Icon(Icons.add_rounded,
                        size: 13, color: Colors.white))),
          ]),
        ]),
      ]));
  }
}

