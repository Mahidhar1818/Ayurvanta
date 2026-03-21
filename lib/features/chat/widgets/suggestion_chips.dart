import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SuggestionChips extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onTap;

  const SuggestionChips({
    super.key,
    required this.suggestions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 6),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 7),
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => onTap(suggestions[i]
              .replaceAll(RegExp(r'[^\w\s]'), '').trim()),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.bgPage,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFFE3EAF2), width: 0.5),
            ),
            child: Text(suggestions[i],
              style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600,
                color: AppColors.navyLight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
