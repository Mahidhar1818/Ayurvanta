import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../models/medicine_model.dart';
import 'dart:math';

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel order;

  const OrderTrackingScreen({super.key, required this.order});

  // Helper to generate realistic timeline dates based on order date
  List<DateTime> _generateTrackingDates(DateTime orderDate) {
    return [
      orderDate,                                      // Placed
      orderDate.add(const Duration(hours: 12)),       // Packed
      orderDate.add(const Duration(days: 1)),         // Shipped
      orderDate.add(const Duration(days: 2, hours: 8)),// Out for delivery
      orderDate.add(const Duration(days: 2, hours: 14)),// Delivered
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Attempt to parse order date, or use current date minus 3 days
    DateTime baseDate;
    try {
      baseDate = DateFormat('MMM d, yyyy').parse(order.date);
    } catch (e) {
      baseDate = DateTime.now().subtract(const Duration(days: 3));
    }
    
    final trackingDates = _generateTrackingDates(baseDate);
    final currentStatusIndex = order.status.index; // 0: placed, 1: packed, 2: shipped, 3: delivered
    
    // We treat "Out for Delivery" as a step between shipped and delivered.
    // If status is delivered, we show all 5 steps.
    // If status is shipped, we show up to shipped (3 steps).
    int activeSteps = currentStatusIndex + 1;
    if (order.status == OrderStatus.delivered) {
      activeSteps = 5; // Includes Out for Delivery
    } else if (order.status == OrderStatus.shipped) {
      activeSteps = 3;
      // We could randomize if it's out for delivery if needed, but we stick to 3 for shipped
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.navyDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Order Tracking',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Container(
              color: AppColors.navyDark,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order #${order.orderNumber}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        Text('₹${order.totalAmount}',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppColors.teal)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(order.medicines.join(', '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
            
            // Expected Delivery Info
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Delivery Status',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text(
                    order.status == OrderStatus.delivered
                        ? 'Delivered on ${DateFormat('MMM d, h:mm a').format(trackingDates[4])}'
                        : 'Expected Delivery by ${DateFormat('MMM d').format(trackingDates[4])}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: order.status == OrderStatus.delivered
                            ? AppColors.teal
                            : AppColors.blue),
                  ),
                  const SizedBox(height: 32),
                  
                  // Tracking Timeline
                  _buildTimelineItem(
                    title: 'Order Placed',
                    subtitle: 'We have received your order',
                    date: trackingDates[0],
                    isCompleted: activeSteps >= 1,
                    isLastCompleted: activeSteps == 1,
                    isFirst: true,
                  ),
                  _buildTimelineItem(
                    title: 'Packed',
                    subtitle: 'Seller has packed your items',
                    date: trackingDates[1],
                    isCompleted: activeSteps >= 2,
                    isLastCompleted: activeSteps == 2,
                  ),
                  _buildTimelineItem(
                    title: 'Shipped',
                    subtitle: 'Your item has been picked up by courier partner',
                    date: trackingDates[2],
                    isCompleted: activeSteps >= 3,
                    isLastCompleted: activeSteps == 3,
                  ),
                  _buildTimelineItem(
                    title: 'Out for Delivery',
                    subtitle: 'Courier partner is out to deliver your order',
                    date: trackingDates[3],
                    isCompleted: activeSteps >= 4,
                    isLastCompleted: activeSteps == 4,
                  ),
                  _buildTimelineItem(
                    title: 'Delivered',
                    subtitle: 'Your order was safely delivered',
                    date: trackingDates[4],
                    isCompleted: activeSteps >= 5,
                    isLastCompleted: activeSteps == 5,
                    isLast: true,
                  ),
                ],
              ),
            ),

            // Delivery Address or Help Section
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE3EAF2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_on_rounded, color: AppColors.textHint, size: 28),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Delivery Address',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        SizedBox(height: 4),
                        Text('123 Health Avenue, Wellness District, Medical City - 500081',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required DateTime date,
    required bool isCompleted,
    required bool isLastCompleted,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final Color nodeColor = isCompleted ? AppColors.teal : const Color(0xFFD3DCE6);
    final Color lineColor = isCompleted && !isLastCompleted ? AppColors.teal : const Color(0xFFE3EAF2);
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column: Date & Time
          SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isCompleted || isLastCompleted) ...[
                  Text(DateFormat('MMM d').format(date),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: isLastCompleted ? FontWeight.bold : FontWeight.w600,
                          color: isLastCompleted ? AppColors.textPrimary : AppColors.textSecondary)),
                  const SizedBox(height: 2),
                  Text(DateFormat('h:mm a').format(date),
                      style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                ]
              ],
            ),
          ),
          
          // Middle Column: Node & Line
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: isLastCompleted ? 20 : 14,
                  height: isLastCompleted ? 20 : 14,
                  margin: EdgeInsets.only(top: isLastCompleted ? 0 : 3),
                  decoration: BoxDecoration(
                    color: nodeColor,
                    shape: BoxShape.circle,
                    border: isLastCompleted 
                        ? Border.all(color: AppColors.teal.withOpacity(0.3), width: 4)
                        : null,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: lineColor,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
              ],
            ),
          ),
          
          // Right Column: Title & Subtitle
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: isLastCompleted ? FontWeight.w800 : FontWeight.w600,
                          color: isCompleted ? AppColors.textPrimary : AppColors.textHint)),
                  const SizedBox(height: 4),
                  if (isCompleted)
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.3)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
