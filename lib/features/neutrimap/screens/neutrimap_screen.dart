import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/theme/app_colors.dart';
import '../../../core/translations/tr_extension.dart';

class NeutrimapScreen extends StatefulWidget {
  const NeutrimapScreen({super.key});
  @override
  State<NeutrimapScreen> createState() =>
      _NeutrimapScreenState();
}

class _NeutrimapScreenState
    extends State<NeutrimapScreen> {
  String _selectedCategory = '';
  String _dietPlan         = '';
  bool   _isLoading        = false;
  final _mealLog           = <String>[];
  final _mealCtrl          = TextEditingController();

  final _categories = [
    ('🤰', 'Pregnant',       'Prenatal nutrition'),
    ('🩸', 'Diabetic',       'Blood sugar management'),
    ('💪', 'Fitness',        'Muscle & strength'),
    ('🎖️', 'Defense Prep',  'High endurance'),
    ('❤️', 'Heart Patient',  'Cardiac diet'),
    ('⚖️', 'Weight Loss',    'Calorie deficit'),
    ('👴', 'Senior Citizen', 'Elderly nutrition'),
    ('🧒', 'Child Growth',   'Pediatric diet'),
  ];

  Future<void> _generateDiet(String category) async {
    setState(() {
      _selectedCategory = category;
      _isLoading        = true;
      _dietPlan         = '';
    });

    try {
      const apiKey = 'AIzaSyCn6Fe17Pd1ipAeGv8oM0rcOyEdmtFtlWw';
      final uri = Uri.parse(
        'https://generativelanguage.googleapis.com'
        '/v1beta/models/gemini-2.0-flash'
        ':generateContent?key=$apiKey',
      );

      final body = jsonEncode({
        'contents': [{
          'parts': [{
            'text': 'Create a healthy daily Indian '
                'diet plan for a $category person. '
                'Include breakfast, mid-morning snack, '
                'lunch, evening snack, and dinner. '
                'Include portion sizes and key nutrients. '
                'Keep it practical and affordable. '
                'Format with clear meal sections.',
          }]
        }],
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 500,
        },
      });

      final res = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      ).timeout(const Duration(seconds: 20));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final text = data['candidates'][0]
            ['content']['parts'][0]['text'] as String;
        setState(() {
          _dietPlan = text.trim();
          _isLoading = false;
        });
      } else {
        setState(() {
          _dietPlan = 'Could not generate diet plan. '
              'Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _dietPlan = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _mealCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.navyDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Neutrimap 🥗',
          style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 17)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1,
              color: Colors.white12)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            FadeInDown(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3DE),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Text('🥗',
                        style: TextStyle(
                            fontSize: 28)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text('AI Diet Planner',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF27500A),
                            )),
                          Text(
                            'Select your category for a '
                            'personalised daily diet plan',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF3B6D11),
                            )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Select Your Category',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              )),
            const SizedBox(height: 10),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.2,
              children: _categories.map((cat) {
                final isSelected =
                    _selectedCategory == cat.$2;
                return FadeInUp(
                  child: GestureDetector(
                    onTap: () => _generateDiet(cat.$2),
                    child: AnimatedContainer(
                      duration: const Duration(
                          milliseconds: 200),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.teal
                            : Colors.white,
                        borderRadius:
                            BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.teal
                              : const Color(0xFFE3EAF2),
                          width: isSelected ? 2 : 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(cat.$1,
                              style: const TextStyle(
                                  fontSize: 20)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                              children: [
                                Text(cat.$2,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight:
                                        FontWeight.w700,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors
                                            .textPrimary,
                                  )),
                                Text(cat.$3,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: isSelected
                                        ? Colors.white70
                                        : AppColors
                                            .textHint,
                                  )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            if (_isLoading) ...[
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(
                        color: AppColors.teal),
                    SizedBox(height: 12),
                    Text('Generating your diet plan...',
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14)),
                  ],
                ),
              ),
            ] else if (_dietPlan.isNotEmpty) ...[
              FadeInUp(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(16),
                    border: Border.all(
                        color: const Color(0xFFE3EAF2),
                        width: 0.5),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                              Icons.restaurant_rounded,
                              color: AppColors.teal,
                              size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Diet Plan for '
                            '$_selectedCategory',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            )),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(
                          color: Color(0xFFE3EAF2)),
                      const SizedBox(height: 12),
                      Text(_dietPlan,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                          height: 1.7,
                        )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Meal logging
              FadeInUp(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(14),
                    border: Border.all(
                        color: const Color(0xFFE3EAF2),
                        width: 0.5),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text('Log Your Meals',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        )),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _mealCtrl,
                              style: const TextStyle(
                                  fontSize: 13),
                              decoration:
                                  InputDecoration(
                                hintText:
                                    'What did you eat?',
                                hintStyle: const TextStyle(
                                    color: AppColors
                                        .textHint,
                                    fontSize: 13),
                                filled: true,
                                fillColor:
                                    AppColors.bgPage,
                                border:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(10),
                                  borderSide:
                                      BorderSide.none,
                                ),
                                contentPadding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              if (_mealCtrl.text
                                  .isNotEmpty) {
                                setState(() {
                                  _mealLog.add(
                                    '${TimeOfDay.now().format(context)}'
                                    ' — ${_mealCtrl.text}',
                                  );
                                  _mealCtrl.clear();
                                });
                              }
                            },
                            child: Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.teal,
                                borderRadius:
                                    BorderRadius.circular(
                                        10),
                              ),
                              child: const Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                  size: 20),
                            ),
                          ),
                        ],
                      ),
                      if (_mealLog.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ..._mealLog.reversed.take(5)
                            .map((m) => Padding(
                          padding:
                              const EdgeInsets.only(
                                  bottom: 6),
                          child: Row(
                            children: [
                              const Icon(
                                  Icons
                                      .restaurant_rounded,
                                  size: 14,
                                  color:
                                      AppColors.teal),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(m,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors
                                        .textPrimary,
                                  ))),
                            ],
                          ),
                        )),
                      ],
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
