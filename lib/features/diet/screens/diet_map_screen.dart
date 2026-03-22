import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/translations/app_translations.dart';

class DietMapScreen extends StatefulWidget {
  const DietMapScreen({super.key});

  @override
  State<DietMapScreen> createState() => _DietMapScreenState();
}

class _DietMapScreenState extends State<DietMapScreen> {
  String _selectedRegion = 'North';
  String _selectedCategory = 'All';
  
  // Get translated region list based on current language
  List<Map<String, String>> get _regions {
    final t = AppTranslations.instance;
    return [
      {'code': 'North', 'name': t.tr('north_indian'), 'icon': '🏔️'},
      {'code': 'South', 'name': t.tr('south_indian'), 'icon': '🌴'},
      {'code': 'East', 'name': t.tr('east_indian'), 'icon': '🌊'},
      {'code': 'West', 'name': t.tr('west_indian'), 'icon': '🏜️'},
      {'code': 'Central', 'name': t.tr('central_indian'), 'icon': '⛰️'},
      {'code': 'NorthEast', 'name': t.tr('northeast_indian'), 'icon': '🌲'},
    ];
  }
  
  // Get translated categories
  List<Map<String, String>> get _categories {
    final t = AppTranslations.instance;
    return [
      {'code': 'All', 'name': t.tr('all')},
      {'code': 'Balanced Diet', 'name': t.tr('balanced_diet')},
      {'code': 'Weight Loss', 'name': t.tr('weight_loss')},
      {'code': 'Diabetes', 'name': t.tr('diabetes')},
      {'code': 'Heart Health', 'name': t.tr('heart_health')},
      {'code': 'Immunity', 'name': t.tr('immunity')},
    ];
  }
  
