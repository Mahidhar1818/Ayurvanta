import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:math' as math;

// ── Colors ────────────────────────────────────────────────
class _C {
  static const navy     = Color(0xFF0B1A2C);
  static const navyMid  = Color(0xFF1A2E44);
  static const teal     = Color(0xFF1D9E75);
  static const tealL    = Color(0xFFEAF3DE);
  static const blue     = Color(0xFF185FA5);
  static const blueL    = Color(0xFFE6F1FB);
  static const bg       = Color(0xFFF4F7FB);
  static const muted    = Color(0xFFE3EAF2);
  static const text     = Color(0xFF1A2E44);
  static const textSec  = Color(0xFF6B8099);
  static const textHint = Color(0xFF8BAED4);
  static const danger   = Color(0xFFE8243A);
  static const orange   = Color(0xFFBA7517);
  static const orangeL  = Color(0xFFFAEEDA);
  static const purple   = Color(0xFF534AB7);
  static const purpleL  = Color(0xFFEEEDFE);
  static const pink     = Color(0xFFD4537E);
  static const pinkL    = Color(0xFFFBEAF0);
  static const green    = Color(0xFF3B6D11);
  static const greenL   = Color(0xFFEAF3DE);
}

// ════════════════════════════════════════════════════════════
// SYMPTOM CATEGORY MODEL — with background image
// ════════════════════════════════════════════════════════════
class SymptomCat {
  final String id, label, emoji, hint, imageUrl;
  final Color gradientStart, gradientEnd;
  final String dietCategory; // links to diet map

  const SymptomCat({
    required this.id,
    required this.label,
    required this.emoji,
    required this.hint,
    required this.imageUrl,
    required this.gradientStart,
    required this.gradientEnd,
    required this.dietCategory,
  });
}

const _symptomCats = [
  SymptomCat(
    id: 'fever',
    label: 'Fever / Cold',
    emoji: '🤒',
    hint: 'High temperature, chills, runny nose, body ache',
    imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400&q=80',
    gradientStart: Color(0xFFE8593C),
    gradientEnd: Color(0xFFBF3620),
    dietCategory: 'immunity',
  ),
  SymptomCat(
    id: 'chest',
    label: 'Chest Pain',
    emoji: '💔',
    hint: 'Tightness, pressure, pain in chest or left arm',
    imageUrl: 'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=400&q=80',
    gradientStart: Color(0xFFE24B4A),
    gradientEnd: Color(0xFF991F1E),
    dietCategory: 'cardiac',
  ),
  SymptomCat(
    id: 'headache',
    label: 'Headache',
    emoji: '🤕',
    hint: 'Migraine, tension headache, dizziness',
    imageUrl: 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=400&q=80',
    gradientStart: Color(0xFF534AB7),
    gradientEnd: Color(0xFF3A3489),
    dietCategory: 'brain',
  ),
  SymptomCat(
    id: 'stomach',
    label: 'Stomach / GI',
    emoji: '🫃',
    hint: 'Nausea, vomiting, diarrhoea, abdominal pain',
    imageUrl: 'https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=400&q=80',
    gradientStart: Color(0xFF1D9E75),
    gradientEnd: Color(0xFF0F6E56),
    dietCategory: 'digestive',
  ),
  SymptomCat(
    id: 'breathing',
    label: 'Breathing',
    emoji: '🫁',
    hint: 'Shortness of breath, wheezing, cough',
    imageUrl: 'https://images.unsplash.com/photo-1545205597-3d9d02c29597?w=400&q=80',
    gradientStart: Color(0xFF185FA5),
    gradientEnd: Color(0xFF0C447C),
    dietCategory: 'respiratory',
  ),
  SymptomCat(
    id: 'injury',
    label: 'Injury / Wound',
    emoji: '🩹',
    hint: 'Cut, bruise, sprain, fracture, burn',
    imageUrl: 'https://images.unsplash.com/photo-1581594693702-fbdc51b2763b?w=400&q=80',
    gradientStart: Color(0xFFBA7517),
    gradientEnd: Color(0xFF854F0B),
    dietCategory: 'healing',
  ),
  SymptomCat(
    id: 'skin',
    label: 'Skin Issue',
    emoji: '🧴',
    hint: 'Rash, itching, redness, swelling',
    imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=400&q=80',
    gradientStart: Color(0xFFD4537E),
    gradientEnd: Color(0xFF993556),
    dietCategory: 'skin',
  ),
  SymptomCat(
    id: 'bones',
    label: 'Joint / Bone',
    emoji: '🦴',
    hint: 'Joint pain, back pain, stiffness',
    imageUrl: 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&q=80',
    gradientStart: Color(0xFF7F77DD),
    gradientEnd: Color(0xFF534AB7),
    dietCategory: 'bone',
  ),
  SymptomCat(
    id: 'diabetes',
    label: 'Diabetes',
    emoji: '🩸',
    hint: 'High/low blood sugar, frequent urination, fatigue',
    imageUrl: 'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?w=400&q=80',
    gradientStart: Color(0xFF639922),
    gradientEnd: Color(0xFF3B6D11),
    dietCategory: 'diabetes',
  ),
  SymptomCat(
    id: 'child',
    label: 'Child Health',
    emoji: '👶',
    hint: 'Paediatric concern, growth, vaccination',
    imageUrl: 'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=400&q=80',
    gradientStart: Color(0xFFF2A623),
    gradientEnd: Color(0xFFBA7517),
    dietCategory: 'child',
  ),
  SymptomCat(
    id: 'women',
    label: "Women's Health",
    emoji: '🌸',
    hint: 'Gynaecology, pregnancy, menstrual issues',
    imageUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=400&q=80',
    gradientStart: Color(0xFFED93B1),
    gradientEnd: Color(0xFFD4537E),
    dietCategory: 'women',
  ),
  SymptomCat(
    id: 'general',
    label: 'General Health',
    emoji: '💊',
    hint: 'Other health concern not listed above',
    imageUrl: 'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?w=400&q=80',
    gradientStart: Color(0xFF4A6080),
    gradientEnd: Color(0xFF1A2E44),
    dietCategory: 'general',
  ),
];

// ════════════════════════════════════════════════════════════
// DIET PLAN MODEL — ICMR 2024
// ════════════════════════════════════════════════════════════
class DietPlan {
  final String id, title, subtitle, emoji, sourceLabel;
  final Color color, bgColor;
  final List<DietMeal> meals;
  final List<DietRule> rules;
  final List<FoodGroup> foodGroups;
  final List<String> avoidFoods;
  final String dailyCalories, officialSource;

  const DietPlan({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.sourceLabel,
    required this.color,
    required this.bgColor,
    required this.meals,
    required this.rules,
    required this.foodGroups,
    required this.avoidFoods,
    required this.dailyCalories,
    required this.officialSource,
  });
}

class DietMeal {
  final String time, name, items;
  final String emoji;
  const DietMeal({required this.time, required this.name, required this.items, required this.emoji});
}

class DietRule {
  final String emoji, rule;
  const DietRule({required this.emoji, required this.rule});
}

class FoodGroup {
  final String name, serving, examples, emoji;
  final Color color;
  const FoodGroup({required this.name, required this.serving, required this.examples, required this.emoji, required this.color});
}

