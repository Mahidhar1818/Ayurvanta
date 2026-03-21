import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class MedicineModel {
  final String id;
  final String name;
  final String genericName;
  final String manufacturer;
  final String category;
  final String dosageForm;
  final String strength;
  final String emoji;
  final int price;
  final int mrp;
  final bool requiresPrescription;
  final String description;
  int quantity;

  MedicineModel({
    required this.id,
    required this.name,
    required this.genericName,
    required this.manufacturer,
    required this.category,
    required this.dosageForm,
    required this.strength,
    required this.emoji,
    required this.price,
    required this.mrp,
    required this.requiresPrescription,
    required this.description,
    this.quantity = 0,
  });

  int get discount =>
      (((mrp - price) / mrp) * 100).round();

  MedicineModel copyWith({int? quantity}) =>
      MedicineModel(
        id: id, name: name,
        genericName: genericName,
        manufacturer: manufacturer,
        category: category,
        dosageForm: dosageForm,
        strength: strength, emoji: emoji,
        price: price, mrp: mrp,
        requiresPrescription: requiresPrescription,
        description: description,
        quantity: quantity ?? this.quantity,
      );
}

class MedicineApiService {
  // Open FDA Drug API
  static const _fdaBase =
      'https://api.fda.gov/drug/label.json';

