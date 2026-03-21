import 'package:flutter/material.dart';
import 'app_translations.dart';

extension StringExtension on String {
  String get tr => AppTranslations.instance.tr(this);
}

extension TrExtension on BuildContext {
  String tr(String key) {
    return AppTranslations.instance.tr(key);
  }

  AppTranslations get translations => AppTranslations.instance;
}
