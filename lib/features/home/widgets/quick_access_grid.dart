import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/translations/tr_extension.dart';
import '../../appointments/screens/doctor_list_screen.dart';
import '../../chat/screens/ai_chat_screen.dart';
import '../../pharmacy/screens/pharmacy_screen.dart';
import '../../opd/screens/opd_registration_screen.dart';
import '../../diet/screens/diet_map_screen.dart';

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'icon': Icons.local_hospital_outlined,
        'label': context.tr('book_appt'),
        'bg': AppColors.blueLight,
        'color': AppColors.blue,
        'onTap': () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => const DoctorListScreen(),
        )),
      },
      {
        'icon': Icons.assignment_outlined,
        'label': context.tr('opd_reg'),
        'bg': const Color(0xFFEEEDFE),
        'color': const Color(0xFF534AB7),
        'onTap': () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => const OpdRegistrationScreen(),
        )),
      },
      {
        'icon': Icons.medication_outlined,
        'label': context.tr('medicines'),
        'bg': const Color(0xFFEAF3DE),
        'color': AppColors.teal,
        'onTap': () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => const PharmacyScreen(),
        )),
      },
      {
        'icon': Icons.restaurant_menu_outlined,
        'label': context.tr('diet_map'),
        'bg': const Color(0xFFFAEEDA),
        'color': const Color(0xFFBA7517),
        'onTap': () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => const DietMapScreen(),
        )),
      },
    ];

    return Row(
      children: items.map((item) {
        return Expanded(
          child: GestureDetector(
            onTap: item['onTap'],
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
              ),
              child: Column(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: item['bg'] as Color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item['icon'] as IconData,
                        color: item['color'] as Color, size: 20),
                  ),
                  const SizedBox(height: 6),
                  Text(item['label'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navyLight)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
