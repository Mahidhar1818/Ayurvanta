import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../appointments/screens/doctor_list_screen.dart';
import '../../chat/screens/ai_chat_screen.dart';
import '../../pharmacy/screens/pharmacy_screen.dart';

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});

  final _items = const [
    {'icon': Icons.local_hospital_outlined, 'label': 'Book Appt',
     'bg': AppColors.blueLight, 'color': AppColors.blue},
    {'icon': Icons.medication_outlined, 'label': 'Medicines',
     'bg': Color(0xFFEAF3DE), 'color': AppColors.teal},
    {'icon': Icons.science_outlined, 'label': 'Lab Tests',
     'bg': Color(0xFFFAEEDA), 'color': Color(0xFFBA7517)},
    {'icon': Icons.smart_toy_outlined, 'label': 'AI Doctor',
     'bg': Color(0xFFEEEDFE), 'color': Color(0xFF534AB7)},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _items.map((item) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              if (item['label'] == 'Book Appt') {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const DoctorListScreen(),
                ));
              } else if (item['label'] == 'Medicines') {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const PharmacyScreen(),
                ));
              } else if (item['label'] == 'AI Doctor') {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const AiChatScreen(),
                ));
              }
            },
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