// ── Diet Plans Database (ICMR 2024) ───────────────────────
final Map<String, DietPlan> _dietPlans = {

  'cardiac': DietPlan(
    id: 'cardiac',
    title: 'Heart-Healthy Diet',
    subtitle: 'ICMR 2024 · Cardiac Care',
    emoji: '❤️',
    sourceLabel: 'Based on ICMR-NIN Dietary Guidelines 2024',
    color: _C.danger,
    bgColor: const Color(0xFFFCEBEB),
    dailyCalories: '1800–2000 kcal',
    officialSource: 'https://main.icmr.nic.in',
    meals: [
      DietMeal(time: '7:00 AM', name: 'Early Morning', items: '1 glass warm water + 5 soaked almonds + 2 walnuts', emoji: '🌅'),
      DietMeal(time: '8:30 AM', name: 'Breakfast', items: '2 oats idli / 1 cup oatmeal porridge + 1 glass skimmed milk + 1 fruit (banana/apple)', emoji: '🍽️'),
      DietMeal(time: '11:00 AM', name: 'Mid-Morning', items: '1 seasonal fruit + 1 cup green tea (no sugar)', emoji: '🍎'),
      DietMeal(time: '1:00 PM', name: 'Lunch', items: '2 rotis (whole wheat) + 1 cup dal + 1 cup sabzi + salad + 1 small bowl curd', emoji: '🫓'),
      DietMeal(time: '4:00 PM', name: 'Evening Snack', items: '1 cup sprouts chaat / roasted chana + 1 cup buttermilk (low fat)', emoji: '☕'),
      DietMeal(time: '7:30 PM', name: 'Dinner', items: '1½ cups brown rice / 2 rotis + 1 cup mixed vegetable curry + 1 cup dal soup', emoji: '🥗'),
      DietMeal(time: '9:30 PM', name: 'Bedtime', items: '1 glass warm skimmed milk (no sugar)', emoji: '🌙'),
    ],
    rules: [
      DietRule(emoji: '✅', rule: 'Use mustard/olive oil — max 15–20 ml/day (ICMR 2024)'),
      DietRule(emoji: '✅', rule: 'Eat 400–500g vegetables + 100g fruits daily'),
      DietRule(emoji: '✅', rule: 'Choose whole grains: brown rice, oats, millets (jowar/bajra)'),
      DietRule(emoji: '✅', rule: 'Include fatty fish (rohu, katla) 2–3 times/week for omega-3'),
      DietRule(emoji: '⚠️', rule: 'Limit salt to < 5g/day (1 tsp) — ICMR strict guideline'),
      DietRule(emoji: '⚠️', rule: 'Restrict saturated fat — avoid ghee, butter, coconut oil in excess'),
      DietRule(emoji: '🚫', rule: 'No fried foods, packaged snacks, processed meats'),
      DietRule(emoji: '🚫', rule: 'No full-fat dairy, red meat more than once a week'),
    ],
    foodGroups: [
      FoodGroup(name: 'Cereals & Millets', serving: '6–8 servings/day', examples: 'Brown rice, whole wheat, jowar, bajra, oats', emoji: '🌾', color: _C.orange),
      FoodGroup(name: 'Vegetables', serving: '5+ servings/day', examples: 'Leafy greens, tomato, carrot, beans, broccoli', emoji: '🥦', color: _C.green),
      FoodGroup(name: 'Pulses & Legumes', serving: '2–3 servings/day', examples: 'Dal, rajma, chana, moong, lentils', emoji: '🫘', color: _C.teal),
      FoodGroup(name: 'Lean Protein', serving: '1–2 servings/day', examples: 'Fish, egg white, low-fat paneer, tofu', emoji: '🐟', color: _C.blue),
      FoodGroup(name: 'Low-fat Dairy', serving: '2 servings/day', examples: 'Skimmed milk, low-fat curd, buttermilk', emoji: '🥛', color: _C.textSec),
      FoodGroup(name: 'Fruits', serving: '2–3 servings/day', examples: 'Apple, guava, papaya, banana (small)', emoji: '🍎', color: _C.pink),
      FoodGroup(name: 'Nuts & Seeds', serving: '1 small handful', examples: 'Almonds, walnuts, flaxseeds (heart-protective)', emoji: '🥜', color: _C.orange),
    ],
    avoidFoods: ['Fried snacks (samosa, pakoda)', 'Full-fat dairy & ghee excess', 'Coconut oil in large amounts', 'Red meat (mutton, pork)', 'Sugary drinks & sweets', 'Packaged/processed foods', 'Refined flour (maida) products'],
  ),

  'diabetes': DietPlan(
    id: 'diabetes',
    title: 'Diabetes Diet',
    subtitle: 'ICMR 2024 · Blood Sugar Control',
    emoji: '🩸',
    sourceLabel: 'ICMR-NIN 2024 + ADA Guidelines',
    color: _C.green,
    bgColor: _C.greenL,
    dailyCalories: '1600–1800 kcal',
    officialSource: 'https://www.nin.res.in',
    meals: [
      DietMeal(time: '6:30 AM', name: 'Early Morning', items: 'Methi seeds water (overnight soaked) + 1 small fruit / 10 almonds', emoji: '🌅'),
      DietMeal(time: '8:00 AM', name: 'Breakfast', items: '2 moong dal chilla / 1 cup oatmeal + 1 cup buttermilk (no sugar)', emoji: '🍽️'),
      DietMeal(time: '11:00 AM', name: 'Mid-Morning', items: '1 small fruit (guava/papaya) + 1 cup green tea (no sugar)', emoji: '🍈'),
      DietMeal(time: '1:00 PM', name: 'Lunch', items: '2 whole wheat rotis + 1 cup vegetable sabzi + 1 cup dal + salad (cucumber, tomato)', emoji: '🫓'),
      DietMeal(time: '4:00 PM', name: 'Evening Snack', items: '1 cup roasted chana / 1 small bowl sprouts / 1 boiled egg', emoji: '☕'),
      DietMeal(time: '7:00 PM', name: 'Dinner', items: '2 bajra/jowar rotis + 1 cup mixed veg + 1 cup dal (light) — eat early!', emoji: '🥗'),
      DietMeal(time: '9:00 PM', name: 'Bedtime', items: '1 cup warm low-fat milk with pinch of turmeric', emoji: '🌙'),
    ],
    rules: [
      DietRule(emoji: '✅', rule: 'Eat every 3–4 hours — never skip meals (prevents sugar crash)'),
      DietRule(emoji: '✅', rule: 'Choose low-GI foods: millets, whole grains, legumes'),
      DietRule(emoji: '✅', rule: 'Half plate = non-starchy vegetables at every meal'),
      DietRule(emoji: '✅', rule: 'Include 30 min walking after meals — reduces post-meal spike'),
      DietRule(emoji: '⚠️', rule: 'Limit rice to ½ cup (cooked) per meal — switch to millets'),
      DietRule(emoji: '⚠️', rule: 'Monitor portion sizes — use a smaller plate (ICMR 2024)'),
      DietRule(emoji: '🚫', rule: 'No sugary drinks, fruit juices, sweets, honey, jaggery in excess'),
      DietRule(emoji: '🚫', rule: 'No white bread, maida, polished rice, potatoes in excess'),
    ],
    foodGroups: [
      FoodGroup(name: 'Millets (Best Choice)', serving: '3–4 servings/day', examples: 'Jowar, bajra, ragi, foxtail millet — low GI', emoji: '🌾', color: _C.orange),
      FoodGroup(name: 'Non-starchy Vegetables', serving: '5+ servings/day', examples: 'Bitter gourd, spinach, beans, broccoli, methi', emoji: '🥦', color: _C.green),
      FoodGroup(name: 'Protein (High Priority)', serving: '3–4 servings/day', examples: 'Dal, rajma, paneer (low fat), egg, chicken (grilled)', emoji: '🫘', color: _C.blue),
      FoodGroup(name: 'Fruits (Limited)', serving: '1–2 servings/day', examples: 'Guava, papaya, apple — avoid mango/banana in excess', emoji: '🍈', color: _C.teal),
      FoodGroup(name: 'Low-fat Dairy', serving: '2 servings/day', examples: 'Skimmed milk, low-fat curd (best taken at meals)', emoji: '🥛', color: _C.textSec),
      FoodGroup(name: 'Healthy Fats', serving: '2–3 tsp/day', examples: 'Mustard oil, flaxseeds, walnuts — avoid excess', emoji: '🫒', color: _C.orange),
    ],
    avoidFoods: ['White rice (polished)', 'White bread & maida products', 'Sugary drinks & fruit juices', 'Sweets, mithai, jaggery excess', 'Fried foods of any kind', 'Sweet fruits in excess (mango, grapes, banana)', 'Starchy vegetables excess (potato, yam)'],
  ),

  'immunity': DietPlan(
    id: 'immunity',
    title: 'Immunity Boost Diet',
    subtitle: 'ICMR 2024 · Fever & Cold Recovery',
    emoji: '🛡️',
    sourceLabel: 'ICMR-NIN 2024 Dietary Guidelines',
    color: _C.danger,
    bgColor: const Color(0xFFFCEBEB),
    dailyCalories: '1800–2200 kcal',
    officialSource: 'https://main.icmr.nic.in',
    meals: [
      DietMeal(time: '7:00 AM', name: 'Early Morning', items: '1 glass warm water + turmeric + ginger + honey + lemon', emoji: '🌅'),
      DietMeal(time: '8:30 AM', name: 'Breakfast', items: '1 cup daliya/khichdi (easy to digest) + 1 glass warm milk with turmeric', emoji: '🍽️'),
      DietMeal(time: '11:00 AM', name: 'Mid-Morning', items: '1 orange / amla juice + 5 soaked almonds', emoji: '🍊'),
      DietMeal(time: '1:00 PM', name: 'Lunch', items: 'Light moong dal khichdi + cooked vegetables + 1 cup curd (probiotics)', emoji: '🫓'),
      DietMeal(time: '4:00 PM', name: 'Evening', items: '1 cup adrak-tulsi kadha / warm soup (tomato/chicken) + 1 fruit', emoji: '☕'),
      DietMeal(time: '7:00 PM', name: 'Dinner', items: 'Warm vegetable soup + 2 soft rotis + light dal — keep it easy to digest', emoji: '🥗'),
      DietMeal(time: '9:00 PM', name: 'Bedtime', items: 'Haldi doodh (turmeric milk) — proven anti-inflammatory', emoji: '🌙'),
    ],
    rules: [
      DietRule(emoji: '✅', rule: 'Hydrate heavily — 8–10 glasses water/day (extra during fever)'),
      DietRule(emoji: '✅', rule: 'Vitamin C foods: amla, guava, orange, lemon every day'),
      DietRule(emoji: '✅', rule: 'Zinc foods: pumpkin seeds, chickpeas, sesame — boosts immunity'),
      DietRule(emoji: '✅', rule: 'Probiotics: curd, buttermilk — strengthens gut immunity'),
      DietRule(emoji: '⚠️', rule: 'Eat small meals frequently — fever reduces appetite'),
      DietRule(emoji: '⚠️', rule: 'Rest the gut — avoid heavy, fried or spicy foods'),
      DietRule(emoji: '🚫', rule: 'No cold drinks, ice cream, refrigerated foods during fever'),
      DietRule(emoji: '🚫', rule: 'No spicy, oily, heavy foods — hard on the system'),
    ],
    foodGroups: [
      FoodGroup(name: 'Vitamin C Foods', serving: '3–4 servings/day', examples: 'Amla (highest Vit C), guava, orange, lemon, capsicum', emoji: '🍊', color: _C.orange),
      FoodGroup(name: 'Easy Carbs', serving: '4–5 servings/day', examples: 'Daliya, khichdi, soft rice, oatmeal — easily digestible', emoji: '🌾', color: _C.orange),
      FoodGroup(name: 'Immune Boosters', serving: 'Daily use', examples: 'Ginger, turmeric, garlic, tulsi, black pepper', emoji: '🧄', color: _C.teal),
      FoodGroup(name: 'Probiotics', serving: '2 servings/day', examples: 'Fresh curd, buttermilk (room temp, not cold)', emoji: '🥛', color: _C.textSec),
      FoodGroup(name: 'Protein (Light)', serving: '2 servings/day', examples: 'Moong dal, egg, light chicken soup — tissue repair', emoji: '🫘', color: _C.blue),
      FoodGroup(name: 'Fluids', serving: '10+ cups/day', examples: 'Water, ORS, coconut water, warm soups, herbal teas', emoji: '💧', color: _C.blue),
    ],
    avoidFoods: ['Cold drinks & ice water', 'Fried & oily foods', 'Spicy curries & pickles', 'Red meat (heavy to digest)', 'Sweets & sugar excess', 'Caffeinated beverages in excess', 'Refrigerated/cold foods'],
  ),

  'digestive': DietPlan(
    id: 'digestive',
    title: 'Digestive Health Diet',
    subtitle: 'ICMR 2024 · Gut & GI Care',
    emoji: '🌿',
    sourceLabel: 'ICMR-NIN 2024 Dietary Guidelines',
    color: _C.teal,
    bgColor: _C.tealL,
    dailyCalories: '1800–2000 kcal',
    officialSource: 'https://main.icmr.nic.in',
    meals: [
      DietMeal(time: '7:00 AM', name: 'Early Morning', items: '1 glass warm water with lemon (stimulates digestion) + 5 almonds', emoji: '🌅'),
      DietMeal(time: '8:30 AM', name: 'Breakfast', items: '1 bowl daliya/oatmeal porridge + 1 banana (pectin for gut health) + 1 cup warm herbal tea', emoji: '🍽️'),
      DietMeal(time: '11:00 AM', name: 'Mid-Morning', items: '1 cup fresh curd (probiotic) + 1 small guava/papaya', emoji: '🥣'),
      DietMeal(time: '1:00 PM', name: 'Lunch', items: '2 whole wheat rotis + 1 cup moong dal + steamed vegetables + salad (no raw onion)', emoji: '🫓'),
      DietMeal(time: '4:00 PM', name: 'Evening', items: '1 cup jeera/ajwain water + 1 cup roasted makhana / light namkeen', emoji: '☕'),
      DietMeal(time: '7:00 PM', name: 'Dinner', items: 'Light vegetable khichdi / 2 rotis + dal + sabzi (no spicy) — eat 2 hrs before bed', emoji: '🥗'),
      DietMeal(time: '9:00 PM', name: 'Bedtime', items: 'Warm water with ajwain / 1 cup warm diluted curd', emoji: '🌙'),
    ],
    rules: [
      DietRule(emoji: '✅', rule: 'Eat slowly, chew 20–30 times — aids digestion significantly'),
      DietRule(emoji: '✅', rule: 'High fibre: 25–35g/day from whole grains, vegetables, legumes'),
      DietRule(emoji: '✅', rule: 'Probiotics daily: curd, buttermilk (at room temperature)'),
      DietRule(emoji: '✅', rule: 'Drink 8–10 glasses water — prevents constipation'),
      DietRule(emoji: '⚠️', rule: 'Small frequent meals — do not overeat at one sitting'),
      DietRule(emoji: '⚠️', rule: 'Avoid drinking water immediately before/after meals'),
      DietRule(emoji: '🚫', rule: 'No very spicy, oily, fried or heavy foods'),
      DietRule(emoji: '🚫', rule: 'No carbonated drinks, alcohol, excess coffee/tea'),
    ],
    foodGroups: [
      FoodGroup(name: 'Fibre-rich Cereals', serving: '5–6 servings/day', examples: 'Whole wheat, oats, brown rice, daliya, millets', emoji: '🌾', color: _C.orange),
      FoodGroup(name: 'Probiotics', serving: '2–3 servings/day', examples: 'Fresh curd, buttermilk, fermented foods (idli/dosa)', emoji: '🥛', color: _C.textSec),
      FoodGroup(name: 'Gut-friendly Fruits', serving: '2–3 servings/day', examples: 'Papaya (papain enzyme), banana, apple, pomegranate', emoji: '🍌', color: _C.pink),
      FoodGroup(name: 'Vegetables', serving: '4–5 servings/day', examples: 'Bottle gourd, pumpkin, spinach, beans (cooked)', emoji: '🥦', color: _C.green),
      FoodGroup(name: 'Light Proteins', serving: '2 servings/day', examples: 'Moong dal, egg, tofu, steamed fish', emoji: '🫘', color: _C.blue),
      FoodGroup(name: 'Digestive Spices', serving: 'Daily', examples: 'Jeera, ajwain, ginger, coriander, turmeric', emoji: '🧄', color: _C.teal),
    ],
    avoidFoods: ['Fried & greasy foods', 'Very spicy curries', 'Carbonated drinks', 'Processed & packaged foods', 'Excess coffee/tea', 'Raw salads during acute illness', 'Dairy excess (if intolerant)'],
  ),

  'bone': DietPlan(
    id: 'bone',
    title: 'Bone & Joint Diet',
    subtitle: 'ICMR 2024 · Orthopaedic Support',
    emoji: '🦴',
    sourceLabel: 'ICMR-NIN 2024 · Orthopaedic Nutrition',
    color: _C.purple,
    bgColor: _C.purpleL,
    dailyCalories: '2000–2200 kcal',
    officialSource: 'https://main.icmr.nic.in',
    meals: [
      DietMeal(time: '7:00 AM', name: 'Early Morning', items: '1 glass warm milk + 5 soaked almonds + 2 walnuts (anti-inflammatory)', emoji: '🌅'),
      DietMeal(time: '8:30 AM', name: 'Breakfast', items: '2 ragi rotis (highest calcium grain) + 1 cup paneer bhurji + 1 glass milk', emoji: '🍽️'),
      DietMeal(time: '11:00 AM', name: 'Mid-Morning', items: '1 orange (Vitamin C for collagen) + 5–6 walnuts', emoji: '🍊'),
      DietMeal(time: '1:00 PM', name: 'Lunch', items: '2 rotis + 1 cup rajma/chana (calcium) + 1 cup palak sabzi + curd', emoji: '🫓'),
      DietMeal(time: '4:00 PM', name: 'Evening', items: '1 cup sesame seeds chikki / til ladoo (high calcium) + green tea', emoji: '☕'),
      DietMeal(time: '7:30 PM', name: 'Dinner', items: '2 rotis + 1 cup dal with green veg + 1 cup curd or paneer', emoji: '🥗'),
      DietMeal(time: '9:30 PM', name: 'Bedtime', items: '1 glass warm milk with turmeric (anti-inflammatory + calcium)', emoji: '🌙'),
    ],
    rules: [
      DietRule(emoji: '✅', rule: 'Calcium 1000–1200 mg/day: milk, ragi, sesame, green leafy'),
      DietRule(emoji: '✅', rule: 'Vitamin D: 10–15 min morning sunlight daily (ICMR strongly recommends)'),
      DietRule(emoji: '✅', rule: 'Vitamin C daily (amla/orange): builds collagen for joints'),
      DietRule(emoji: '✅', rule: 'Omega-3 (anti-inflammatory): fish 2×/week, walnuts, flaxseeds'),
      DietRule(emoji: '⚠️', rule: 'Avoid excess salt — leaches calcium from bones'),
      DietRule(emoji: '⚠️', rule: 'Limit tea/coffee with meals — reduces calcium absorption'),
      DietRule(emoji: '🚫', rule: 'No alcohol, carbonated drinks — reduce bone mineral density'),
      DietRule(emoji: '🚫', rule: 'No crash dieting — malnutrition weakens bone matrix'),
    ],
    foodGroups: [
      FoodGroup(name: 'Calcium Foods', serving: '4–5 servings/day', examples: 'Milk, ragi, sesame (til), amaranth, green leafy veg', emoji: '🥛', color: _C.blue),
      FoodGroup(name: 'Vitamin D Foods', serving: 'Daily', examples: 'Fatty fish (rohu), egg yolk, fortified milk + sunlight', emoji: '☀️', color: _C.orange),
      FoodGroup(name: 'Anti-inflammatory', serving: '2–3 servings/day', examples: 'Walnuts, flaxseeds, fatty fish, turmeric, ginger', emoji: '🐟', color: _C.teal),
      FoodGroup(name: 'Collagen Builders', serving: '2 servings/day', examples: 'Amla, citrus fruits, bell peppers (Vitamin C)', emoji: '🍊', color: _C.orange),
      FoodGroup(name: 'Protein', serving: '3 servings/day', examples: 'Dal, paneer, egg, fish — builds bone & muscle matrix', emoji: '🫘', color: _C.purple),
      FoodGroup(name: 'Magnesium Foods', serving: 'Daily', examples: 'Dark leafy greens, seeds, legumes, nuts (bone health)', emoji: '🥦', color: _C.green),
    ],
    avoidFoods: ['Excess salt & salty snacks', 'Carbonated drinks (cola)', 'Alcohol', 'Excess coffee/tea at meals', 'Processed foods high in phosphate', 'Crash diets / severe calorie restriction'],
  ),

  'brain': DietPlan(
    id: 'brain',
    title: 'Brain & Neuro Diet',
    subtitle: 'ICMR 2024 · Headache & Neuro Support',
    emoji: '🧠',
    sourceLabel: 'ICMR-NIN 2024 · Neurological Nutrition',
    color: _C.purple,
    bgColor: _C.purpleL,
    dailyCalories: '2000–2200 kcal',
    officialSource: 'https://main.icmr.nic.in',
    meals: [
      DietMeal(time: '7:00 AM', name: 'Early Morning', items: '1 glass water + 5 soaked walnuts (DHA for brain)', emoji: '🌅'),
      DietMeal(time: '8:30 AM', name: 'Breakfast', items: '1 cup oatmeal + 1 egg (choline for brain) + 1 glass milk + banana', emoji: '🍽️'),
      DietMeal(time: '11:00 AM', name: 'Mid-Morning', items: '1 cup blueberries/pomegranate + 1 cup green tea (L-theanine)', emoji: '🍇'),
      DietMeal(time: '1:00 PM', name: 'Lunch', items: '2 whole wheat rotis + 1 cup palak dal (folate) + 1 cup curd + salad', emoji: '🫓'),
      DietMeal(time: '4:00 PM', name: 'Evening', items: '1 handful mixed nuts (walnuts, almonds) + 1 dark chocolate square', emoji: '☕'),
      DietMeal(time: '7:30 PM', name: 'Dinner', items: '2 rotis + grilled/baked fish or paneer + 1 cup cooked vegetables', emoji: '🥗'),
      DietMeal(time: '9:30 PM', name: 'Bedtime', items: '1 glass warm milk with ashwagandha (stress & sleep support)', emoji: '🌙'),
    ],
    rules: [
      DietRule(emoji: '✅', rule: 'Omega-3 (DHA/EPA): fish 2–3×/week, walnuts daily — brain fuel'),
      DietRule(emoji: '✅', rule: 'Stay hydrated — even mild dehydration triggers headache'),
      DietRule(emoji: '✅', rule: 'Regular meal timing — blood sugar dips trigger migraines'),
      DietRule(emoji: '✅', rule: 'Magnesium-rich foods: nuts, seeds, dark chocolate — prevents migraines'),
      DietRule(emoji: '⚠️', rule: 'Limit caffeine to 1–2 cups/day — withdrawal causes headaches'),
      DietRule(emoji: '⚠️', rule: 'Keep a food diary — identify personal migraine triggers'),
      DietRule(emoji: '🚫', rule: 'No alcohol (common migraine trigger)'),
      DietRule(emoji: '🚫', rule: 'No processed foods with MSG, nitrates (sausages, chips)'),
    ],
    foodGroups: [
      FoodGroup(name: 'Brain Fats (Omega-3)', serving: '2–3 servings/day', examples: 'Fatty fish, walnuts, flaxseeds, chia seeds', emoji: '🐟', color: _C.blue),
      FoodGroup(name: 'Antioxidants', serving: '3–4 servings/day', examples: 'Berries, amla, dark chocolate, colourful veg', emoji: '🍇', color: _C.purple),
      FoodGroup(name: 'B-Vitamins', serving: 'Daily', examples: 'Eggs, dal, whole grains, meat, milk (B12, folate)', emoji: '🥚', color: _C.orange),
      FoodGroup(name: 'Magnesium', serving: '2 servings/day', examples: 'Almonds, pumpkin seeds, dark chocolate, spinach', emoji: '🥜', color: _C.teal),
      FoodGroup(name: 'Complex Carbs', serving: '4–5 servings/day', examples: 'Oats, whole wheat, millets — steady glucose for brain', emoji: '🌾', color: _C.orange),
      FoodGroup(name: 'Water', serving: '10+ glasses', examples: 'Water, coconut water, herbal teas — dehydration = headache', emoji: '💧', color: _C.blue),
    ],
    avoidFoods: ['Alcohol', 'MSG (monosodium glutamate)', 'Processed meats (nitrates)', 'Artificial sweeteners (aspartame)', 'Skipping meals', 'Excess caffeine', 'Aged cheese (tyramine)'],
  ),

  'general': DietPlan(
    id: 'general',
    title: 'Balanced Indian Diet',
    subtitle: 'ICMR 2024 · My Plate for the Day',
    emoji: '🍽️',
    sourceLabel: 'ICMR-NIN 2024 — 17 Dietary Guidelines for Indians',
    color: _C.blue,
    bgColor: _C.blueL,
    dailyCalories: '2000 kcal (sedentary adult, 65 kg)',
    officialSource: 'https://main.icmr.nic.in',
    meals: [
      DietMeal(time: '7:00 AM', name: 'Early Morning', items: '1 glass warm water + 5 soaked almonds or 2 walnuts', emoji: '🌅'),
      DietMeal(time: '8:30 AM', name: 'Breakfast', items: '2 idli + sambar / 2 whole wheat paratha + curd + 1 glass milk + 1 fruit', emoji: '🍽️'),
      DietMeal(time: '11:00 AM', name: 'Mid-Morning', items: '1 seasonal fruit + 1 cup buttermilk / green tea', emoji: '🍎'),
      DietMeal(time: '1:30 PM', name: 'Lunch', items: '2 rotis + 1 cup dal + 1 cup sabzi + 1 cup curd + salad (50% plate = veg)', emoji: '🫓'),
      DietMeal(time: '4:30 PM', name: 'Evening Snack', items: '1 cup sprouts / roasted chana / handful mixed nuts + 1 cup tea', emoji: '☕'),
      DietMeal(time: '8:00 PM', name: 'Dinner', items: '2 rotis / 1 cup brown rice + 1 cup dal + 1 cup vegetable + salad (light)', emoji: '🥗'),
      DietMeal(time: '10:00 PM', name: 'Bedtime (optional)', items: '1 glass warm milk — only if hungry', emoji: '🌙'),
    ],
    rules: [
      DietRule(emoji: '✅', rule: 'Eat 400–500g vegetables + 100g fruits daily (ICMR 2024)'),
      DietRule(emoji: '✅', rule: 'Choose whole grains over refined: millets, whole wheat, brown rice'),
      DietRule(emoji: '✅', rule: 'My Plate: 50% vegetables, 25% cereals, 15% pulses, 10% dairy + fat'),
      DietRule(emoji: '✅', rule: 'Use variety of cooking oils — do not stick to only one type'),
      DietRule(emoji: '✅', rule: 'Exercise 30 min daily — walking, yoga, cycling'),
      DietRule(emoji: '⚠️', rule: 'Limit salt < 5g/day (1 tsp total from all sources)'),
      DietRule(emoji: '⚠️', rule: 'Limit added sugar < 10% of daily calories (< 50g/day)'),
      DietRule(emoji: '🚫', rule: 'No ultra-processed foods — read food labels carefully'),
      DietRule(emoji: '🚫', rule: 'No protein supplements unless medically prescribed'),
    ],
    foodGroups: [
      FoodGroup(name: 'Cereals & Millets', serving: '6–8 servings/day', examples: 'Rice, wheat, jowar, bajra, ragi, oats, maize', emoji: '🌾', color: _C.orange),
      FoodGroup(name: 'Pulses & Legumes', serving: '2–3 servings/day', examples: 'All dals, rajma, chana, lentils, soybeans', emoji: '🫘', color: _C.teal),
      FoodGroup(name: 'Vegetables (priority)', serving: '5+ servings/day', examples: '3 types minimum — 1 must be dark leafy green', emoji: '🥦', color: _C.green),
      FoodGroup(name: 'Fruits', serving: '2–3 servings/day', examples: 'Any 2 seasonal fruits — vary types for micronutrients', emoji: '🍎', color: _C.pink),
      FoodGroup(name: 'Milk & Dairy', serving: '2–3 servings/day', examples: 'Milk, curd, paneer, buttermilk, cheese', emoji: '🥛', color: _C.textSec),
      FoodGroup(name: 'Oils, Nuts & Seeds', serving: '3–4 tsp oil + 1 handful nuts', examples: 'Use variety: mustard, groundnut, sesame, coconut', emoji: '🫒', color: _C.orange),
      FoodGroup(name: 'Non-veg (optional)', serving: '2–3 times/week', examples: 'Egg (whole), fish, chicken (lean cuts only)', emoji: '🐟', color: _C.blue),
    ],
    avoidFoods: ['Ultra-processed packaged snacks', 'Sugary beverages (cola, juices)', 'Excess salt in cooking', 'Refined flour (maida) excess', 'Fried foods daily', 'Protein powders/supplements (unnecessary)', 'Alcohol'],
  ),

  'respiratory': DietPlan(
    id: 'respiratory',
    title: 'Respiratory Diet',
    subtitle: 'ICMR 2024 · Lung & Breathing Support',
    emoji: '🫁',
    sourceLabel: 'ICMR-NIN 2024 Guidelines',
    color: _C.blue,
    bgColor: _C.blueL,
    dailyCalories: '1800–2200 kcal',
    officialSource: 'https://main.icmr.nic.in',
    meals: [
      DietMeal(time: '7:00 AM', name: 'Early Morning', items: 'Warm water + ginger + tulsi + honey (bronchodilator effect)', emoji: '🌅'),
      DietMeal(time: '8:30 AM', name: 'Breakfast', items: '1 cup oatmeal + 1 banana + 1 glass warm turmeric milk', emoji: '🍽️'),
      DietMeal(time: '11:00 AM', name: 'Mid-Morning', items: '1 orange / amla + 1 cup ginger-tulsi tea', emoji: '🍊'),
      DietMeal(time: '1:00 PM', name: 'Lunch', items: '2 rotis + 1 cup dal + palak/methi sabzi + curd (no cold)', emoji: '🫓'),
      DietMeal(time: '4:00 PM', name: 'Evening', items: '1 cup warm turmeric milk / adrak chai + 5 almonds', emoji: '☕'),
      DietMeal(time: '7:00 PM', name: 'Dinner', items: 'Light khichdi or 2 rotis + dal soup + vegetables — no heavy dinner', emoji: '🥗'),
      DietMeal(time: '9:30 PM', name: 'Bedtime', items: 'Haldi doodh (turmeric milk) — anti-inflammatory', emoji: '🌙'),
    ],
    rules: [
      DietRule(emoji: '✅', rule: 'Anti-inflammatory diet: turmeric, ginger, garlic daily'),
      DietRule(emoji: '✅', rule: 'Vitamin C (amla, lemon, orange) — antioxidant lung protection'),
      DietRule(emoji: '✅', rule: 'Stay hydrated — 8–10 glasses water thins mucus'),
      DietRule(emoji: '✅', rule: 'Omega-3 (fish/walnuts) reduces airway inflammation'),
      DietRule(emoji: '⚠️', rule: 'Avoid cold foods & drinks — worsen bronchospasm'),
      DietRule(emoji: '⚠️', rule: 'Small frequent meals — large meals press on diaphragm'),
      DietRule(emoji: '🚫', rule: 'No smoking environment foods (grilled/smoked meats)'),
      DietRule(emoji: '🚫', rule: 'No sulfite foods (dried fruits, wine, processed meats)'),
    ],
    foodGroups: [
      FoodGroup(name: 'Anti-inflammatory', serving: 'Daily', examples: 'Turmeric, ginger, garlic, tulsi, amla, green tea', emoji: '🧄', color: _C.teal),
      FoodGroup(name: 'Vitamin C', serving: '3+ servings/day', examples: 'Amla, guava, orange, lemon, capsicum', emoji: '🍊', color: _C.orange),
      FoodGroup(name: 'Omega-3', serving: '2–3 servings/week', examples: 'Fatty fish, walnuts, flaxseeds', emoji: '🐟', color: _C.blue),
      FoodGroup(name: 'Warming Foods', serving: 'Daily', examples: 'Warm soups, herbal teas, khichdi, dal', emoji: '🍵', color: _C.orange),
      FoodGroup(name: 'Magnesium', serving: 'Daily', examples: 'Pumpkin seeds, spinach, almonds (bronchodilator mineral)', emoji: '🥜', color: _C.purple),
      FoodGroup(name: 'Fluids', serving: '10+ cups', examples: 'Warm water, ginger tea, tulsi tea, warm soups', emoji: '💧', color: _C.blue),
    ],
    avoidFoods: ['Cold drinks & cold water', 'Dairy excess (increases mucus for some)', 'Fried & oily foods', 'Sulphite-containing foods', 'Processed meats', 'Excess salt', 'Very spicy foods'],
  ),

  'healing': DietPlan(
    id: 'healing',
    title: 'Healing & Recovery Diet',
    subtitle: 'ICMR 2024 · Wound & Injury Recovery',
    emoji: '🩹',
    sourceLabel: 'ICMR-NIN 2024 · Surgical/Trauma Nutrition',
    color: _C.orange,
    bgColor: _C.orangeL,
    dailyCalories: '2200–2500 kcal (increased need)',
    officialSource: 'https://main.icmr.nic.in',
    meals: [
      DietMeal(time: '7:00 AM', name: 'Early Morning', items: '1 glass warm milk + 1 banana + 5 almonds + 2 walnuts', emoji: '🌅'),
      DietMeal(time: '8:30 AM', name: 'Breakfast', items: '3 eggs (2 whites + 1 whole) scrambled / 1 cup paneer bhurji + 2 rotis + 1 glass milk', emoji: '🍽️'),
      DietMeal(time: '11:00 AM', name: 'Mid-Morning', items: '1 orange (Vitamin C for wound healing) + 1 cup warm soup', emoji: '🍊'),
      DietMeal(time: '1:00 PM', name: 'Lunch', items: '2 rotis + 1 cup rajma/dal + 1 cup palak + curd + salad', emoji: '🫓'),
      DietMeal(time: '4:00 PM', name: 'Evening', items: '1 cup sprouts + 1 glass milk / buttermilk + 5 nuts', emoji: '☕'),
      DietMeal(time: '7:30 PM', name: 'Dinner', items: '2 rotis + grilled chicken/fish/paneer + 1 cup vegetable + 1 cup dal', emoji: '🥗'),
      DietMeal(time: '10:00 PM', name: 'Bedtime', items: '1 glass warm milk with turmeric and ashwagandha', emoji: '🌙'),
    ],
    rules: [
      DietRule(emoji: '✅', rule: 'Protein 1.2–1.5 g/kg body weight/day — repairs damaged tissue'),
      DietRule(emoji: '✅', rule: 'Vitamin C: 200–500mg/day — critical for collagen synthesis'),
      DietRule(emoji: '✅', rule: 'Zinc foods (pumpkin seeds, meat, legumes) — wound healing mineral'),
      DietRule(emoji: '✅', rule: 'Iron-rich foods (to replace blood loss): dal, meat, green leafy veg'),
      DietRule(emoji: '⚠️', rule: 'Increase calorie intake by 20–30% during recovery phase'),
      DietRule(emoji: '⚠️', rule: 'Eat every 3–4 hours — muscles need steady amino acid supply'),
      DietRule(emoji: '🚫', rule: 'No alcohol — severely impairs wound healing'),
      DietRule(emoji: '🚫', rule: 'No smoking environment — reduces oxygen to healing tissues'),
    ],
    foodGroups: [
      FoodGroup(name: 'High Protein (Priority)', serving: '4–5 servings/day', examples: 'Eggs, chicken, fish, paneer, dal, rajma, milk', emoji: '🥚', color: _C.orange),
      FoodGroup(name: 'Vitamin C', serving: '3 servings/day', examples: 'Amla, orange, guava, lemon, capsicum', emoji: '🍊', color: _C.orange),
      FoodGroup(name: 'Zinc Foods', serving: '2 servings/day', examples: 'Pumpkin seeds, sesame, meat, chickpeas, cashews', emoji: '🥜', color: _C.teal),
      FoodGroup(name: 'Iron Foods', serving: '2–3 servings/day', examples: 'Spinach, dal, liver, egg, beetroot with Vit C', emoji: '🥦', color: _C.green),
      FoodGroup(name: 'Energy (Carbs)', serving: '5–6 servings/day', examples: 'Rice, roti, potato, oats — fuel for healing', emoji: '🌾', color: _C.orange),
      FoodGroup(name: 'Anti-inflammatory', serving: 'Daily', examples: 'Turmeric, ginger, omega-3 fats, nuts', emoji: '🧄', color: _C.teal),
    ],
    avoidFoods: ['Alcohol', 'Smoking environment', 'Very low calorie diets', 'Fried & processed foods', 'Excess sugar (impairs immune response)', 'Carbonated drinks', 'Raw/undercooked meat (infection risk)'],
  ),

  'skin': DietPlan(
    id: 'skin',
    title: 'Skin Health Diet',
    subtitle: 'ICMR 2024 · Dermatology Support',
    emoji: '✨',
    sourceLabel: 'ICMR-NIN 2024 Guidelines',
    color: _C.pink,
    bgColor: _C.pinkL,
    dailyCalories: '1800–2000 kcal',
    officialSource: 'https://main.icmr.nic.in',
    meals: [
      DietMeal(time: '7:00 AM', name: 'Early Morning', items: '2 glasses warm water + 1 tsp amla juice / 1 glass fresh lemon water', emoji: '🌅'),
      DietMeal(time: '8:30 AM', name: 'Breakfast', items: '1 bowl oatmeal + berries / 1 cup poha with vegetables + 1 glass coconut water', emoji: '🍽️'),
      DietMeal(time: '11:00 AM', name: 'Mid-Morning', items: '1 pomegranate / papaya + 1 cup green tea (catechins for skin)', emoji: '🍎'),
      DietMeal(time: '1:00 PM', name: 'Lunch', items: '2 rotis + 1 cup dal + 1 cup palak/methi sabzi + tomato-cucumber salad', emoji: '🫓'),
      DietMeal(time: '4:00 PM', name: 'Evening', items: '1 cup green tea + 1 small handful mixed seeds (pumpkin, sunflower, sesame)', emoji: '☕'),
      DietMeal(time: '7:30 PM', name: 'Dinner', items: '2 rotis + grilled fish / paneer + 1 cup colorful vegetables + light dal', emoji: '🥗'),
      DietMeal(time: '9:30 PM', name: 'Bedtime', items: '1 glass warm milk (collagen support)', emoji: '🌙'),
    ],
    rules: [
      DietRule(emoji: '✅', rule: 'Hydrate: 8–10 glasses water daily — skin moisture from inside'),
      DietRule(emoji: '✅', rule: 'Antioxidants: colourful vegetables, fruits, green tea — fight free radicals'),
      DietRule(emoji: '✅', rule: 'Vitamin C daily (amla, citrus) — collagen production for skin'),
      DietRule(emoji: '✅', rule: 'Omega-3 (fish, walnuts, flaxseed) — reduces skin inflammation'),
      DietRule(emoji: '⚠️', rule: 'Identify trigger foods — dairy/gluten may worsen some skin conditions'),
      DietRule(emoji: '⚠️', rule: 'Low-GI diet — high sugar spikes worsen acne and inflammation'),
      DietRule(emoji: '🚫', rule: 'No fried, high-fat, processed foods — trigger inflammatory skin'),
      DietRule(emoji: '🚫', rule: 'No excess sugar & refined carbs — accelerates skin aging'),
    ],
    foodGroups: [
      FoodGroup(name: 'Antioxidant Fruits/Veg', serving: '5+ servings/day', examples: 'Tomato, pomegranate, carrot, papaya, amla, green tea', emoji: '🍅', color: _C.pink),
      FoodGroup(name: 'Omega-3 (Skin Fat)', serving: '2–3 servings/day', examples: 'Fatty fish, walnuts, flaxseeds, chia seeds', emoji: '🐟', color: _C.blue),
      FoodGroup(name: 'Collagen Builders', serving: 'Daily', examples: 'Vitamin C (amla, citrus), bone broth, dark leafy greens', emoji: '🍊', color: _C.orange),
      FoodGroup(name: 'Zinc Foods', serving: 'Daily', examples: 'Pumpkin seeds, sesame, chickpeas, sunflower seeds', emoji: '🥜', color: _C.teal),
      FoodGroup(name: 'Probiotics', serving: '2 servings/day', examples: 'Curd, buttermilk — gut-skin axis connection', emoji: '🥛', color: _C.textSec),
      FoodGroup(name: 'Water', serving: '10+ glasses', examples: 'Plain water, coconut water, herbal teas, cucumber water', emoji: '💧', color: _C.blue),
    ],
    avoidFoods: ['High-sugar foods & sweets', 'Fried & oily snacks', 'Processed packaged foods', 'Excess dairy (for acne-prone)', 'Alcohol', 'Carbonated drinks', 'Refined carbs (white bread, maida)'],
  ),

  'child': DietPlan(
    id: 'child',
    title: 'Child Growth Diet',
    subtitle: 'ICMR 2024 · Paediatric Nutrition',
    emoji: '👶',
    sourceLabel: 'ICMR-NIN 2024 · Paediatric Guidelines',
    color: _C.orange,
    bgColor: _C.orangeL,
    dailyCalories: '1200–1800 kcal (age 5–12)',
    officialSource: 'https://www.nin.res.in',
    meals: [
      DietMeal(time: '7:00 AM', name: 'Early Morning', items: '1 glass warm milk (plain / with turmeric/chyawanprash)', emoji: '🌅'),
      DietMeal(time: '8:00 AM', name: 'Breakfast', items: '2 idli + sambar / 1 bowl poha + 1 banana + 1 glass milk', emoji: '🍽️'),
      DietMeal(time: '10:30 AM', name: 'Mid-Morning (School)', items: '1 fruit (banana/apple) + 5 almonds / 1 small dhokla', emoji: '🍌'),
      DietMeal(time: '1:00 PM', name: 'Lunch', items: '2 rotis + 1 cup dal + 1 cup sabzi + 1 cup curd + salad', emoji: '🫓'),
      DietMeal(time: '4:00 PM', name: 'After-school Snack', items: '1 glass milk + 1 piece til ladoo / 1 cup fruit chaat', emoji: '☕'),
      DietMeal(time: '7:30 PM', name: 'Dinner', items: '2 rotis + 1 cup dal + sabzi + 1 cup curd / dal khichdi', emoji: '🥗'),
      DietMeal(time: '9:00 PM', name: 'Bedtime', items: '1 glass warm milk with turmeric or saffron', emoji: '🌙'),
    ],
    rules: [
      DietRule(emoji: '✅', rule: 'Protein 1–1.5 g/kg/day: dal, milk, egg, paneer — critical for growth'),
      DietRule(emoji: '✅', rule: 'Calcium 800–1200 mg/day: milk, ragi, sesame — builds bones'),
      DietRule(emoji: '✅', rule: 'Iron-rich foods with Vit C: prevents anaemia (affects 60% Indian children)'),
      DietRule(emoji: '✅', rule: 'Variety: 5 food groups at every meal — not just rotis and rice'),
      DietRule(emoji: '⚠️', rule: 'Limit screen time during meals — causes mindless overeating'),
      DietRule(emoji: '⚠️', rule: 'Monitor growth charts regularly at paediatric visits'),
      DietRule(emoji: '🚫', rule: 'No processed snacks (chips, biscuits) as regular meals'),
      DietRule(emoji: '🚫', rule: 'No sugary drinks (cola, fruit juices) — empty calories'),
    ],
    foodGroups: [
      FoodGroup(name: 'Protein for Growth', serving: '3–4 servings/day', examples: 'Dal, milk, egg, paneer, chicken (lean)', emoji: '🥚', color: _C.orange),
      FoodGroup(name: 'Calcium (Bone Building)', serving: '3 servings/day', examples: 'Milk, curd, ragi, sesame, green leafy veg', emoji: '🥛', color: _C.blue),
      FoodGroup(name: 'Iron (Brain & Blood)', serving: '2 servings/day', examples: 'Leafy greens, dal, egg, meat (with Vit C source)', emoji: '🥦', color: _C.green),
      FoodGroup(name: 'Energy Cereals', serving: '4–5 servings/day', examples: 'Rice, roti, oats, daliya — fuel for active children', emoji: '🌾', color: _C.orange),
      FoodGroup(name: 'Colourful Fruits & Veg', serving: '3–4 servings/day', examples: 'Seasonal variety for vitamins and immunity', emoji: '🍎', color: _C.pink),
      FoodGroup(name: 'Healthy Fats', serving: '2–3 tsp/day', examples: 'Ghee (1 tsp), nuts, seeds — brain development fat', emoji: '🫒', color: _C.orange),
    ],
    avoidFoods: ['Junk food (chips, bhujia, biscuits)', 'Sugary drinks & cola', 'Fast food & fried items', 'Excess sweets & mithai', 'Aerated drinks', 'Packaged noodles & flavoured snacks', 'Caffeine (tea/coffee)'],
  ),

  'women': DietPlan(
    id: 'women',
    title: "Women's Health Diet",
    subtitle: 'ICMR 2024 · Gynaecology & Hormonal Health',
    emoji: '🌸',
    sourceLabel: 'ICMR-NIN 2024 · Women & Reproductive Nutrition',
    color: _C.pink,
    bgColor: _C.pinkL,
    dailyCalories: '1900–2100 kcal (non-pregnant)',
    officialSource: 'https://main.icmr.nic.in',
    meals: [
      DietMeal(time: '7:00 AM', name: 'Early Morning', items: '1 glass methi seeds water + 5 soaked almonds + 1 tsp flaxseeds', emoji: '🌅'),
      DietMeal(time: '8:30 AM', name: 'Breakfast', items: '2 ragi rotis / 1 cup oatmeal + 1 glass milk + 1 fruit (papaya/orange)', emoji: '🍽️'),
      DietMeal(time: '11:00 AM', name: 'Mid-Morning', items: '1 orange + 1 cup green tea + 5 walnuts (hormonal balance)', emoji: '🍊'),
      DietMeal(time: '1:00 PM', name: 'Lunch', items: '2 rotis + 1 cup palak dal (iron + folate) + sabzi + curd + salad', emoji: '🫓'),
      DietMeal(time: '4:00 PM', name: 'Evening', items: '1 cup roasted seeds mix + 1 cup herbal tea (fennel/chamomile)', emoji: '☕'),
      DietMeal(time: '7:30 PM', name: 'Dinner', items: '2 rotis + 1 cup dal + 1 cup veg + 1 small bowl curd', emoji: '🥗'),
      DietMeal(time: '9:30 PM', name: 'Bedtime', items: '1 glass warm milk with shatavari (hormonal support)', emoji: '🌙'),
    ],
    rules: [
      DietRule(emoji: '✅', rule: 'Iron 30mg/day: palak, dal, rajma, meat — prevents anaemia (ICMR priority)'),
      DietRule(emoji: '✅', rule: 'Folate/Folic acid: essential for all women of reproductive age'),
      DietRule(emoji: '✅', rule: 'Calcium 1000mg/day: milk, ragi, sesame — prevents osteoporosis later'),
      DietRule(emoji: '✅', rule: 'Vitamin D: 600 IU/day — 15 min morning sunlight + fortified milk'),
      DietRule(emoji: '⚠️', rule: 'During menstruation: increase iron and Vit C intake'),
      DietRule(emoji: '⚠️', rule: 'If pregnant: add 350–500 extra kcal + extra protein + folate'),
      DietRule(emoji: '🚫', rule: 'No crash diets — hormonal imbalance worsens with undernutrition'),
      DietRule(emoji: '🚫', rule: 'No excess soy in PCOS — phytoestrogens may worsen imbalance'),
    ],
    foodGroups: [
      FoodGroup(name: 'Iron Foods (Priority)', serving: '3 servings/day', examples: 'Palak, methi, dal, rajma, egg, meat + Vit C source', emoji: '🥦', color: _C.green),
      FoodGroup(name: 'Calcium', serving: '3 servings/day', examples: 'Milk, curd, ragi, sesame, fortified foods', emoji: '🥛', color: _C.blue),
      FoodGroup(name: 'Folate', serving: '2–3 servings/day', examples: 'Palak, methi, citrus fruits, dal, broccoli, beets', emoji: '🫘', color: _C.teal),
      FoodGroup(name: 'Hormonal Balance', serving: 'Daily', examples: 'Flaxseeds, sesame, fennel, shatavari (Ayurvedic)', emoji: '🌿', color: _C.pink),
      FoodGroup(name: 'Omega-3', serving: '2–3 servings/week', examples: 'Fatty fish, walnuts, flaxseeds — PMS reduction', emoji: '🐟', color: _C.blue),
      FoodGroup(name: 'Bone-building Nutrients', serving: 'Daily', examples: 'Ragi, milk, sesame, vitamin K2 (leafy greens)', emoji: '🦴', color: _C.purple),
    ],
    avoidFoods: ['Alcohol', 'Excess caffeine (>200mg/day, especially in pregnancy)', 'Raw/undercooked meat (infection risk in pregnancy)', 'High-mercury fish (shark, swordfish)', 'Crash diets & very low calorie eating', 'Excess soy (for hormonal conditions)', 'Processed and packaged foods'],
  ),
};