  // Complete diet data with translation keys
  final Map<String, List<DietMapItem>> _dietData = {
    'North': [
      DietMapItem(
        nameKey: 'punjabi_thali',
        descKey: 'punjabi_thali_desc',
        benefitsKey: 'punjabi_thali_benefits',
        calories: '450-550',
        imageIcon: '🍛',
        region: 'North',
        category: 'Balanced Diet',
        ingredientsKey: 'punjabi_thali_ingredients',
        prepKey: 'punjabi_thali_prep',
      ),
      DietMapItem(
        nameKey: 'kashmiri_kahwa',
        descKey: 'kashmiri_kahwa_desc',
        benefitsKey: 'kashmiri_kahwa_benefits',
        calories: '20-30',
        imageIcon: '🍵',
        region: 'North',
        category: 'Immunity',
        ingredientsKey: 'kashmiri_kahwa_ingredients',
        prepKey: 'kashmiri_kahwa_prep',
      ),
      DietMapItem(
        nameKey: 'litti_chokha',
        descKey: 'litti_chokha_desc',
        benefitsKey: 'litti_chokha_benefits',
        calories: '400-500',
        imageIcon: '🥘',
        region: 'North',
        category: 'Weight Loss',
        ingredientsKey: 'litti_chokha_ingredients',
        prepKey: 'litti_chokha_prep',
      ),
    ],
    'South': [
      DietMapItem(
        nameKey: 'idli_sambar',
        descKey: 'idli_sambar_desc',
        benefitsKey: 'idli_sambar_benefits',
        calories: '300-350',
        imageIcon: '🥞',
        region: 'South',
        category: 'Diabetes',
        ingredientsKey: 'idli_sambar_ingredients',
        prepKey: 'idli_sambar_prep',
      ),
      DietMapItem(
        nameKey: 'avial',
        descKey: 'avial_desc',
        benefitsKey: 'avial_benefits',
        calories: '150-200',
        imageIcon: '🥘',
        region: 'South',
        category: 'Heart Health',
        ingredientsKey: 'avial_ingredients',
        prepKey: 'avial_prep',
      ),
      DietMapItem(
        nameKey: 'ragi_mudde',
        descKey: 'ragi_mudde_desc',
        benefitsKey: 'ragi_mudde_benefits',
        calories: '280-320',
        imageIcon: '🌾',
        region: 'South',
        category: 'Balanced Diet',
        ingredientsKey: 'ragi_mudde_ingredients',
        prepKey: 'ragi_mudde_prep',
      ),
    ],
    'East': [
      DietMapItem(
        nameKey: 'bengali_fish_curry',
        descKey: 'bengali_fish_curry_desc',
        benefitsKey: 'bengali_fish_curry_benefits',
        calories: '350-400',
        imageIcon: '🐟',
        region: 'East',
        category: 'Heart Health',
        ingredientsKey: 'bengali_fish_curry_ingredients',
        prepKey: 'bengali_fish_curry_prep',
      ),
      DietMapItem(
        nameKey: 'macher_jhol',
        descKey: 'macher_jhol_desc',
        benefitsKey: 'macher_jhol_benefits',
        calories: '250-300',
        imageIcon: '🍲',
        region: 'East',
        category: 'Weight Loss',
        ingredientsKey: 'macher_jhol_ingredients',
        prepKey: 'macher_jhol_prep',
      ),
    ],
    'West': [
      DietMapItem(
        nameKey: 'gujarati_thali',
        descKey: 'gujarati_thali_desc',
        benefitsKey: 'gujarati_thali_benefits',
        calories: '400-500',
        imageIcon: '🍛',
        region: 'West',
        category: 'Balanced Diet',
        ingredientsKey: 'gujarati_thali_ingredients',
        prepKey: 'gujarati_thali_prep',
      ),
      DietMapItem(
        nameKey: 'pav_bhaji',
        descKey: 'pav_bhaji_desc',
        benefitsKey: 'pav_bhaji_benefits',
        calories: '350-400',
        imageIcon: '🥖',
        region: 'West',
        category: 'Weight Loss',
        ingredientsKey: 'pav_bhaji_ingredients',
        prepKey: 'pav_bhaji_prep',
      ),
    ],
    'Central': [
      DietMapItem(
        nameKey: 'dal_bafla',
        descKey: 'dal_bafla_desc',
        benefitsKey: 'dal_bafla_benefits',
        calories: '450-550',
        imageIcon: '🍚',
        region: 'Central',
        category: 'Balanced Diet',
        ingredientsKey: 'dal_bafla_ingredients',
        prepKey: 'dal_bafla_prep',
      ),
    ],
    'NorthEast': [
      DietMapItem(
        nameKey: 'bamboo_shoot_curry',
        descKey: 'bamboo_shoot_curry_desc',
        benefitsKey: 'bamboo_shoot_curry_benefits',
        calories: '150-200',
        imageIcon: '🎋',
        region: 'NorthEast',
        category: 'Weight Loss',
        ingredientsKey: 'bamboo_shoot_curry_ingredients',
        prepKey: 'bamboo_shoot_curry_prep',
      ),
      DietMapItem(
        nameKey: 'smoked_pork',
        descKey: 'smoked_pork_desc',
        benefitsKey: 'smoked_pork_benefits',
        calories: '300-350',
        imageIcon: '🍖',
        region: 'NorthEast',
        category: 'Heart Health',
        ingredientsKey: 'smoked_pork_ingredients',
        prepKey: 'smoked_pork_prep',
      ),
    ],
  };

