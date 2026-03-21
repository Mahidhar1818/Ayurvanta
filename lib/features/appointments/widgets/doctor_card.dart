import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/doctor_model.dart';
import '../screens/booking_confirm_screen.dart';

class DoctorCard extends StatefulWidget {
  final DoctorModel doctor;
  const DoctorCard({super.key, required this.doctor});
  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  String? _selectedSlot;

  @override
  Widget build(BuildContext context) {
    final d = widget.doctor;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        children: [
          // Doctor info row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54, height: 54,
                decoration: BoxDecoration(
                  color: d.color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(d.initials,
                    style: const TextStyle(color: Colors.white,
                        fontWeight: FontWeight.w700, fontSize: 16)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.name,
                      style: const TextStyle(fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(d.specialty,
                      style: const TextStyle(fontSize: 12,
                          color: AppColors.textSecondary)),
                    const SizedBox(height: 2),
                    Text(d.hospital,
                      style: const TextStyle(fontSize: 11,
                          color: AppColors.textHint)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (i) => Icon(
                            i < d.rating.floor()
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 13,
                            color: const Color(0xFFBA7517),
                          )),
                        ),
                        const SizedBox(width: 4),
                        Text(d.rating.toString(),
                          style: const TextStyle(fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                        const SizedBox(width: 4),
                        Text('(${d.reviews})',
                          style: const TextStyle(fontSize: 11,
                              color: AppColors.textHint)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF3DE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('${d.experience} yrs',
                            style: const TextStyle(fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3B6D11))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Time slots
          Wrap(
            spacing: 6, runSpacing: 6,
            children: d.slots.map((slot) {
              final isBooked = d.bookedSlots.contains(slot);
              final isSelected = _selectedSlot == slot;
              return GestureDetector(
                onTap: isBooked ? null : () =>
                    setState(() => _selectedSlot =
                        isSelected ? null : slot),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isBooked
                        ? const Color(0xFFF1EFE8)
                        : isSelected
                            ? AppColors.blue
                            : AppColors.blueLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(slot,
                    style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600,
                      color: isBooked
                          ? const Color(0xFF888780)
                          : isSelected
                              ? Colors.white
                              : AppColors.blue,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF0F4F8)),
          const SizedBox(height: 12),

          // Fee + Book button
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('₹${d.fee}',
                    style: const TextStyle(fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                  const Text('per consultation',
                    style: TextStyle(fontSize: 11,
                        color: AppColors.textSecondary)),
                ],
              ),
              const Spacer(),
              const Row(
                children: [
                  Icon(Icons.circle, size: 8,
                      color: Color(0xFF3B6D11)),
                  SizedBox(width: 4),
                  Text('Available Today',
                    style: TextStyle(fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3B6D11))),
                ],
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _selectedSlot == null ? null : () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => BookingConfirmScreen(
                      doctor: d,
                      selectedSlot: _selectedSlot!,
                    ),
                  ));
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    color: _selectedSlot != null
                        ? AppColors.blue
                        : AppColors.bgMuted,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('Book Now',
                    style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700,
                      color: _selectedSlot != null
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
