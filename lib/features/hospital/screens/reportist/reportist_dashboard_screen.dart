import 'package:flutter/material.dart';

class ReportistDashboardScreen extends StatelessWidget {
  const ReportistDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1A2C),
      body: const Center(
        child: Text('Reportist Dashboard\n(Coming Soon)',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}