  List<DietMapItem> get _filteredItems {
    final regionItems = _dietData[_selectedRegion] ?? [];
    if (_selectedCategory == 'All') return regionItems;
    return regionItems.where((item) => item.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.instance;
    
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _buildTopBar(t),
          _buildRegionMap(t),
          _buildCategoryFilters(t),
          Expanded(
            child: _filteredItems.isEmpty
                ? _buildEmptyState(t)
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredItems.length,
                    itemBuilder: (_, i) => FadeInUp(
                      delay: Duration(milliseconds: i * 80),
                      child: _DietCard(item: _filteredItems[i], t: t),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(AppTranslations t) {
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.tr('diet_map'),
                    style: const TextStyle(color: Colors.white,
                        fontSize: 18, fontWeight: FontWeight.w700)),
                Text(t.tr('diet_map_subtitle'),
                    style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionMap(AppTranslations t) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _regions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final region = _regions[i];
          final isSelected = region['code'] == _selectedRegion;
          return GestureDetector(
            onTap: () => setState(() => _selectedRegion = region['code']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.teal : const Color(0xFFF4F7FB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.teal : const Color(0xFFE3EAF2),
                  width: isSelected ? 1.5 : 0.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(region['icon']!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text(region['name']!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryFilters(AppTranslations t) {
    return Container(
      color: Colors.white,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = _categories[i];
          final isSelected = cat['code'] == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat['code']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.blue : AppColors.bgPage,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.blue : const Color(0xFFE3EAF2),
                  width: 0.5,
                ),
              ),
              child: Text(cat['name']!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.navyLight,
                  )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(AppTranslations t) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.restaurant_menu_outlined,
              size: 48, color: AppColors.textHint),
          const SizedBox(height: 12),
          Text('${t.tr('no_items_found')} ${t.tr('for')} ${_selectedCategory}',
              style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class DietMapItem {
  final String nameKey, descKey, benefitsKey, ingredientsKey, prepKey;
  final String calories, imageIcon, region, category;
  
  DietMapItem({
    required this.nameKey,
    required this.descKey,
    required this.benefitsKey,
    required this.ingredientsKey,
    required this.prepKey,
    required this.calories,
    required this.imageIcon,
    required this.region,
    required this.category,
  });
}

class _DietCard extends StatefulWidget {
  final DietMapItem item;
  final AppTranslations t;
  const _DietCard({required this.item, required this.t});

  @override
  State<_DietCard> createState() => _DietCardState();
}

class _DietCardState extends State<_DietCard> {
  bool _expanded = false;

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
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(widget.item.imageIcon,
                          style: const TextStyle(fontSize: 28)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.t.tr(widget.item.nameKey),
                            style: const TextStyle(fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Text(widget.t.tr(widget.item.descKey),
                            style: const TextStyle(fontSize: 11,
                                color: AppColors.textSecondary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _Tag(
                              icon: Icons.local_fire_department,
                              text: '${widget.t.tr('calories')}: ${widget.item.calories}',
                              t: widget.t,
                            ),
                            _Tag(
                              icon: Icons.favorite,
                              text: widget.t.tr(widget.item.benefitsKey).split(',').first,
                              t: widget.t,
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
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Color(0xFFF0F4F8), height: 1),
                  const SizedBox(height: 12),
                  // Ingredients
                  Text(widget.t.tr('ingredients'),
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  Text(widget.t.tr(widget.item.ingredientsKey),
                      style: const TextStyle(fontSize: 12,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  // How to prepare
                  Text(widget.t.tr('how_to_make'),
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  Text(widget.t.tr(widget.item.prepKey),
                      style: const TextStyle(fontSize: 12,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  // Benefits
                  Text(widget.t.tr('benefits'),
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  Text(widget.t.tr(widget.item.benefitsKey),
                      style: const TextStyle(fontSize: 12,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  // Best time
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3DE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, size: 14,
                            color: Color(0xFF1D9E75)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('${widget.t.tr('best_time')}: ${_getBestTime(widget.item.category)}',
                              style: const TextStyle(fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1D9E75))),
                        ),
                      ],
                    ),
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

  String _getBestTime(String category) {
    switch (category) {
      case 'Breakfast':
      case 'Diabetes':
        return 'Morning (7-9 AM)';
      case 'Weight Loss':
        return 'Lunch (12-2 PM)';
      case 'Heart Health':
        return 'Evening (6-8 PM)';
      default:
        return 'Any time of day';
    }
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String text;
  final AppTranslations t;
  const _Tag({required this.icon, required this.text, required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Flexible(
            child: Text(text,
                style: const TextStyle(fontSize: 10,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
