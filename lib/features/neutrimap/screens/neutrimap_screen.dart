import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  State<NutritionPoliceScreen> createState() =>
      _NutritionPoliceScreenState();
}

class _NutritionPoliceScreenState extends State<NutritionPoliceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _detectedState = 'Telangana';
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _detectState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _detectState() async {
    setState(() => _isLocating = true);
    try {
      bool svc = await Geolocator.isLocationServiceEnabled();
      if (!svc) { _setState('Telangana'); return; }
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) { _setState('Telangana'); return; }
      }
      if (perm == LocationPermission.deniedForever) { _setState('Telangana'); return; }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 8),
      );
      _setState(_coordToState(pos.latitude, pos.longitude));
    } catch (_) {
      _setState('Telangana');
    }
  }

  void _setState(String state) =>
      setState(() { _detectedState = state; _isLocating = false; });

  String _coordToState(double lat, double lng) {
    if (lat >= 15.8 && lat <= 19.5 && lng >= 77.0 && lng <= 81.5) return 'Telangana';
    if (lat >= 12.5 && lat <= 15.8 && lng >= 76.5 && lng <= 80.5) return 'Andhra Pradesh';
    if (lat >= 11.5 && lat <= 14.0 && lng >= 74.0 && lng <= 80.5) return 'Tamil Nadu';
    if (lat >= 11.5 && lat <= 18.5 && lng >= 74.0 && lng <= 78.5) return 'Karnataka';
    if (lat >= 8.0 && lat <= 12.5 && lng >= 74.5 && lng <= 77.5) return 'Kerala';
    if (lat >= 15.5 && lat <= 22.5 && lng >= 72.5 && lng <= 80.5) return 'Maharashtra';
    if (lat >= 20.0 && lat <= 24.5 && lng >= 68.0 && lng <= 74.5) return 'Gujarat';
    if (lat >= 23.0 && lat <= 30.5 && lng >= 69.5 && lng <= 78.5) return 'Rajasthan';
    if (lat >= 28.0 && lat <= 29.0 && lng >= 76.5 && lng <= 77.5) return 'Delhi';
    if (lat >= 30.0 && lat <= 33.5 && lng >= 73.5 && lng <= 76.5) return 'Punjab';
    if (lat >= 27.5 && lat <= 30.5 && lng >= 74.5 && lng <= 77.5) return 'Haryana';
    if (lat >= 21.5 && lat <= 27.5 && lng >= 83.5 && lng <= 88.5) return 'West Bengal';
    if (lat >= 24.5 && lat <= 27.5 && lng >= 83.5 && lng <= 88.5) return 'Jharkhand';
    if (lat >= 24.0 && lat <= 27.5 && lng >= 84.0 && lng <= 88.5) return 'Bihar';
    if (lat >= 23.5 && lat <= 31.5 && lng >= 77.0 && lng <= 85.0) return 'Uttar Pradesh';
    if (lat >= 25.5 && lat <= 28.5 && lng >= 88.0 && lng <= 92.5) return 'Assam';
    if (lat >= 19.0 && lat <= 24.5 && lng >= 80.0 && lng <= 84.5) return 'Chhattisgarh';
    if (lat >= 17.5 && lat <= 22.5 && lng >= 81.5 && lng <= 87.5) return 'Odisha';
    if (lat >= 23.5 && lat <= 30.5 && lng >= 77.0 && lng <= 84.5) return 'Madhya Pradesh';
    return 'Telangana';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _buildTopBar(),
          _buildTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _NutritionTab(),
                _PoliceTab(
                    state: _detectedState,
                    isLocating: _isLocating),
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
                Text('Nutrition & Safety',
                    style: TextStyle(color: Colors.white,
                        fontSize: 18, fontWeight: FontWeight.w700)),
                Text('ICMR 2024 Guidelines + State Police Services',
                    style: TextStyle(
                        color: AppColors.textHint, fontSize: 11)),
              ],
            ),
          ),
          if (!_isLocating)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.teal.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppColors.teal, width: 0.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      color: AppColors.teal, size: 12),
                  const SizedBox(width: 4),
                  Text(_detectedState,
                      style: const TextStyle(
                          color: AppColors.teal,
                          fontSize: 10,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            )
          else
            const SizedBox(
              width: 16, height: 16,
              child: CircularProgressIndicator(
                  color: AppColors.teal, strokeWidth: 2),
            ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: AppColors.navyDark,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(4),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: AppColors.teal,
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700),
          overlayColor:
              WidgetStateProperty.all(Colors.transparent),
          tabs: const [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🥗', style: TextStyle(fontSize: 14)),
                  SizedBox(width: 6),
                  Text('ICMR Diet Plan'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('👮', style: TextStyle(fontSize: 14)),
                  SizedBox(width: 6),
                  Text('Police Services'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// NUTRITION TAB — Based on ICMR-NIN 2024 Dietary Guidelines
// ═══════════════════════════════════════════════════════════

class _NutritionTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICMR Banner
          FadeInDown(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F6E56),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ICMR-NIN Dietary Guidelines 2024',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(
                          'Official Government of India nutrition recommendations for all Indians.',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 11,
                              height: 1.4),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            final uri = Uri.parse(
                                'https://main.icmr.nic.in/sites/default/files/upload_documents/DGI_07th_May_2024_fin.pdf');
                            await launchUrl(uri,
                                mode: LaunchMode
                                    .externalApplication);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                                '📄 Download Official PDF',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text('🥗',
                      style: TextStyle(fontSize: 42)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Daily plate visual
          FadeInUp(
            delay: const Duration(milliseconds: 100),
            child: _buildPlateVisual(),
          ),
          const SizedBox(height: 20),

          // ICMR 17 Guidelines
          const Text('17 ICMR Guidelines (Simplified)',
              style: TextStyle(fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          ..._icmrGuidelines.asMap().entries.map((e) => FadeInUp(
                delay: Duration(milliseconds: e.key * 50),
                child: _GuidelineCard(
                    guideline: e.value, index: e.key + 1),
              )),
          const SizedBox(height: 20),

          // Food groups
          const Text('Daily Food Groups (ICMR Serving Sizes)',
              style: TextStyle(fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          ..._foodGroups.map((g) => _FoodGroupCard(group: g)),
          const SizedBox(height: 20),

          // Age-specific plans
          const Text('Age & Group-Based Diet Plans',
              style: TextStyle(fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          ..._agePlans.map((p) => _AgePlanCard(plan: p)),
          const SizedBox(height: 20),

          // Profession-specific plans
          const Text('Profession-Specific Diet Plans',
              style: TextStyle(fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          ..._professionPlans.map((p) => _AgePlanCard(plan: p)),
          const SizedBox(height: 20),

          // Condition-specific
          const Text('Condition-Specific Diets',
              style: TextStyle(fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          ..._conditionDiets
              .map((d) => _ConditionDietCard(diet: d)),
          const SizedBox(height: 20),

          // What to avoid
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFCEBEB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: const Color(0xFFF7C1C1), width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('🚫',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('What ICMR Says to AVOID',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFA32D2D))),
                  ],
                ),
                const SizedBox(height: 12),
                ..._avoidList.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text('• ',
                              style: TextStyle(
                                  color: Color(0xFFA32D2D),
                                  fontWeight: FontWeight.w700)),
                          Expanded(
                            child: Text(item,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF791F1F),
                                    height: 1.4)),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildPlateVisual() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🍽️', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text('The Ideal Indian Plate (ICMR)',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _PlatePortion(
                    label: 'Vegetables & Fruits',
                    pct: '50%',
                    color: const Color(0xFF1D9E75),
                    emoji: '🥦'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PlatePortion(
                    label: 'Cereals & Millets',
                    pct: '30%',
                    color: const Color(0xFFBA7517),
                    emoji: '🌾'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _PlatePortion(
                    label: 'Pulses & Legumes',
                    pct: '10%',
                    color: const Color(0xFF185FA5),
                    emoji: '🫘'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PlatePortion(
                    label: 'Dairy / Protein',
                    pct: '10%',
                    color: const Color(0xFF534AB7),
                    emoji: '🥛'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlatePortion extends StatelessWidget {
  final String label;
  final String pct;
  final Color color;
  final String emoji;

  const _PlatePortion({
    required this.label,
    required this.pct,
    required this.color,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: color)),
                Text(pct,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ICMR 17 Guidelines Data
const List<Map<String, String>> _icmrGuidelines = [
  {
    'title': 'Eat a variety of foods',
    'detail':
        'Consume foods from at least 8 food groups daily. No single food provides all nutrients.',
    'emoji': '🌈',
  },
  {
    'title': 'Ensure adequate protein intake',
    'detail':
        'Include pulses, legumes, eggs, fish, lean meat, or milk every day. Recommended: 0.8–1g protein per kg body weight.',
    'emoji': '💪',
  },
  {
    'title': 'Use oils and fats in moderation',
    'detail':
        'Limit total fat to 30% of calories. Use variety of oils. Prefer nuts, oilseeds, and seafood as fat sources.',
    'emoji': '🫒',
  },
  {
    'title': 'Avoid ultra-processed foods',
    'detail':
        'Avoid packaged snacks, instant noodles, sugary drinks, and processed meats. They cause obesity, diabetes, and heart disease.',
    'emoji': '🚫',
  },
  {
    'title': 'Restrict salt to less than 5g/day',
    'detail':
        'Excess salt causes hypertension. Avoid adding extra salt, pickles, papads, and salty snacks.',
    'emoji': '🧂',
  },
  {
    'title': 'Limit sugar to 20–25g/day',
    'detail':
        'Avoid sugary drinks, sweets, mithai, and added sugar in tea/coffee. Use naturally sweet foods like fruits.',
    'emoji': '🍬',
  },
  {
    'title': 'Drink 8–10 glasses of water daily',
    'detail':
        'Plain water is best. Coconut water and buttermilk are good alternatives. Avoid sugary and carbonated drinks.',
    'emoji': '💧',
  },
  {
    'title': 'Eat vegetables and fruits every day',
    'detail':
        'Aim for 400–500g of vegetables and 100–150g of fruits daily. Include green leafy vegetables at every meal.',
    'emoji': '🥬',
  },
  {
    'title': 'Choose whole grains and millets',
    'detail':
        'Replace refined grains with brown rice, whole wheat, ragi, bajra, jowar, and other millets for more fibre and micronutrients.',
    'emoji': '🌾',
  },
  {
    'title': 'Include dairy or dairy alternatives',
    'detail':
        '2–3 servings of milk, curd, or paneer daily. Provides calcium, protein, and B12. Prefer low-fat options for adults.',
    'emoji': '🥛',
  },
  {
    'title': 'Avoid protein supplements',
    'detail':
        'ICMR cautions against indiscriminate use of protein powders. They can cause bone loss and kidney damage. Get protein from natural foods.',
    'emoji': '⚠️',
  },
  {
    'title': 'Use healthy cooking methods',
    'detail':
        'Steam, boil, grill, or bake instead of deep frying. Avoid repeated heating of oils. Minimise cooking time to preserve nutrients.',
    'emoji': '👨‍🍳',
  },
  {
    'title': 'Be physically active daily',
    'detail':
        'At least 30–45 minutes of moderate exercise daily. Walking, yoga, swimming, cycling all count. Reduces risk of diabetes and heart disease.',
    'emoji': '🏃',
  },
  {
    'title': 'Ensure safe food and water',
    'detail':
        'Wash hands before eating. Clean and cook food properly. Use safe drinking water. Proper storage prevents food-borne illness.',
    'emoji': '🫧',
  },
  {
    'title': 'Breastfeed exclusively for 6 months',
    'detail':
        'Breast milk is the perfect food for infants. No water, formula, or other foods for first 6 months. Continue breastfeeding up to 2 years.',
    'emoji': '🤱',
  },
  {
    'title': 'Eat adequate diets during pregnancy',
    'detail':
        'Increase calories by 350 kcal/day during pregnancy. Extra iron, folic acid, calcium essential. Avoid alcohol completely.',
    'emoji': '🤰',
  },
  {
    'title': 'Prevent abdominal obesity',
    'detail':
        'Waist circumference: men <90cm, women <80cm. Belly fat is a strong predictor of diabetes and heart disease in Indians.',
    'emoji': '⚖️',
  },
];

// Food groups data
const List<Map<String, dynamic>> _foodGroups = [
  {
    'name': 'Cereals & Millets',
    'emoji': '🌾',
    'servings': '6–11 servings/day',
    'serving_size': '1 serving = 1 chapati or ½ cup cooked rice',
    'examples': 'Brown rice, whole wheat, ragi, bajra, jowar, oats',
    'benefits': 'Energy, fibre, B-vitamins, iron',
    'color': Color(0xFFBA7517),
  },
  {
    'name': 'Vegetables',
    'emoji': '🥦',
    'servings': '3–5 servings/day',
    'serving_size': '1 serving = 1 cup raw or ½ cup cooked',
    'examples': 'Spinach, broccoli, tomato, carrot, beans, drumstick',
    'benefits': 'Vitamins A, C, K, folate, fibre, antioxidants',
    'color': Color(0xFF0F6E56),
  },
  {
    'name': 'Fruits',
    'emoji': '🍎',
    'servings': '2–3 servings/day',
    'serving_size': '1 serving = 1 medium fruit or ½ cup cut fruit',
    'examples': 'Banana, apple, guava, papaya, citrus, mango',
    'benefits': 'Vitamin C, potassium, fibre, natural sugars',
    'color': Color(0xFFD85A30),
  },
  {
    'name': 'Pulses & Legumes',
    'emoji': '🫘',
    'servings': '2–3 servings/day',
    'serving_size': '1 serving = ½ cup cooked dal or 30g raw',
    'examples': 'Masoor dal, chana, rajma, moong, soya, peanuts',
    'benefits': 'Protein, fibre, iron, folate, zinc',
    'color': Color(0xFF185FA5),
  },
  {
    'name': 'Dairy',
    'emoji': '🥛',
    'servings': '2–3 servings/day',
    'serving_size': '1 serving = 1 cup milk or 1 cup curd',
    'examples': 'Milk, curd, paneer, buttermilk, cheese',
    'benefits': 'Calcium, protein, B12, phosphorus',
    'color': Color(0xFF534AB7),
  },
  {
    'name': 'Meat, Fish, Eggs',
    'emoji': '🥚',
    'servings': '1–2 servings/day (optional)',
    'serving_size': '1 serving = 1 egg or 30g cooked meat/fish',
    'examples': 'Eggs, fish (rohu, pomfret), chicken, lean meats',
    'benefits': 'Complete protein, iron, zinc, B12, omega-3',
    'color': Color(0xFF854F0B),
  },
  {
    'name': 'Oils, Nuts & Seeds',
    'emoji': '🫒',
    'servings': '3–4 tsp oil + handful nuts/seeds daily',
    'serving_size': '1 serving = 1 tsp oil or 7–10 almonds',
    'examples': 'Groundnut oil, mustard oil, sunflower oil, almonds, walnuts',
    'benefits': 'Essential fatty acids, fat-soluble vitamins',
    'color': Color(0xFF3B6D11),
  },
  {
    'name': 'Water & Fluids',
    'emoji': '💧',
    'servings': '8–10 glasses/day',
    'serving_size': '1 glass = 250mL',
    'examples': 'Water, coconut water, buttermilk, fresh lime water',
    'benefits': 'Hydration, kidney function, metabolism, temperature control',
    'color': Color(0xFF185FA5),
  },
];

// Age-based plans
const List<Map<String, dynamic>> _agePlans = [
  {
    'group': 'Infants (0–6 months)',
    'emoji': '👶',
    'calories': 'As per breast milk',
    'key_points': [
      'Exclusive breastfeeding only — no water, no formula',
      'Breast milk provides all nutrition needed',
      'Feed on demand, at least 8–12 times/day',
    ],
    'color': Color(0xFF534AB7),
  },
  {
    'group': 'Children (1–10 years)',
    'emoji': '🧒',
    'calories': '1,200–1,800 kcal/day',
    'key_points': [
      'Include all food groups every day',
      'Millets like ragi excellent for iron and calcium',
      'Avoid junk food, chips, sugary drinks',
      'Encourage eating with family',
    ],
    'color': Color(0xFFD85A30),
  },
  {
    'group': 'Adolescents (11–18 years)',
    'emoji': '🧑',
    'calories': '1,800–2,500 kcal/day',
    'key_points': [
      'Higher calcium and iron needs (growth phase)',
      'Girls need extra iron to compensate for menstruation',
      'Avoid protein supplements and fad diets',
      'Include sports/physical activity daily',
    ],
    'color': Color(0xFF185FA5),
  },
  {
    'group': 'Adults (19–60 years)',
    'emoji': '🧑‍💼',
    'calories': '1,900–2,400 kcal/day',
    'key_points': [
      '50% of plate should be vegetables and fruits',
      'Limit salt <5g/day and sugar <25g/day',
      'Choose whole grains over refined foods',
      '30–45 min moderate exercise daily',
    ],
    'color': Color(0xFF0F6E56),
  },
  {
    'group': 'Pregnant Women',
    'emoji': '🤰',
    'calories': '+350 kcal/day extra',
    'key_points': [
      'Folic acid 5mg/day from before conception',
      'Iron 60mg + folic acid 500mcg daily',
      'Calcium 1200mg/day from milk and dairy',
      'Avoid alcohol, raw fish, unpasteurized dairy',
    ],
    'color': Color(0xFFD4537E),
  },
  {
    'group': 'Elderly (60+ years)',
    'emoji': '👴',
    'calories': '1,600–2,000 kcal/day',
    'key_points': [
      'Higher protein to prevent muscle loss (sarcopenia)',
      'Calcium and Vitamin D crucial to prevent fractures',
      'Easy-to-chew, soft foods if dental issues',
      'Adequate hydration (thirst sensation reduced)',
    ],
    'color': Color(0xFFBA7517),
  },
];

// Profession-based plans
const List<Map<String, dynamic>> _professionPlans = [
  {
    'group': 'Sports Men & Athletes',
    'emoji': '🏃‍♂️',
    'calories': '2,500–3,500+ kcal/day',
    'key_points': [
      'High complex carbs (brown rice, sweet potato) for energy',
      'Lean protein (chicken, fish, eggs) for muscle recovery',
      'Hydration with electrolytes during workouts',
      'Pre-workout and post-workout meals are critical',
    ],
    'color': Color(0xFFD85A30),
  },
  {
    'group': 'Uniform Service Personnel',
    'emoji': '👮‍♂️',
    'calories': '2,200–2,800 kcal/day',
    'key_points': [
      'Balanced meals to sustain long shifts on feet',
      'High protein and moderate carbs',
      'Avoid heavy meals before active duties to prevent sluggishness',
      'Frequent hydration is essential while outdoors',
    ],
    'color': Color(0xFF185FA5),
  },
  {
    'group': 'Police',
    'emoji': '🚨',
    'calories': '2,400–3,000 kcal/day',
    'key_points': [
      'Focus on stamina and quick energy foods',
      'Include nuts, seeds, and fruits for quick snacking on duty',
      'Adequate protein to maintain physical strength',
      'Strong focus on cardiovascular health (healthy fats)',
    ],
    'color': Color(0xFF0F6E56),
  },
  {
    'group': 'Physical Trainers',
    'emoji': '🏋️‍♂️',
    'calories': '2,800–3,500 kcal/day',
    'key_points': [
      'Protein intake of 1.6-2.0g per kg of body weight',
      'Frequent meals (every 3 hours) to maintain metabolic rate',
      'Healthy fats (avocado, olive oil, nuts) for joints',
      'High micronutrient focus for peak performance',
    ],
    'color': Color(0xFFE8243A),
  },
];

// Condition-specific diets
const List<Map<String, dynamic>> _conditionDiets = [
  {
    'condition': 'Diabetes (Type 2)',
    'emoji': '🩸',
    'color': Color(0xFF185FA5),
    'dos': [
      'Whole grains, millets, brown rice',
      'Bitter gourd, methi, jamun',
      'High fibre foods (vegetables, legumes)',
      'Small frequent meals (every 3–4 hrs)',
    ],
    'donts': [
      'White rice, maida, bread',
      'Sugary drinks, fruit juices',
      'Fried foods, sweets, mithai',
    ],
  },
  {
    'condition': 'Heart Disease',
    'emoji': '❤️',
    'color': Color(0xFFE24B4A),
    'dos': [
      'Omega-3 rich fish (2–3 times/week)',
      'Oats, barley for beta-glucan',
      'Fruits, vegetables, nuts',
      'Olive oil, mustard oil in moderation',
    ],
    'donts': [
      'Saturated fats (ghee, butter excess)',
      'Trans fats (vanaspati, fried snacks)',
      'Salt >5g/day',
      'Processed meats, red meat',
    ],
  },
  {
    'condition': 'High Blood Pressure',
    'emoji': '📊',
    'color': Color(0xFF534AB7),
    'dos': [
      'DASH diet — fruits, vegetables, low-fat dairy',
      'Potassium-rich foods (banana, potato, spinach)',
      'Whole grains',
      'Garlic, beetroot',
    ],
    'donts': [
      'Salt and high-sodium foods',
      'Pickles, papads, processed snacks',
      'Excessive alcohol',
      'Caffeine in excess',
    ],
  },
  {
    'condition': 'Anaemia',
    'emoji': '💊',
    'color': Color(0xFF854F0B),
    'dos': [
      'Iron-rich foods: green leafy veg, jaggery',
      'Vitamin C with iron for better absorption',
      'Organ meats, fish, poultry',
      'Iron-fortified foods',
    ],
    'donts': [
      'Tea/coffee 1 hour before and after meals',
      'Excessive milk with iron-rich meals',
      'High fibre diets with every iron meal',
    ],
  },
  {
    'condition': 'Obesity',
    'emoji': '⚖️',
    'color': Color(0xFF0F6E56),
    'dos': [
      'High fibre, low calorie density foods',
      'Eat slowly, mindfully',
      'Large amounts of vegetables',
      'Protein at every meal for satiety',
    ],
    'donts': [
      'Ultra-processed foods',
      'Sugary beverages',
      'Large portion sizes',
      'Late-night eating',
    ],
  },
];

const List<String> _avoidList = [
  'Ultra-processed foods: packaged chips, biscuits, instant noodles',
  'Sugary drinks: cola, fruit drinks with added sugar, energy drinks',
  'Trans fats: vanaspati, partially hydrogenated vegetable oils',
  'Protein supplements/powders — risk of kidney damage and bone loss',
  'Excess salt >5g/day — major cause of hypertension in India',
  'Alcohol — linked to 7 types of cancer, liver damage, heart disease',
  'Refined carbohydrates: white rice excess, maida products daily',
  'Red and processed meats in excess: sausages, salami, ham',
  'Tea/coffee within 1 hour of meals — blocks iron absorption',
];

class _GuidelineCard extends StatelessWidget {
  final Map<String, String> guideline;
  final int index;

  const _GuidelineCard({required this.guideline, required this.index});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3DE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text('$index',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF3B6D11))),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(guideline['emoji']!,
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(guideline['title']!,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(guideline['detail']!,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodGroupCard extends StatelessWidget {
  final Map<String, dynamic> group;

  const _FoodGroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final Color color = group['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(group['emoji'] as String,
                  style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(group['name'] as String,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(group['servings'] as String,
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: color)),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(group['serving_size'] as String,
                    style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary)),
                const SizedBox(height: 3),
                Text(group['examples'] as String,
                    style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textHint,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 3),
                Text('✓ ${group['benefits']}',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AgePlanCard extends StatefulWidget {
  final Map<String, dynamic> plan;

  const _AgePlanCard({required this.plan});

  @override
  State<_AgePlanCard> createState() => _AgePlanCardState();
}

class _AgePlanCardState extends State<_AgePlanCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final Color color = widget.plan['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () =>
                setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Text(widget.plan['emoji'] as String,
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(widget.plan['group'] as String,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary)),
                        Text(
                            widget.plan['calories'] as String,
                            style: TextStyle(
                                fontSize: 11,
                                color: color,
                                fontWeight: FontWeight.w600)),
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
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                      color: Color(0xFFF0F4F8), height: 1),
                  const SizedBox(height: 10),
                  ...(widget.plan['key_points'] as List<String>)
                      .map((pt) => Padding(
                            padding:
                                const EdgeInsets.only(bottom: 5),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    size: 14, color: color),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: Text(pt,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors
                                              .textSecondary,
                                          height: 1.4)),
                                ),
                              ],
                            ),
                          )),
                ],
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

class _ConditionDietCard extends StatefulWidget {
  final Map<String, dynamic> diet;

  const _ConditionDietCard({required this.diet});

  @override
  State<_ConditionDietCard> createState() =>
      _ConditionDietCardState();
}

class _ConditionDietCardState extends State<_ConditionDietCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final Color color = widget.diet['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () =>
                setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                          widget.diet['emoji'] as String,
                          style:
                              const TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                        widget.diet['condition'] as String,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textHint, size: 20,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                      color: Color(0xFFF0F4F8), height: 1),
                  const SizedBox(height: 10),
                  const Text('✅  Eat more of:',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3B6D11))),
                  const SizedBox(height: 6),
                  ...(widget.diet['dos'] as List<String>).map(
                    (d) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Text('• ',
                              style: TextStyle(
                                  color: Color(0xFF3B6D11))),
                          Expanded(
                            child: Text(d,
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors
                                        .textSecondary)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('🚫  Avoid:',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFA32D2D))),
                  const SizedBox(height: 6),
                  ...(widget.diet['donts'] as List<String>).map(
                    (d) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Text('• ',
                              style: TextStyle(
                                  color: Color(0xFFA32D2D))),
                          Expanded(
                            child: Text(d,
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors
                                        .textSecondary)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// POLICE SERVICES TAB — State-wise
// ═══════════════════════════════════════════════════════════

class _PoliceTab extends StatelessWidget {
  final String state;
  final bool isLocating;

  const _PoliceTab({required this.state, required this.isLocating});

  static const Map<String, Map<String, dynamic>> _statePolice = {
    'Telangana': {
      'emergency': '100',
      'women_helpline': '1091',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '9010203626',
      'website': 'https://www.tspolice.gov.in',
      'online_complaint': 'https://www.tscop.gov.in',
      'description': 'Telangana State Police. Hawk-Eye vehicle tracking active across state.',
      'special': 'SHE Teams for women safety, Dial 100 PCR, TSCOP app',
    },
    'Andhra Pradesh': {
      'emergency': '100',
      'women_helpline': '1091',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '1095',
      'website': 'https://www.appolice.gov.in',
      'online_complaint': 'https://www.appolice.gov.in',
      'description': 'Andhra Pradesh Police. DISHA app for women emergency across AP.',
      'special': 'DISHA helpline 181 for women, AP Police 100 PCR fleet',
    },
    'Tamil Nadu': {
      'emergency': '100',
      'women_helpline': '1091',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '103',
      'website': 'https://www.tnpolice.gov.in',
      'online_complaint': 'https://eservices.tnpolice.gov.in',
      'description': 'Tamil Nadu Police. Kavalan app for citizen safety.',
      'special': 'Kavalan citizen app, Nirbhaya force for women, Tourist police',
    },
    'Karnataka': {
      'emergency': '100',
      'women_helpline': '1091',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '080-22868400',
      'website': 'https://ksp.gov.in',
      'online_complaint': 'https://ksp.gov.in',
      'description': 'Karnataka State Police. Suraksha app for women.',
      'special': 'Suraksha women safety app, Abhaya helpline 1090',
    },
    'Kerala': {
      'emergency': '100',
      'women_helpline': '1091',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '0471-2721547',
      'website': 'https://www.keralapolice.gov.in',
      'online_complaint': 'https://citizen.keralapolice.gov.in',
      'description': 'Kerala Police. Pink Police Patrol for women, Tourist police.',
      'special': 'Pink Police, Tourist Police helpline 1800 425 4747',
    },
    'Maharashtra': {
      'emergency': '100',
      'women_helpline': '1091',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '1095',
      'website': 'https://www.maharashtrapolice.gov.in',
      'online_complaint': 'https://citizen.mahapolice.gov.in',
      'description': 'Maharashtra Police. Nirbhaya Pathak women patrol.',
      'special': 'Nirbhaya Pathak, Mumbai Police 022-22621855',
    },
    'Delhi': {
      'emergency': '100',
      'women_helpline': '1091',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '1095',
      'website': 'https://www.delhipolice.gov.in',
      'online_complaint': 'https://delhipolice.gov.in/online-fir',
      'description': 'Delhi Police. Himmat Plus app for women safety.',
      'special': 'Himmat+ app, PCR Van 100, Anti-Stalking helpline',
    },
    'Gujarat': {
      'emergency': '100',
      'women_helpline': '1091',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '079-25505050',
      'website': 'https://www.gujaratpolice.gov.in',
      'online_complaint': 'https://www.gujaratpolice.gov.in',
      'description': 'Gujarat Police. i-Cop app for citizen services.',
      'special': 'i-Cop citizen app, Abhayam 181 women helpline',
    },
    'Rajasthan': {
      'emergency': '100',
      'women_helpline': '1091',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '1095',
      'website': 'https://www.police.rajasthan.gov.in',
      'online_complaint': 'https://police.rajasthan.gov.in',
      'description': 'Rajasthan Police. Abhay Helpline for women.',
      'special': 'Abhay Commandos (women safety unit), Tourist Police',
    },
    'Punjab': {
      'emergency': '100',
      'women_helpline': '1091',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '1073',
      'website': 'https://www.punjabpolice.gov.in',
      'online_complaint': 'https://copsewa.punjabpolice.gov.in',
      'description': 'Punjab Police. TRAX traffic management system.',
      'special': 'CopSewa citizen portal, Safe City project Ludhiana',
    },
    'West Bengal': {
      'emergency': '100',
      'women_helpline': '1091',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '033-22143004',
      'website': 'https://wbpolice.gov.in',
      'online_complaint': 'https://wbpolice.gov.in',
      'description': 'West Bengal Police. Dial 100 and WhatsApp-based complaint system.',
      'special': 'Aparajita women helpline 181, Kolkata Police 1800-345-2999',
    },
    'Uttar Pradesh': {
      'emergency': '100',
      'women_helpline': '1090',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '1073',
      'website': 'https://uppolice.gov.in',
      'online_complaint': 'https://uppolice.gov.in',
      'description': 'Uttar Pradesh Police. UP 112 PRVC fleet across state.',
      'special': 'Women Power Line 1090 (UP special), UP 112 app',
    },
    'Madhya Pradesh': {
      'emergency': '100',
      'women_helpline': '1091',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '1073',
      'website': 'https://www.mppolice.gov.in',
      'online_complaint': 'https://www.mppolice.gov.in',
      'description': 'Madhya Pradesh Police. Jan Suraksha App.',
      'special': 'MP Jan Suraksha citizen app, Dial 100 PCR',
    },
    'Bihar': {
      'emergency': '100',
      'women_helpline': '1091',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '1073',
      'website': 'https://biharpolice.bih.nic.in',
      'online_complaint': 'https://biharpolice.bih.nic.in',
      'description': 'Bihar Police. BPRO app for police services.',
      'special': 'BPRO Bihar Police App, Shakti Vahini women helpline',
    },
    'Assam': {
      'emergency': '100',
      'women_helpline': '1091',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '0361-2237255',
      'website': 'https://assampolice.gov.in',
      'online_complaint': 'https://assampolice.gov.in',
      'description': 'Assam Police. Prakash citizen portal.',
      'special': 'Prakash citizen grievance portal, Mission Smile (missing children)',
    },
    'Haryana': {
      'emergency': '100',
      'women_helpline': '1091',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '1073',
      'website': 'https://haryanapolice.gov.in',
      'online_complaint': 'https://haryanapolice.gov.in',
      'description': 'Haryana Police. Durga Shakti app for women safety.',
      'special': 'Durga Shakti app, Saarthi helpline',
    },
    'Chhattisgarh': {
      'emergency': '100',
      'women_helpline': '1091',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '1073',
      'website': 'https://cgpolice.gov.in',
      'online_complaint': 'https://cgpolice.gov.in',
      'description': 'Chhattisgarh Police. CG Police citizen portal.',
      'special': 'Gariaband mobile police, Abhiyaan (Anti-Naxal unit)',
    },
    'Odisha': {
      'emergency': '100',
      'women_helpline': '1091',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '0674-2531925',
      'website': 'https://odishapolice.gov.in',
      'online_complaint': 'https://odishapolice.gov.in',
      'description': 'Odisha Police. Mo Police App.',
      'special': 'Mo Police citizen app, Mahila Police Volunteers scheme',
    },
    'Himachal Pradesh': {
      'emergency': '100',
      'women_helpline': '1091',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '0177-2629008',
      'website': 'https://himachalpolice.gov.in',
      'online_complaint': 'https://himachalpolice.gov.in',
      'description': 'Himachal Pradesh Police. HP Police Awaaz app.',
      'special': 'HP Police Awaaz, Tourist Police Kullu-Manali-Shimla',
    },
    'Uttarakhand': {
      'emergency': '100',
      'women_helpline': '1091',
      'senior_citizen': '1291',
      'cyber_crime': '1930',
      'child_helpline': '1098',
      'traffic': '0135-2657900',
      'website': 'https://uttarakhandpolice.uk.gov.in',
      'online_complaint': 'https://uttarakhandpolice.uk.gov.in',
      'description': 'Uttarakhand Police. UK Police App.',
      'special': 'Shourya app for women, Tourist Police helpline',
    },
  };

  Future<void> _call(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _statePolice[state] ?? _statePolice['Telangana']!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // National emergency banner
          FadeInDown(
            child: _NationalEmergencyBanner(onCall: _call),
          ),
          const SizedBox(height: 16),

          // State police info
          FadeInUp(
            delay: const Duration(milliseconds: 100),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A0A2E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('👮',
                          style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text('$state Police',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.w700)),
                            Text(
                                data['description'] as String,
                                style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                    height: 1.4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Special feature
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Color(0xFFEF9F27),
                            size: 14),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                              data['special'] as String,
                              style: const TextStyle(
                                  color: Color(0xFFEF9F27),
                                  fontSize: 11,
                                  height: 1.3)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Emergency numbers grid
          const Text('Emergency Numbers',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.8,
            children: [
              _HelplineCard(
                label: 'Police Emergency',
                number: data['emergency'] as String,
                icon: '🚨',
                color: const Color(0xFFE24B4A),
                onTap: () => _call(data['emergency'] as String),
              ),
              _HelplineCard(
                label: 'Women Helpline',
                number: data['women_helpline'] as String,
                icon: '👩',
                color: const Color(0xFFD4537E),
                onTap: () => _call(
                    data['women_helpline'] as String),
              ),
              _HelplineCard(
                label: 'Cyber Crime',
                number: data['cyber_crime'] as String,
                icon: '💻',
                color: AppColors.blue,
                onTap: () =>
                    _call(data['cyber_crime'] as String),
              ),
              _HelplineCard(
                label: 'Child Helpline',
                number: data['child_helpline'] as String,
                icon: '👶',
                color: const Color(0xFF534AB7),
                onTap: () =>
                    _call(data['child_helpline'] as String),
              ),
              _HelplineCard(
                label: 'Senior Citizen',
                number: data['senior_citizen'] as String,
                icon: '👴',
                color: AppColors.teal,
                onTap: () => _call(
                    data['senior_citizen'] as String),
              ),
              _HelplineCard(
                label: 'Traffic Police',
                number: data['traffic'] as String,
                icon: '🚦',
                color: const Color(0xFFBA7517),
                onTap: () => _call(data['traffic'] as String),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Online services
          const Text('Online Services',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          _OnlineServiceCard(
            title: 'Official Police Website',
            subtitle: '$state Police Official Portal',
            icon: Icons.language_rounded,
            url: data['website'] as String,
            color: AppColors.blue,
            onTap: () => _openUrl(data['website'] as String),
          ),
          const SizedBox(height: 8),
          _OnlineServiceCard(
            title: 'File Online Complaint / FIR',
            subtitle: 'Register FIR without visiting station',
            icon: Icons.description_outlined,
            url: data['online_complaint'] as String,
            color: AppColors.teal,
            onTap: () => _openUrl(
                data['online_complaint'] as String),
          ),
          const SizedBox(height: 8),
          _OnlineServiceCard(
            title: 'National Cyber Crime Portal',
            subtitle: 'Report online fraud, scam, harassment',
            icon: Icons.security_rounded,
            url: 'https://cybercrime.gov.in',
            color: const Color(0xFF534AB7),
            onTap: () =>
                _openUrl('https://cybercrime.gov.in'),
          ),
          const SizedBox(height: 8),
          _OnlineServiceCard(
            title: '112 India Emergency App',
            subtitle: 'SOS button with live GPS location sharing',
            icon: Icons.phone_in_talk_rounded,
            url: 'https://112.gov.in',
            color: const Color(0xFFE24B4A),
            onTap: () => _openUrl('https://112.gov.in'),
          ),
          const SizedBox(height: 20),

          // National helplines
          const Text('National Helplines',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          ..._nationalHelplines.map((h) => _NationalHelplineRow(
                helpline: h,
                onCall: _call,
              )),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

const List<Map<String, String>> _nationalHelplines = [
  {'label': 'Unified Emergency (112)', 'number': '112', 'emoji': '🆘'},
  {'label': 'Ambulance', 'number': '108', 'emoji': '🚑'},
  {'label': 'Fire & Rescue', 'number': '101', 'emoji': '🔥'},
  {'label': 'National Disaster Mgmt', 'number': '1078', 'emoji': '🌊'},
  {'label': 'Railway Police (GRP)', 'number': '1512', 'emoji': '🚂'},
  {'label': 'Anti-Poison Helpline', 'number': '1800-116-117', 'emoji': '☠️'},
  {'label': 'Domestic Violence', 'number': '181', 'emoji': '🏠'},
  {'label': 'Missing Persons (NCPCR)', 'number': '1800-121-2830', 'emoji': '👤'},
  {'label': 'Anti-Trafficking (MHA)', 'number': '1800-419-8800', 'emoji': '🔒'},
  {'label': 'Mental Health (Vandrevala)', 'number': '1860-2662-345', 'emoji': '🧠'},
  {'label': 'Suicide Prevention (iCall)', 'number': '9152987821', 'emoji': '💚'},
  {'label': 'Road Accident Emergency', 'number': '1073', 'emoji': '🚗'},
];

class _NationalEmergencyBanner extends StatelessWidget {
  final Future<void> Function(String) onCall;

  const _NationalEmergencyBanner({required this.onCall});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onCall('112'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE8243A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text('🆘',
                    style: TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DIAL 112 — National Emergency',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800)),
                  SizedBox(height: 4),
                  Text(
                    'Single number for Police + Ambulance + Fire. Works in ALL Indian states 24×7. Free from any phone.',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        height: 1.4),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('Call 112',
                  style: TextStyle(
                      color: Color(0xFFE8243A),
                      fontSize: 13,
                      fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelplineCard extends StatelessWidget {
  final String label;
  final String number;
  final String icon;
  final Color color;
  final VoidCallback onTap;

  const _HelplineCard({
    required this.label,
    required this.number,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: color.withOpacity(0.25), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(icon,
                    style: const TextStyle(fontSize: 18)),
                const Spacer(),
                Icon(Icons.call_rounded, color: color, size: 16),
              ],
            ),
            const Spacer(),
            Text(number,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: color)),
            Text(label,
                style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _OnlineServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String url;
  final Color color;
  final VoidCallback onTap;

  const _OnlineServiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.url,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: const Color(0xFFE3EAF2), width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary)),
                ],
              ),
            ),
            Icon(Icons.open_in_new_rounded,
                color: color, size: 16),
          ],
        ),
      ),
    );
  }
}

class _NationalHelplineRow extends StatelessWidget {
  final Map<String, String> helpline;
  final Future<void> Function(String) onCall;

  const _NationalHelplineRow({
    required this.helpline,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Row(
        children: [
          Text(helpline['emoji']!,
              style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(helpline['label']!,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600)),
          ),
          GestureDetector(
            onTap: () => onCall(helpline['number']!),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFE8243A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.call_rounded,
                      color: Color(0xFFE8243A), size: 13),
                  const SizedBox(width: 5),
                  Text(helpline['number']!,
                      style: const TextStyle(
                          color: Color(0xFFE8243A),
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}