// ════════════════════════════════════════════════════════════
// SYMPTOM SELECTOR WITH BACKGROUND IMAGES
// ════════════════════════════════════════════════════════════
class SymptomSelectorScreen extends StatefulWidget {
  const SymptomSelectorScreen({super.key});

  @override
  State<SymptomSelectorScreen> createState() => _SymptomSelectorScreenState();
}

class _SymptomSelectorScreenState extends State<SymptomSelectorScreen> {
  SymptomCat? _selected;

  void _openDiet(SymptomCat cat) {
    final plan = _dietPlans[cat.dietCategory];
    if (plan == null) return;
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => DietPlanScreen(plan: plan, symptom: cat),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: _C.blueL, borderRadius: BorderRadius.circular(12)),
                    child: const Row(children: [
                      Icon(Icons.info_outline_rounded, color: _C.blue, size: 16),
                      SizedBox(width: 8),
                      Expanded(child: Text(
                        'Select your symptom to view a personalised ICMR 2024 diet plan for your condition.',
                        style: TextStyle(fontSize: 12, color: _C.blue, height: 1.4),
                      )),
                    ]),
                  )),
                  const SizedBox(height: 16),
                  const Text('Select Your Symptom',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _C.text)),
                  const SizedBox(height: 4),
                  const Text('Tap an icon to view your personalised diet map',
                      style: TextStyle(fontSize: 12, color: _C.textSec)),
                  const SizedBox(height: 14),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: _symptomCats.length,
                    itemBuilder: (_, i) => FadeInUp(
                      delay: Duration(milliseconds: i * 50),
                      child: _SymptomIconCard(
                        cat: _symptomCats[i],
                        isSelected: _selected?.id == _symptomCats[i].id,
                        onTap: () {
                          setState(() => _selected = _symptomCats[i]);
                          _openDiet(_symptomCats[i]);
                        },
                      ),
                    ),
                  ),

                  if (_selected != null) ...[
                    const SizedBox(height: 20),
                    FadeInUp(child: _SelectedSymptomBar(
                      cat: _selected!,
                      onViewDiet: () => _openDiet(_selected!),
                    )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: _C.navy,
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
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Symptoms & Diet', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                Text('ICMR 2024 personalised diet maps', style: TextStyle(color: _C.textHint, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _C.teal.withOpacity(0.2), borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _C.teal, width: 0.5),
            ),
            child: const Text('Diet Map', style: TextStyle(color: _C.teal, fontSize: 10, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ── Symptom Icon Card with Background Image ────────────────
class _SymptomIconCard extends StatelessWidget {
  final SymptomCat cat;
  final bool isSelected;
  final VoidCallback onTap;

  const _SymptomIconCard({required this.cat, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(color: cat.gradientEnd.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4)),
          ] : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.network(
                  cat.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [cat.gradientStart, cat.gradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  loadingBuilder: (_, child, loading) {
                    if (loading == null) return child;
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [cat.gradientStart.withOpacity(0.6), cat.gradientEnd],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(child: SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )),
                    );
                  },
                ),
              ),

              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        cat.gradientStart.withOpacity(0.3),
                        cat.gradientEnd.withOpacity(0.75),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // Selected glow overlay
              if (isSelected)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                    ),
                  ),
                ),

              // Content
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top row: diet map chip + selected check
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('Diet Map', style: TextStyle(
                                color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700)),
                          ),
                          if (isSelected)
                            Container(
                              width: 18, height: 18,
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: const Icon(Icons.check_rounded, size: 12, color: _C.teal),
                            ),
                        ],
                      ),

                      // Bottom: emoji + label
                      Column(
                        children: [
                          Text(cat.emoji, style: const TextStyle(fontSize: 28)),
                          const SizedBox(height: 4),
                          Text(
                            cat.label,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                              shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Diet map arrow indicator
              Positioned(
                bottom: 8, right: 8,
                child: Container(
                  width: 20, height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.restaurant_menu_rounded, size: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Selected Symptom Bar ────────────────────────────────────
class _SelectedSymptomBar extends StatelessWidget {
  final SymptomCat cat;
  final VoidCallback onViewDiet;

  const _SelectedSymptomBar({required this.cat, required this.onViewDiet});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewDiet,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cat.gradientStart, cat.gradientEnd],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Text(cat.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cat.label,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                  Text(cat.hint,
                      style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.3),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text('View Diet', style: TextStyle(
                      color: cat.gradientEnd, fontSize: 12, fontWeight: FontWeight.w800)),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 14, color: cat.gradientEnd),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// DIET PLAN SCREEN — Full Detail
// ════════════════════════════════════════════════════════════
class DietPlanScreen extends StatefulWidget {
  final DietPlan plan;
  final SymptomCat symptom;

  const DietPlanScreen({super.key, required this.plan, required this.symptom});

  @override
  State<DietPlanScreen> createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  int _expandedMeal = 0;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;

    return Scaffold(
      backgroundColor: _C.bg,
      body: Column(
        children: [
          _buildHeroBanner(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _buildMealPlanTab(plan),
                _buildFoodGroupsTab(plan),
                _buildRulesTab(plan),
                _buildAvoidTab(plan),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero Banner ────────────────────────────────────────
  Widget _buildHeroBanner() {
    return Stack(
      children: [
        // Background image
        SizedBox(
          height: MediaQuery.of(context).padding.top + 160,
          width: double.infinity,
          child: Image.network(
            widget.symptom.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: widget.plan.color.withOpacity(0.8),
            ),
          ),
        ),

        // Gradient overlay
        Container(
          height: MediaQuery.of(context).padding.top + 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.symptom.gradientStart.withOpacity(0.6),
                widget.symptom.gradientEnd.withOpacity(0.92),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Content
        Positioned.fill(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  // Back button row
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('ICMR 2024', style: TextStyle(
                            color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Plan info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(widget.plan.emoji, style: const TextStyle(fontSize: 24)),
                              const SizedBox(width: 8),
                              Expanded(child: Text(widget.plan.title,
                                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800))),
                            ]),
                            const SizedBox(height: 4),
                            Text(widget.plan.subtitle,
                                style: const TextStyle(color: Colors.white70, fontSize: 11)),
                            const SizedBox(height: 8),
                            Row(children: [
                              _HeroBadge(Icons.local_fire_department_outlined, widget.plan.dailyCalories),
                              const SizedBox(width: 8),
                              _HeroBadge(Icons.verified_rounded, 'ICMR 2024'),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: _C.navy,
      child: TabBar(
        controller: _tabs,
        indicator: const BoxDecoration(
          border: Border(bottom: BorderSide(color: _C.teal, width: 2.5)),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.white.withOpacity(0.1),
        labelColor: _C.teal,
        unselectedLabelColor: Colors.white38,
        labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        tabs: const [
          Tab(text: 'Meal Plan'),
          Tab(text: 'Food Groups'),
          Tab(text: 'Guidelines'),
          Tab(text: 'Avoid'),
        ],
      ),
    );
  }

  // ── Tab 1: Meal Plan ────────────────────────────────────
  Widget _buildMealPlanTab(DietPlan plan) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          // Source badge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: plan.bgColor, borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              Icon(Icons.link_rounded, color: plan.color, size: 14),
              const SizedBox(width: 8),
              Expanded(child: Text(plan.sourceLabel,
                  style: TextStyle(fontSize: 11, color: plan.color, fontWeight: FontWeight.w600))),
            ]),
          ),
          const SizedBox(height: 14),

          ...plan.meals.asMap().entries.map((e) {
            final i = e.key;
            final meal = e.value;
            final isExpanded = _expandedMeal == i;
            return FadeInUp(
              delay: Duration(milliseconds: i * 60),
              child: GestureDetector(
                onTap: () => setState(() => _expandedMeal = isExpanded ? -1 : i),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isExpanded ? plan.color : _C.muted,
                      width: isExpanded ? 1.5 : 0.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            // Time indicator
                            Container(
                              width: 52, height: 52,
                              decoration: BoxDecoration(
                                color: plan.bgColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(meal.emoji, style: const TextStyle(fontSize: 18)),
                                  Text(meal.time.split(' ')[0],
                                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: plan.color)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(meal.name,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _C.text)),
                                  Text(meal.time,
                                      style: const TextStyle(fontSize: 11, color: _C.textHint)),
                                  if (!isExpanded)
                                    Text(meal.items,
                                        maxLines: 1, overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 11, color: _C.textSec)),
                                ],
                              ),
                            ),
                            Icon(
                              isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                              color: _C.textHint, size: 20,
                            ),
                          ],
                        ),
                      ),
                      if (isExpanded)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(height: 1, color: _C.muted),
                              const SizedBox(height: 12),
                              Text(meal.items,
                                  style: const TextStyle(fontSize: 13, color: _C.text, height: 1.6)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Tab 2: Food Groups ─────────────────────────────────
  Widget _buildFoodGroupsTab(DietPlan plan) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          // My Plate visual
          FadeInDown(child: _MyPlateDiagram(color: plan.color)),
          const SizedBox(height: 14),

          ...plan.foodGroups.asMap().entries.map((e) {
            final food = e.value;
            return FadeInUp(
              delay: Duration(milliseconds: e.key * 60),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _C.muted, width: 0.5),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: food.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(child: Text(food.emoji, style: const TextStyle(fontSize: 22))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(food.name,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _C.text)),
                          const SizedBox(height: 2),
                          Text(food.examples,
                              style: const TextStyle(fontSize: 11, color: _C.textSec, height: 1.3)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: food.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(food.serving,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: food.color)),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Tab 3: Guidelines ──────────────────────────────────
  Widget _buildRulesTab(DietPlan plan) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: plan.rules.asMap().entries.map((e) => FadeInUp(
          delay: Duration(milliseconds: e.key * 60),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _C.muted, width: 0.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.value.emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Expanded(child: Text(e.value.rule,
                    style: const TextStyle(fontSize: 13, color: _C.text, height: 1.5))),
              ],
            ),
          ),
        )).toList(),
      ),
    );
  }

  // ── Tab 4: Avoid ───────────────────────────────────────
  Widget _buildAvoidTab(DietPlan plan) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFCEBEB), borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(children: [
              Icon(Icons.warning_amber_rounded, color: _C.danger, size: 18),
              SizedBox(width: 10),
              Expanded(child: Text('Avoid these foods for your condition',
                  style: TextStyle(fontSize: 13, color: _C.danger, fontWeight: FontWeight.w700))),
            ]),
          ),
          const SizedBox(height: 12),
          ...plan.avoidFoods.asMap().entries.map((e) => FadeInUp(
            delay: Duration(milliseconds: e.key * 60),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _C.muted, width: 0.5),
              ),
              child: Row(children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCEBEB), borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(child: Text('🚫', style: TextStyle(fontSize: 14))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(e.value,
                    style: const TextStyle(fontSize: 13, color: _C.text))),
              ]),
            ),
          )),
        ],
      ),
    );
  }
}

