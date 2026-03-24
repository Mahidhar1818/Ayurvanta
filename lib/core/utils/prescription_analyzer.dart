import 'package:flutter/material.dart';

class PrescriptionAnalyzer {
  // Common medicine names database
  static const Map<String, List<String>> _medicineDatabase = {
    'antibiotics': ['amoxicillin', 'azithromycin', 'cefixime', 'levofloxacin', 'doxycycline'],
    'painkillers': ['paracetamol', 'ibuprofen', 'diclofenac', 'aspirin', 'tramadol'],
    'antihypertensives': ['amlodipine', 'atenolol', 'losartan', 'telmisartan', 'metoprolol'],
    'antidiabetics': ['metformin', 'glimepiride', 'insulin', 'pioglitazone', 'voglibose'],
    'antidepressants': ['fluoxetine', 'sertraline', 'escitalopram', 'venlafaxine'],
    'antacids': ['omeprazole', 'pantoprazole', 'ranitidine', 'famotidine'],
    'antihistamines': ['cetirizine', 'loratadine', 'fexofenadine', 'levocetirizine'],
    'steroids': ['prednisolone', 'dexamethasone', 'hydrocortisone'],
    'vitamins': ['vitamin d3', 'vitamin b12', 'vitamin c', 'calcium', 'iron'],
    'cardiovascular': ['atorvastatin', 'rosuvastatin', 'clopidogrel', 'aspirin'],
  };

  static PrescriptionAnalysis analyze(String text) {
    final lowerText = text.toLowerCase();
    final List<MedicineMatch> matches = [];
    
    // Extract medicine names
    for (var entry in _medicineDatabase.entries) {
      for (var medicine in entry.value) {
        if (lowerText.contains(medicine)) {
          // Extract dosage if present (pattern like 500mg, 10mg, etc.)
          final dosagePattern = RegExp(r'(\d+)\s*(mg|mcg|g|ml)');
          final dosageMatch = dosagePattern.firstMatch(lowerText.substring(
            lowerText.indexOf(medicine),
            (lowerText.indexOf(medicine) + 50).clamp(0, lowerText.length),
          ));
          
          matches.add(MedicineMatch(
            name: medicine,
            category: entry.key,
            dosage: dosageMatch?.group(0) ?? 'As directed',
            confidence: 0.85,
          ));
        }
      }
    }
    
    // Extract frequency patterns
    final frequencyPattern = RegExp(r'(once|twice|thrice|(\d+)\s*(time|day|daily|weekly))');
    final frequencies = frequencyPattern.allMatches(lowerText).map((m) => m.group(0)).toList();
    
    // Extract duration
    final durationPattern = RegExp(r'(\d+)\s*(day|week|month|days|weeks|months)');
    final duration = durationPattern.firstMatch(lowerText)?.group(0);
    
    return PrescriptionAnalysis(
      medicines: matches,
      frequency: frequencies.isNotEmpty ? (frequencies.first ?? 'Not specified') : 'Not specified',
      duration: duration ?? 'Not specified',
      hasWarnings: matches.any((m) => m.category == 'steroids' || m.category == 'antibiotics'),
    );
  }
}

class MedicineMatch {
  final String name;
  final String category;
  final String dosage;
  final double confidence;
  
  MedicineMatch({
    required this.name,
    required this.category,
    required this.dosage,
    required this.confidence,
  });
}

class PrescriptionAnalysis {
  final List<MedicineMatch> medicines;
  final String frequency;
  final String duration;
  final bool hasWarnings;
  
  PrescriptionAnalysis({
    required this.medicines,
    required this.frequency,
    required this.duration,
    required this.hasWarnings,
  });
}
