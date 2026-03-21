import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/hospital_model.dart';

class HospitalCard extends StatelessWidget {
  final HospitalModel hospital;
  final VoidCallback onBook;
  const HospitalCard(
      {super.key, required this.hospital,
      required this.onBook});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFE3EAF2),
            width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: AppColors.blueLight,
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(hospital.imageEmoji,
                      style: const TextStyle(
                          fontSize: 28))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(hospital.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      )),
                    const SizedBox(height: 2),
                    Text(hospital.address,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 13,
                            color: Color(0xFFBA7517)),
                        const SizedBox(width: 3),
                        Text(
                          '${hospital.rating}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          )),
                        Text(
                          ' (${hospital.reviews})',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textHint)),
                        const SizedBox(width: 8),
                        const Icon(
                            Icons.location_on_outlined,
                            size: 12,
                            color: AppColors.textHint),
                        Text(hospital.distance,
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textHint)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Specializations
          Wrap(
            spacing: 6, runSpacing: 4,
            children: hospital.specializations
                .take(3)
                .map((s) => Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.blueLight,
                    borderRadius:
                        BorderRadius.circular(6),
                  ),
                  child: Text(s,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blue,
                    )),
                ))
                .toList(),
          ),
          const SizedBox(height: 10),
          const Divider(
              color: Color(0xFFF0F4F8), height: 1),
          const SizedBox(height: 10),

          Row(
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text('₹${hospital.consultationFee}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.blue,
                    )),
                  const Text('consultation fee',
                    style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: hospital.isOpen
                      ? const Color(0xFFEAF3DE)
                      : const Color(0xFFFCEBEB),
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.circle,
                      size: 8,
                      color: hospital.isOpen
                          ? const Color(0xFF3B6D11)
                          : const Color(0xFFA32D2D)),
                    const SizedBox(width: 4),
                    Text(hospital.isOpen
                        ? '⏱ ${hospital.waitTime}'
                        : 'Closed',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: hospital.isOpen
                            ? const Color(0xFF3B6D11)
                            : const Color(0xFFA32D2D),
                      )),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: hospital.isOpen
                    ? onBook : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    color: hospital.isOpen
                        ? AppColors.blue
                        : AppColors.bgMuted,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  child: Text(
                    hospital.isOpen
                        ? 'Book OP'
                        : 'Closed',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: hospital.isOpen
                          ? Colors.white
                          : AppColors.textSecondary,
                    )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
