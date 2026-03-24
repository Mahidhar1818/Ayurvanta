import 'package:flutter/material.dart';

extension TranslationExtension on BuildContext {
  String tr(String key) {
    // temporary dummy translation
    return _localizedStrings[key] ?? key;
  }
}

Map<String, String> _localizedStrings = {
  'ai_welcome': "Hello! I'm AyurAI, your personal health assistant.",
  'knee_extension': 'Knee Extension',
  'knee_extension_desc': 'Sit on a chair and slowly straighten one leg.',
  'shoulder_shrugs': 'Shoulder Shrugs',
  'shoulder_shrugs_desc': 'Lift shoulders towards ears and release.',
  'ankle_pumps': 'Ankle Pumps',
  'ankle_pumps_desc': 'Move ankles up and down.',
  'wall_slides': 'Wall Slides',
  'wall_slides_desc': 'Slide down a wall into squat.',
  'ortho_exercises': 'Ortho Exercises',
};
