import 'package:flutter/material.dart';

class AyurVantaLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? textColor;

  const AyurVantaLogo({
    Key? key,
    this.size = 60,
    this.showText = true,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: Image.asset(
              'assets/logo/ayurvanta_logo.jpeg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1A5F7A),
                        Color(0xFF159957),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'AV',
                      style: TextStyle(
                        fontSize: size * 0.4,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (showText) ...[
          SizedBox(height: 8),
          Text(
            'AyurVanta',
            style: TextStyle(
              fontSize: size * 0.3,
              fontWeight: FontWeight.bold,
              color: textColor ?? Color(0xFF1A5F7A),
              letterSpacing: 1.2,
            ),
          ),
          Text(
            'ADVANCED HEALTH SOLUTIONS',
            style: TextStyle(
              fontSize: size * 0.12,
              fontWeight: FontWeight.w500,
              color: textColor?.withOpacity(0.7) ?? Colors.grey[600],
              letterSpacing: 0.8,
            ),
          ),
        ],
      ],
    );
  }
}
