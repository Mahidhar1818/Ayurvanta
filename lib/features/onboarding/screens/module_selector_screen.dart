import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/app_module.dart';
import '../../../core/widgets/ayurvanta_logo.dart';
import '../../auth/screens/auth_screen.dart';
import '../../hospital/screens/hospital_role_selector_screen.dart';
import '../../pharmacy/screens/delivery_login_screen.dart';

class ModuleSelectorScreen extends StatelessWidget {
  const ModuleSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          Container(
            color: AppColors.navyDark,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 20, right: 20, bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  child: Row(
                    children: [
                      const AyurVantaLogo(size: 40, showText: false),
                      const SizedBox(width: 10),
                      const Text('AyurVanta',
                          style: TextStyle(color: Colors.white,
                              fontSize: 20, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                FadeInLeft(
                  delay: const Duration(milliseconds: 200),
                  child: const Text('Welcome! 👋',
                      style: TextStyle(color: Colors.white,
                          fontSize: 24, fontWeight: FontWeight.w800)),
                ),
                const SizedBox(height: 6),
                FadeInLeft(
                  delay: const Duration(milliseconds: 300),
                  child: const Text(
                      'Select your role to get started\n'
                          'with the right AyurVanta experience.',
                      style: TextStyle(color: AppColors.textHint,
                          fontSize: 13, height: 1.5)),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: AppModuleInfo.all.length,
                    itemBuilder: (_, i) {
                      final mod = AppModuleInfo.all[i];
                      return FadeInUp(
                        delay: Duration(milliseconds: i * 80),
                        child: _ModuleCard(
                          info: mod,
                          onTap: () {
                            if (mod.module == AppModule.delivery) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) =>
                                  const DeliveryLoginScreen()));
                            } else if (mod.module == AppModule.hospital) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) =>
                                  const HospitalRoleSelectorScreen()));
                            } else {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) =>
                                      AuthScreen(module: mod)));
                            }
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: const Color(0xFFE3EAF2), width: 0.5),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline_rounded,
                              color: AppColors.textSecondary, size: 16),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Each module has its own account. '
                                  'Your Ayur ID works across all of them.',
                              style: TextStyle(fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final AppModuleInfo info;
  final VoidCallback onTap;
  const _ModuleCard({required this.info, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: info.bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: info.borderColor, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: info.iconBg,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Center(child: Text(info.emoji,
                  style: const TextStyle(fontSize: 22))),
            ),
            const Spacer(),
            Text(info.name,
                style: TextStyle(fontSize: 15,
                    fontWeight: FontWeight.w800, color: info.textColor)),
            const SizedBox(height: 4),
            Text(info.description,
                style: TextStyle(fontSize: 10,
                    color: info.textColor.withOpacity(0.65), height: 1.4),
                maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
