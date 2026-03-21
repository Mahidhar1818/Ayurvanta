import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class VoiceWaveBars extends StatefulWidget {
  final bool isActive;
  final Color? color;
  final int barCount;

  const VoiceWaveBars({
    super.key,
    required this.isActive,
    this.color,
    this.barCount = 10,
  });

  @override
  State<VoiceWaveBars> createState() => _VoiceWaveBarsState();
}

class _VoiceWaveBarsState extends State<VoiceWaveBars>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.barCount; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400 + (i * 80)),
      );
      final anim = Tween<double>(begin: 0.2, end: 1.0).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.easeInOut),
      );
      _controllers.add(ctrl);
      _animations.add(anim);
    }
  }

  @override
  void didUpdateWidget(VoiceWaveBars old) {
    super.didUpdateWidget(old);
    if (widget.isActive != old.isActive) {
      if (widget.isActive) {
        for (final c in _controllers) {
          c.repeat(reverse: true);
        }
      } else {
        for (final c in _controllers) {
          c.stop();
          c.reset();
        }
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barColor = widget.color ?? AppColors.blue;
    final heights = [8.0, 16.0, 24.0, 18.0, 28.0,
        22.0, 12.0, 26.0, 14.0, 20.0];

    return SizedBox(
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(widget.barCount, (i) {
          return AnimatedBuilder(
            animation: _animations[i],
            builder: (_, __) {
              final h = widget.isActive
                  ? heights[i % heights.length] *
                      _animations[i].value
                  : 4.0;
              return Container(
                width: 4,
                height: h,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: barColor.withOpacity(
                      widget.isActive ? 0.9 : 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
