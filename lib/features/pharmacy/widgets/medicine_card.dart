import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/medicine_model.dart';

class MedicineCard extends StatelessWidget {
  final MedicineModel medicine;
  final bool inCart;
  final VoidCallback onToggle;

  const MedicineCard({
    super.key,
    required this.medicine,
    required this.inCart,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: inCart
              ? AppColors.blue
              : const Color(0xFFE3EAF2),
          width: inCart ? 1.5 : 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Medicine image / emoji
          Container(
            width: double.infinity,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.bgPage,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(medicine.emoji,
                  style: const TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(height: 8),

          // Name
          Text(medicine.name,
            style: const TextStyle(fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),

          // Brand & pack
          Text('${medicine.brand} · ${medicine.pack}',
            style: const TextStyle(fontSize: 10,
                color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Rx badge
          if (medicine.requiresPrescription) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFAEEDA),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('Rx Required',
                style: TextStyle(fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF854F0B))),
            ),
          ],

          const Spacer(),

          // Price row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${medicine.price}',
                style: const TextStyle(fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blue)),
              const SizedBox(width: 5),
              Text('₹${medicine.originalPrice}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textHint,
                  decoration: TextDecoration.lineThrough,
                )),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3DE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('${medicine.discount}% off',
                  style: const TextStyle(fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3B6D11))),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Add to cart button
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: inCart ? AppColors.blue : AppColors.blueLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  inCart ? '✓ Added' : '+ Add to Cart',
                  style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700,
                    color: inCart ? Colors.white : AppColors.blue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