// ── Hero Badge ─────────────────────────────────────────────
class _HeroBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  const _HeroBadge(this.icon, this.text);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(6),
    ),
    child: Row(children: [
      Icon(icon, size: 10, color: Colors.white),
      const SizedBox(width: 4),
      Text(text, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
    ]),
  );
}

// ── My Plate Diagram (ICMR 2024) ──────────────────────────
class _MyPlateDiagram extends StatelessWidget {
  final Color color;
  const _MyPlateDiagram({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.muted, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Text('🍽️', style: TextStyle(fontSize: 18)),
            SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('My Plate for the Day', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _C.text)),
              Text('ICMR 2024 — Visual guide', style: TextStyle(fontSize: 10, color: _C.textHint)),
            ]),
          ]),
          const SizedBox(height: 14),

          // Plate visual using custom painter
          Center(child: SizedBox(
            width: 180, height: 180,
            child: CustomPaint(painter: _PlatePainter()),
          )),
          const SizedBox(height: 14),

          // Legend
          Wrap(spacing: 8, runSpacing: 6, children: [
            _PlateKey(color: const Color(0xFF3B6D11), label: 'Vegetables 50%'),
            _PlateKey(color: const Color(0xFFBA7517), label: 'Cereals 25%'),
            _PlateKey(color: const Color(0xFF1D9E75), label: 'Pulses 15%'),
            _PlateKey(color: const Color(0xFF185FA5), label: 'Dairy + Fat 10%'),
          ]),
          const SizedBox(height: 10),
          const Text('Source: ICMR-NIN Dietary Guidelines for Indians 2024',
              style: TextStyle(fontSize: 10, color: _C.textHint, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}

class _PlateKey extends StatelessWidget {
  final Color color;
  final String label;
  const _PlateKey({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 10, color: _C.textSec)),
    ],
  );
}

class _PlatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 4;

    final slices = [
      (0.50, const Color(0xFF3B6D11)),   // Vegetables 50%
      (0.25, const Color(0xFFBA7517)),   // Cereals 25%
      (0.15, const Color(0xFF1D9E75)),   // Pulses 15%
      (0.10, const Color(0xFF185FA5)),   // Dairy 10%
    ];

    double startAngle = -math.pi / 2;
    for (final slice in slices) {
      final sweepAngle = slice.$1 * 2 * math.pi;
      final paint = Paint()
        ..color = slice.$2
        ..style = PaintingStyle.fill;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepAngle, true, paint,
      );
      // Border
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepAngle, true, borderPaint,
      );
      startAngle += sweepAngle;
    }

    // Plate rim
    final rimPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, rimPaint);

    // Outer ring
    final outerPaint = Paint()
      ..color = const Color(0xFFE3EAF2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius + 6, outerPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}