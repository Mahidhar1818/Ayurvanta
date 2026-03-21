import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SosPulseButton extends StatefulWidget {
  final bool activated;
  const SosPulseButton({super.key, this.activated = false});
  @override
  State<SosPulseButton> createState() => _SosPulseButtonState();
}

class _SosPulseButtonState extends State<SosPulseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _ring1;
  late Animation<double> _ring2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _ring1 = Tween<double>(begin: 0.85, end: 1.3)
        .animate(CurvedAnimation(
            parent: _controller, curve: Curves.easeOut));

    _ring2 = Tween<double>(begin: 0.85, end: 1.5)
        .animate(CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 1.0,
                curve: Curves.easeOut)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring 2
          AnimatedBuilder(
            animation: _ring2,
            builder: (_, __) => Transform.scale(
              scale: _ring2.value,
              child: Container(
                width: 160, height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.emergency.withOpacity(
                        1 - (_ring2.value - 0.85) / 0.65),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // Outer ring 1
          AnimatedBuilder(
            animation: _ring1,
            builder: (_, __) => Transform.scale(
              scale: _ring1.value,
              child: Container(
                width: 140, height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.emergency.withOpacity(
                        1 - (_ring1.value - 0.85) / 0.45),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          // Core button
          Container(
            width: 130, height: 130,
            decoration: BoxDecoration(
              color: widget.activated
                  ? const Color(0xFF1D9E75)
                  : AppColors.emergency,
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.activated
                      ? Icons.check_rounded
                      : Icons.emergency_share_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(height: 6),
                Text(
                  widget.activated ? 'SENT' : 'SOS',
                  style: const TextStyle(
                    color: Colors.white, fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
