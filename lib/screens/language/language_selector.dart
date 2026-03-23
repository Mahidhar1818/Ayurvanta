import 'package:flutter/material.dart';
import '../language_selection_screen.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provide a simple wrapper around the LanguageSelectionScreen
    // tailored to be shown in a modal bottom sheet.
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: const LanguageSelectionScreen(isFirstTime: false),
    );
  }
}
