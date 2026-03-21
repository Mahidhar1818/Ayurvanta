import 'package:flutter/material.dart';

enum BodySystem {
  all, skeletal, muscular, nervous,
  digestive, cardiac, respiratory,
  skin, urinary, endocrine, reproductive,
}

class BodyPart {
  final String key;
  final String system;
  final Offset frontOffset;
  final Offset? backOffset;
  final double width;
  final double height;
  final bool maleOnly;
  final bool femaleOnly;
  final Color systemColor;

  const BodyPart({
    required this.key,
    required this.system,
    required this.frontOffset,
    this.backOffset,
    this.width = 40,
    this.height = 30,
    this.maleOnly = false,
    this.femaleOnly = false,
    required this.systemColor,
  });
}

class BodyPartsData {
  static const List<BodyPart> maleParts = [
    BodyPart(key: 'head',      system: 'skeletal',
        frontOffset: Offset(0.5, 0.07),
        width: 70, height: 70,
        systemColor: Color(0xFF185FA5)),
    BodyPart(key: 'neck',      system: 'skeletal',
        frontOffset: Offset(0.5, 0.155),
        width: 30, height: 22,
        systemColor: Color(0xFF6B8099)),
    BodyPart(key: 'shoulder',  system: 'muscular',
        frontOffset: Offset(0.25, 0.195),
        width: 48, height: 30,
        systemColor: Color(0xFF1D9E75)),
    BodyPart(key: 'chest',     system: 'cardiac',
        frontOffset: Offset(0.5, 0.25),
        width: 100, height: 70,
        systemColor: Color(0xFFE8243A)),
    BodyPart(key: 'heart',     system: 'cardiac',
        frontOffset: Offset(0.45, 0.225),
        width: 30, height: 24,
        systemColor: Color(0xFFE8243A)),
    BodyPart(key: 'lungs',     system: 'respiratory',
        frontOffset: Offset(0.5, 0.255),
        width: 80, height: 60,
        systemColor: Color(0xFF0F6E56)),
    BodyPart(key: 'abdomen',   system: 'digestive',
        frontOffset: Offset(0.5, 0.38),
        width: 90, height: 55,
        systemColor: Color(0xFFBA7517)),
    BodyPart(key: 'stomach',   system: 'digestive',
        frontOffset: Offset(0.42, 0.365),
        width: 40, height: 32,
        systemColor: Color(0xFFBA7517)),
    BodyPart(key: 'liver',     system: 'digestive',
        frontOffset: Offset(0.62, 0.355),
        width: 36, height: 28,
        systemColor: Color(0xFFA32D2D)),
    BodyPart(key: 'kidney',    system: 'urinary',
        frontOffset: Offset(0.5, 0.37),
        width: 70, height: 30,
        systemColor: Color(0xFF993556)),
    BodyPart(key: 'pelvis',    system: 'skeletal',
        frontOffset: Offset(0.5, 0.48),
        width: 95, height: 40,
        systemColor: Color(0xFF534AB7)),
    BodyPart(key: 'groin',     system: 'muscular',
        frontOffset: Offset(0.5, 0.52),
        width: 60, height: 25,
        systemColor: Color(0xFF534AB7)),
    BodyPart(key: 'upper_arm', system: 'muscular',
        frontOffset: Offset(0.17, 0.27),
        width: 30, height: 70,
        systemColor: Color(0xFF1D9E75)),
    BodyPart(key: 'elbow',     system: 'skeletal',
        frontOffset: Offset(0.17, 0.385),
        width: 28, height: 22,
        systemColor: Color(0xFF185FA5)),
    BodyPart(key: 'forearm',   system: 'muscular',
        frontOffset: Offset(0.17, 0.455),
        width: 26, height: 55,
        systemColor: Color(0xFF1D9E75)),
    BodyPart(key: 'wrist',     system: 'skeletal',
        frontOffset: Offset(0.17, 0.545),
        width: 24, height: 18,
        systemColor: Color(0xFF185FA5)),
    BodyPart(key: 'hand',      system: 'skeletal',
        frontOffset: Offset(0.17, 0.595),
        width: 32, height: 28,
        systemColor: Color(0xFF0F6E56)),
    BodyPart(key: 'thigh',     system: 'muscular',
        frontOffset: Offset(0.37, 0.61),
        width: 38, height: 75,
        systemColor: Color(0xFF185FA5)),
    BodyPart(key: 'knee',      system: 'skeletal',
        frontOffset: Offset(0.37, 0.745),
        width: 34, height: 28,
        systemColor: Color(0xFF534AB7)),
    BodyPart(key: 'lower_leg', system: 'muscular',
        frontOffset: Offset(0.37, 0.825),
        width: 30, height: 65,
        systemColor: Color(0xFF185FA5)),
    BodyPart(key: 'ankle',     system: 'skeletal',
        frontOffset: Offset(0.37, 0.915),
        width: 26, height: 18,
        systemColor: Color(0xFF185FA5)),
    BodyPart(key: 'foot',      system: 'skeletal',
        frontOffset: Offset(0.37, 0.955),
        width: 40, height: 22,
        systemColor: Color(0xFF0F6E56)),
    BodyPart(key: 'spine',     system: 'nervous',
        backOffset: Offset(0.5, 0.35),
        frontOffset: Offset(0.5, 0.35),
        width: 20, height: 120,
        systemColor: Color(0xFF534AB7)),
    BodyPart(key: 'lower_back',system: 'muscular',
        backOffset: Offset(0.5, 0.44),
        frontOffset: Offset(0.5, 0.44),
        width: 80, height: 40,
        systemColor: Color(0xFF1D9E75)),
    BodyPart(key: 'hip',       system: 'skeletal',
        backOffset: Offset(0.5, 0.52),
        frontOffset: Offset(0.5, 0.5),
        width: 90, height: 35,
        systemColor: Color(0xFF534AB7)),
    BodyPart(key: 'heel',      system: 'skeletal',
        backOffset: Offset(0.37, 0.96),
        frontOffset: Offset(0.37, 0.96),
        width: 24, height: 18,
        systemColor: Color(0xFF185FA5)),
  ];

  static List<BodyPart> get femaleParts {
    final base = maleParts
        .where((p) => !p.maleOnly)
        .toList();
    return [
      ...base,
      const BodyPart(
        key: 'uterus',
        system: 'reproductive',
        frontOffset: Offset(0.5, 0.465),
        width: 38, height: 30,
        femaleOnly: true,
        systemColor: Color(0xFF993556),
      ),
    ];
  }

  static const systemColors = {
    'skeletal':     Color(0xFF185FA5),
    'muscular':     Color(0xFF1D9E75),
    'nervous':      Color(0xFF534AB7),
    'digestive':    Color(0xFFBA7517),
    'cardiac':      Color(0xFFE8243A),
    'respiratory':  Color(0xFF0F6E56),
    'skin':         Color(0xFFA32D2D),
    'urinary':      Color(0xFF993556),
    'endocrine':    Color(0xFF633806),
    'reproductive': Color(0xFF993556),
  };
}
