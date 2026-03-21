import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/medicine_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  const OrderCard({super.key, required this.order});

  String get _statusText {
    switch (order.status) {
      case OrderStatus.placed:    return 'Order Placed';
      case OrderStatus.packed:    return 'Packed';
      case OrderStatus.shipped:   return 'On the way';
      case OrderStatus.delivered: return 'Delivered';
    }
  }

  Color get _statusColor {
    switch (order.status) {
      case OrderStatus.delivered: return const Color(0xFF3B6D11);
      case OrderStatus.shipped:   return AppColors.blue;
      default:                    return const Color(0xFF854F0B);
    }
  }

  Color get _statusBg {
    switch (order.status) {
      case OrderStatus.delivered: return const Color(0xFFEAF3DE);
      case OrderStatus.shipped:   return AppColors.blueLight;
      default:                    return const Color(0xFFFAEEDA);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stepsDone = order.status.index + 1;

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
          // Order header
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: AppColors.blueLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.inventory_2_outlined,
                    color: AppColors.blue, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${order.medicines.length} Medicine${order.medicines.length > 1 ? 's' : ''} · ₹${order.totalAmount}',
                      style: const TextStyle(fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text('Order #${order.orderNumber} · ${order.date}',
                      style: const TextStyle(fontSize: 11,
                          color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_statusText,
                  style: TextStyle(fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFF0F4F8), height: 1),
          const SizedBox(height: 12),

          // Tracking steps
          Row(
            children: [
              _TrackStep(
                  label: 'Placed',
                  icon: Icons.check_circle_rounded,
                  isDone: stepsDone >= 1,
                  isActive: stepsDone == 1),
              _TrackLine(isDone: stepsDone >= 2),
              _TrackStep(
                  label: 'Packed',
                  icon: Icons.inventory_rounded,
                  isDone: stepsDone >= 2,
                  isActive: stepsDone == 2),
              _TrackLine(isDone: stepsDone >= 3),
              _TrackStep(
                  label: 'Shipped',
                  icon: Icons.local_shipping_rounded,
                  isDone: stepsDone >= 3,
                  isActive: stepsDone == 3),
              _TrackLine(isDone: stepsDone >= 4),
              _TrackStep(
                  label: 'Delivered',
                  icon: Icons.home_rounded,
                  isDone: stepsDone >= 4,
                  isActive: stepsDone == 4),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrackStep extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDone, isActive;
  const _TrackStep({required this.label, required this.icon,
      required this.isDone, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isDone ? AppColors.teal
        : isActive ? AppColors.blue
        : const Color(0xFFE3EAF2);
    return Column(
      children: [
        Container(
          width: 26, height: 26,
          decoration: BoxDecoration(
              color: color, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 13),
        ),
        const SizedBox(height: 4),
        Text(label,
          style: TextStyle(fontSize: 9,
              fontWeight: FontWeight.w600,
              color: isDone || isActive
                  ? AppColors.textPrimary
                  : AppColors.textHint)),
      ],
    );
  }
}

class _TrackLine extends StatelessWidget {
  final bool isDone;
  const _TrackLine({required this.isDone});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 18),
        color: isDone ? AppColors.teal : const Color(0xFFE3EAF2),
      ),
    );
  }
}