  // Fetch medicines from Open FDA
  static Future<List<MedicineModel>> searchMedicines(
      String query, {int limit = 20}) async {
    try {
      final url = Uri.parse(
        '$_fdaBase?search=openfda.brand_name:"$query"'
        '&limit=$limit',
      );
      final res = await http
          .get(url)
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final results = data['results'] as List?;
        if (results != null) {
          return results
              .asMap()
              .entries
              .map((e) => _parseFdaDrug(
                  e.value, e.key.toString()))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('FDA API error: $e');
    }
    // Return Indian medicine database on error
    return _getLocalMedicines(query);
  }

  static MedicineModel _parseFdaDrug(
      Map<String, dynamic> data, String idx) {
    final openfda =
        data['openfda'] as Map<String, dynamic>?;
    final brandNames =
        openfda?['brand_name'] as List?;
    final genericNames =
        openfda?['generic_name'] as List?;
    final manufacturers =
        openfda?['manufacturer_name'] as List?;
    final dosageForms =
        openfda?['dosage_form'] as List?;

    final name = brandNames?.first?.toString() ??
        'Unknown Medicine';
    final generic =
        genericNames?.first?.toString() ??
        'Generic';
    final mfr =
        manufacturers?.first?.toString() ??
        'Unknown';
    final form =
        dosageForms?.first?.toString() ?? 'Tablet';

    return MedicineModel(
      id: 'fda_$idx',
      name: _toTitleCase(name),
      genericName: _toTitleCase(generic),
      manufacturer: _toTitleCase(mfr),
      category: _guessCategory(generic),
      dosageForm: form,
      strength: '',
      emoji: _getEmoji(form),
      price: _randomPrice(50, 500),
      mrp: _randomPrice(60, 600),
      requiresPrescription: _needsRx(generic),
      description:
          data['indications_and_usage']
                  ?.toString()
                  .substring(0, 80) ??
              '',
    );
  }

  // Comprehensive Indian medicine database
  static List<MedicineModel> _getLocalMedicines(
      String query) {
    final all = _indianMedicines;
    if (query.isEmpty) return all;
    final q = query.toLowerCase();
    return all
        .where((m) =>
            m.name.toLowerCase().contains(q) ||
            m.genericName
                .toLowerCase()
                .contains(q) ||
            m.category.toLowerCase().contains(q) ||
            m.manufacturer.toLowerCase().contains(q))
        .toList();
  }

  static final List<MedicineModel> _indianMedicines = [
    // Cardiac
    MedicineModel(id:'1',name:'Amlodipine 5mg',
        genericName:'Amlodipine Besylate',
        manufacturer:'Sun Pharma',category:'Cardiac',
        dosageForm:'Tablet',strength:'5mg',emoji:'💊',
        price:48,mrp:62,requiresPrescription:true,
        description:'Calcium channel blocker for hypertension'),
    MedicineModel(id:'2',name:'Atorvastatin 10mg',
        genericName:'Atorvastatin Calcium',
        manufacturer:'Pfizer',category:'Cardiac',
        dosageForm:'Tablet',strength:'10mg',emoji:'💊',
        price:85,mrp:110,requiresPrescription:true,
        description:'Statin for high cholesterol'),
    MedicineModel(id:'3',name:'Aspirin 75mg',
        genericName:'Acetylsalicylic Acid',
        manufacturer:'Bayer',category:'Cardiac',
        dosageForm:'Tablet',strength:'75mg',emoji:'💊',
        price:22,mrp:30,requiresPrescription:false,
        description:'Blood thinner for heart protection'),
    MedicineModel(id:'4',name:'Metoprolol 25mg',
        genericName:'Metoprolol Succinate',
        manufacturer:'AstraZeneca',category:'Cardiac',
        dosageForm:'Tablet',strength:'25mg',emoji:'💊',
        price:65,mrp:85,requiresPrescription:true,
        description:'Beta blocker for heart conditions'),
    MedicineModel(id:'5',name:'Ramipril 5mg',
        genericName:'Ramipril',
        manufacturer:'Sanofi',category:'Cardiac',
        dosageForm:'Capsule',strength:'5mg',emoji:'💊',
        price:72,mrp:95,requiresPrescription:true,
        description:'ACE inhibitor for blood pressure'),
    // Diabetes
    MedicineModel(id:'6',name:'Metformin 500mg',
        genericName:'Metformin Hydrochloride',
        manufacturer:'Cipla',category:'Diabetes',
        dosageForm:'Tablet',strength:'500mg',emoji:'💊',
        price:35,mrp:45,requiresPrescription:true,
        description:'First-line diabetes medication'),
    MedicineModel(id:'7',name:'Glimepiride 2mg',
        genericName:'Glimepiride',
        manufacturer:'Sanofi',category:'Diabetes',
        dosageForm:'Tablet',strength:'2mg',emoji:'💊',
        price:55,mrp:72,requiresPrescription:true,
        description:'Sulfonylurea for type 2 diabetes'),
    MedicineModel(id:'8',name:'Januvia 100mg',
        genericName:'Sitagliptin',
        manufacturer:'MSD',category:'Diabetes',
        dosageForm:'Tablet',strength:'100mg',emoji:'💊',
        price:245,mrp:320,requiresPrescription:true,
        description:'DPP-4 inhibitor for diabetes'),
    MedicineModel(id:'9',name:'Insulin Glargine',
        genericName:'Insulin Glargine',
        manufacturer:'Sanofi',category:'Diabetes',
        dosageForm:'Injection',strength:'100IU/ml',emoji:'💉',
        price:890,mrp:1150,requiresPrescription:true,
        description:'Long-acting insulin for diabetes'),
    // Antibiotics
    MedicineModel(id:'10',name:'Azithromycin 500mg',
        genericName:'Azithromycin Dihydrate',
        manufacturer:'Pfizer',category:'Antibiotics',
        dosageForm:'Tablet',strength:'500mg',emoji:'💊',
        price:89,mrp:120,requiresPrescription:true,
        description:'Macrolide antibiotic for infections'),
    MedicineModel(id:'11',name:'Amoxicillin 500mg',
        genericName:'Amoxicillin Trihydrate',
        manufacturer:'GSK',category:'Antibiotics',
        dosageForm:'Capsule',strength:'500mg',emoji:'💊',
        price:45,mrp:58,requiresPrescription:true,
        description:'Penicillin antibiotic'),
    MedicineModel(id:'12',name:'Ciprofloxacin 500mg',
        genericName:'Ciprofloxacin HCl',
        manufacturer:'Bayer',category:'Antibiotics',
        dosageForm:'Tablet',strength:'500mg',emoji:'💊',
        price:68,mrp:88,requiresPrescription:true,
        description:'Fluoroquinolone antibiotic'),
    MedicineModel(id:'13',name:'Doxycycline 100mg',
        genericName:'Doxycycline Hyclate',
        manufacturer:'Sun Pharma',category:'Antibiotics',
        dosageForm:'Capsule',strength:'100mg',emoji:'💊',
        price:52,mrp:68,requiresPrescription:true,
        description:'Tetracycline antibiotic'),
    // Pain Relief
    MedicineModel(id:'14',name:'Paracetamol 500mg',
        genericName:'Acetaminophen',
        manufacturer:'GSK',category:'Pain Relief',
        dosageForm:'Tablet',strength:'500mg',emoji:'💊',
        price:15,mrp:20,requiresPrescription:false,
        description:'Common pain and fever reliever'),
    MedicineModel(id:'15',name:'Ibuprofen 400mg',
        genericName:'Ibuprofen',
        manufacturer:'Abbott',category:'Pain Relief',
        dosageForm:'Tablet',strength:'400mg',emoji:'💊',
        price:28,mrp:38,requiresPrescription:false,
        description:'NSAID for pain and inflammation'),
    MedicineModel(id:'16',name:'Diclofenac 50mg',
        genericName:'Diclofenac Sodium',
        manufacturer:'Novartis',category:'Pain Relief',
        dosageForm:'Tablet',strength:'50mg',emoji:'💊',
        price:32,mrp:42,requiresPrescription:true,
        description:'Anti-inflammatory pain reliever'),
    MedicineModel(id:'17',name:'Tramadol 50mg',
        genericName:'Tramadol HCl',
        manufacturer:'Mankind',category:'Pain Relief',
        dosageForm:'Capsule',strength:'50mg',emoji:'💊',
        price:45,mrp:58,requiresPrescription:true,
        description:'Opioid analgesic for moderate pain'),
    // Vitamins
    MedicineModel(id:'18',name:'Vitamin D3 60K IU',
        genericName:'Cholecalciferol',
        manufacturer:'Abbott',category:'Vitamins',
        dosageForm:'Capsule',strength:'60000IU',emoji:'🧴',
        price:52,mrp:75,requiresPrescription:false,
        description:'Weekly vitamin D supplement'),
    MedicineModel(id:'19',name:'Vitamin B12 1500mcg',
        genericName:'Methylcobalamin',
        manufacturer:'Sun Pharma',category:'Vitamins',
        dosageForm:'Tablet',strength:'1500mcg',emoji:'🧴',
        price:88,mrp:115,requiresPrescription:false,
        description:'Nerve and energy vitamin'),
    MedicineModel(id:'20',name:'Calcium + D3',
        genericName:'Calcium Carbonate + D3',
        manufacturer:'Pfizer',category:'Vitamins',
        dosageForm:'Tablet',strength:'500mg+250IU',emoji:'🧴',
        price:120,mrp:155,requiresPrescription:false,
        description:'Bone health supplement'),
    MedicineModel(id:'21',name:'Iron + Folic Acid',
        genericName:'Ferrous Sulfate + FA',
        manufacturer:'Cipla',category:'Vitamins',
        dosageForm:'Tablet',strength:'150mg+0.5mg',emoji:'🧴',
        price:45,mrp:60,requiresPrescription:false,
        description:'Iron and folic acid supplement'),
    // Respiratory
    MedicineModel(id:'22',name:'Salbutamol 2mg',
        genericName:'Salbutamol Sulfate',
        manufacturer:'GSK',category:'Respiratory',
        dosageForm:'Tablet',strength:'2mg',emoji:'💨',
        price:28,mrp:36,requiresPrescription:true,
        description:'Bronchodilator for asthma'),
    MedicineModel(id:'23',name:'Montelukast 10mg',
        genericName:'Montelukast Sodium',
        manufacturer:'MSD',category:'Respiratory',
        dosageForm:'Tablet',strength:'10mg',emoji:'💊',
        price:95,mrp:125,requiresPrescription:true,
        description:'Leukotriene for asthma/allergies'),
    MedicineModel(id:'24',name:'Tiotropium Inhaler',
        genericName:'Tiotropium Bromide',
        manufacturer:'Boehringer',category:'Respiratory',
        dosageForm:'Inhaler',strength:'18mcg',emoji:'💨',
        price:850,mrp:1100,requiresPrescription:true,
        description:'COPD maintenance inhaler'),
    // Skin
    MedicineModel(id:'25',name:'Betamethasone Cream',
        genericName:'Betamethasone Valerate',
        manufacturer:'GSK',category:'Skin',
        dosageForm:'Cream',strength:'0.1%',emoji:'🧴',
        price:65,mrp:85,requiresPrescription:true,
        description:'Corticosteroid for skin conditions'),
    MedicineModel(id:'26',name:'Clotrimazole Cream',
        genericName:'Clotrimazole',
        manufacturer:'Bayer',category:'Skin',
        dosageForm:'Cream',strength:'1%',emoji:'🧴',
        price:42,mrp:55,requiresPrescription:false,
        description:'Antifungal cream'),
    MedicineModel(id:'27',name:'Cetrizine 10mg',
        genericName:'Cetirizine HCl',
        manufacturer:'UCB',category:'Skin',
        dosageForm:'Tablet',strength:'10mg',emoji:'💊',
        price:25,mrp:32,requiresPrescription:false,
        description:'Antihistamine for allergies'),
    // Neurological
    MedicineModel(id:'28',name:'Gabapentin 300mg',
        genericName:'Gabapentin',
        manufacturer:'Pfizer',category:'Neurology',
        dosageForm:'Capsule',strength:'300mg',emoji:'💊',
        price:125,mrp:165,requiresPrescription:true,
        description:'Nerve pain medication'),
    MedicineModel(id:'29',name:'Escitalopram 10mg',
        genericName:'Escitalopram Oxalate',
        manufacturer:'Lundbeck',category:'Neurology',
        dosageForm:'Tablet',strength:'10mg',emoji:'💊',
        price:95,mrp:125,requiresPrescription:true,
        description:'SSRI antidepressant'),
    MedicineModel(id:'30',name:'Alprazolam 0.5mg',
        genericName:'Alprazolam',
        manufacturer:'Pfizer',category:'Neurology',
        dosageForm:'Tablet',strength:'0.5mg',emoji:'💊',
        price:35,mrp:45,requiresPrescription:true,
        description:'Benzodiazepine for anxiety'),
    // Gastro
    MedicineModel(id:'31',name:'Omeprazole 20mg',
        genericName:'Omeprazole',
        manufacturer:'AstraZeneca',category:'Gastro',
        dosageForm:'Capsule',strength:'20mg',emoji:'💊',
        price:38,mrp:50,requiresPrescription:false,
        description:'Proton pump inhibitor for acidity'),
    MedicineModel(id:'32',name:'Pantoprazole 40mg',
        genericName:'Pantoprazole Sodium',
        manufacturer:'Takeda',category:'Gastro',
        dosageForm:'Tablet',strength:'40mg',emoji:'💊',
        price:42,mrp:55,requiresPrescription:false,
        description:'For gastric ulcers and GERD'),
    MedicineModel(id:'33',name:'Ondansetron 4mg',
        genericName:'Ondansetron HCl',
        manufacturer:'GSK',category:'Gastro',
        dosageForm:'Tablet',strength:'4mg',emoji:'💊',
        price:55,mrp:72,requiresPrescription:true,
        description:'Anti-nausea and vomiting'),
    MedicineModel(id:'34',name:'ORS Sachets',
        genericName:'Oral Rehydration Salts',
        manufacturer:'Abbott',category:'Gastro',
        dosageForm:'Sachet',strength:'Standard',emoji:'🧂',
        price:12,mrp:15,requiresPrescription:false,
        description:'For dehydration and diarrhea'),
    // Eye & ENT
    MedicineModel(id:'35',name:'Ciprofloxacin Eye Drops',
        genericName:'Ciprofloxacin 0.3%',
        manufacturer:'Alcon',category:'Eye & ENT',
        dosageForm:'Eye Drops',strength:'0.3%',emoji:'👁️',
        price:85,mrp:110,requiresPrescription:true,
        description:'Antibiotic eye drops'),
    MedicineModel(id:'36',name:'Xylometazoline Nasal',
        genericName:'Xylometazoline HCl',
        manufacturer:'Novartis',category:'Eye & ENT',
        dosageForm:'Nasal Spray',strength:'0.1%',emoji:'👃',
        price:65,mrp:85,requiresPrescription:false,
        description:'Nasal decongestant spray'),
    // Hormones
    MedicineModel(id:'37',name:'Levothyroxine 50mcg',
        genericName:'Levothyroxine Sodium',
        manufacturer:'Abbott',category:'Hormones',
        dosageForm:'Tablet',strength:'50mcg',emoji:'💊',
        price:55,mrp:72,requiresPrescription:true,
        description:'Thyroid hormone replacement'),
    MedicineModel(id:'38',name:'Prednisolone 5mg',
        genericName:'Prednisolone',
        manufacturer:'Pfizer',category:'Hormones',
        dosageForm:'Tablet',strength:'5mg',emoji:'💊',
        price:28,mrp:36,requiresPrescription:true,
        description:'Corticosteroid anti-inflammatory'),
    // First Aid
    MedicineModel(id:'39',name:'Povidone Iodine',
        genericName:'Povidone-Iodine 5%',
        manufacturer:'Win-Medicare',category:'First Aid',
        dosageForm:'Solution',strength:'5%',emoji:'🩹',
        price:35,mrp:45,requiresPrescription:false,
        description:'Antiseptic wound cleaner'),
    MedicineModel(id:'40',name:'Diclofenac Gel',
        genericName:'Diclofenac Diethylamine',
        manufacturer:'Novartis',category:'First Aid',
        dosageForm:'Gel',strength:'1%',emoji:'🧴',
        price:55,mrp:72,requiresPrescription:false,
        description:'Topical anti-inflammatory gel'),
  ];

  static String _toTitleCase(String s) {
    return s.split(' ').map((w) =>
        w.isEmpty ? '' :
        w[0].toUpperCase() + w.substring(1).toLowerCase()
    ).join(' ');
  }

  static String _guessCategory(String generic) {
    final g = generic.toLowerCase();
    if (g.contains('amlo') || g.contains('atorva') ||
        g.contains('aspirin') || g.contains('metoprol'))
      return 'Cardiac';
    if (g.contains('metform') || g.contains('insulin') ||
        g.contains('glimep')) return 'Diabetes';
    if (g.contains('mycin') || g.contains('cillin') ||
        g.contains('floxacin')) return 'Antibiotics';
    if (g.contains('paracet') || g.contains('ibuprofen') ||
        g.contains('diclof')) return 'Pain Relief';
    if (g.contains('vitamin') || g.contains('calcium') ||
        g.contains('iron')) return 'Vitamins';
    return 'General';
  }

  static String _getEmoji(String form) {
    switch (form.toLowerCase()) {
      case 'tablet': return '💊';
      case 'capsule': return '💊';
      case 'injection': return '💉';
      case 'inhaler': return '💨';
      case 'syrup': return '🍶';
      case 'cream': case 'gel': return '🧴';
      case 'eye drops': return '👁️';
      case 'nasal spray': return '👃';
      default: return '💊';
    }
  }

  static bool _needsRx(String generic) {
    final g = generic.toLowerCase();
    return g.contains('amlo') || g.contains('metform') ||
        g.contains('antibiotic') || g.contains('insulin') ||
        g.contains('mycin') || g.contains('cillin');
  }

  static int _randomPrice(int min, int max) {
    return min + (max - min) ~/ 2;
  }

  static List<String> get categories => [
    'All', 'Cardiac', 'Diabetes', 'Antibiotics',
    'Pain Relief', 'Vitamins', 'Respiratory',
    'Skin', 'Neurology', 'Gastro', 'Eye & ENT',
    'Hormones', 'First Aid',
  ];

  static List<MedicineModel> getAll() => _indianMedicines;

  static List<MedicineModel> byCategory(String cat) {
    if (cat == 'All') return _indianMedicines;
    return _indianMedicines
        .where((m) => m.category == cat)
        .toList();
  }
}
