import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/medicine_model.dart';

class CartSheet extends StatelessWidget {
  final List<String> cartIds;
  final List<MedicineModel> medicines;
  final ValueChanged<String> onRemove;

  const CartSheet({
    super.key,
    required this.cartIds,
    required this.medicines,
    required this.onRemove,
  });

  List<MedicineModel> get _items => medicines
      .where((m) => cartIds.contains(m.id))
      .toList();

  int get _total =>
      _items.fold(0, (sum, m) => sum + m.price);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE3EAF2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 18),

          // Title
          Row(
            children: [
              const Text('Your Cart',
                style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.blueLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${_items.length} items',
                  style: const TextStyle(fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Items
          if (_items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 48, color: AppColors.textHint),
                  SizedBox(height: 12),
                  Text('Your cart is empty',
                    style: TextStyle(color: AppColors.textSecondary,
                        fontSize: 15)),
                ],
              ),
            )
          else ...[
            ..._items.map((m) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgPage,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(m.emoji,
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.name,
                          style: const TextStyle(fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                        Text(m.pack,
                          style: const TextStyle(fontSize: 11,
                              color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Text('₹${m.price}',
                    style: const TextStyle(fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.blue)),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => onRemove(m.id),
                    child: const Icon(Icons.close_rounded,
                        size: 18, color: AppColors.textHint),
                  ),
                ],
              ),
            )),

            const Divider(color: Color(0xFFE3EAF2)),
            const SizedBox(height: 8),

            // Total
            Row(
              children: [
                const Text('Total',
                  style: TextStyle(fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
                const Spacer(),
                Text('₹$_total',
                  style: const TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blue)),
              ],
            ),
            const SizedBox(height: 16),

            // Checkout button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Checkout · ₹$_total',
                  style: const TextStyle(fontSize: 15,
                      fontWeight: FontWeight.w700)),
              ),
            ),
          ],
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
