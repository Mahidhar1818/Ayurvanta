import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class UpcomingAppointmentCard extends StatelessWidget {
  const UpcomingAppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Center(child: Text('RK',
                    style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.w700, fontSize: 15))),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dr. Ravi Kumar',
                        style: TextStyle(fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    SizedBox(height: 2),
                    Text('Cardiologist · Apollo Hospital',
                        style: TextStyle(fontSize: 11,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3DE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Confirmed',
                    style: TextStyle(fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3B6D11))),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF0F4F8)),
          const SizedBox(height: 10),
          const Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 13, color: AppColors.textSecondary),
              SizedBox(width: 5),
              Text('Tomorrow, Mar 22',
                  style: TextStyle(fontSize: 11,
                      color: AppColors.textSecondary)),
              SizedBox(width: 16),
              Icon(Icons.access_time_rounded,
                  size: 13, color: AppColors.textSecondary),
              SizedBox(width: 5),
              Text('10:30 AM',
                  style: TextStyle(fontSize: 11,
                      color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}
