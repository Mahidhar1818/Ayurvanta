import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/translations/app_translations.dart';
import '../../../core/services/auth_preference_service.dart';
import 'module_selector_screen.dart';
import '../../home/screens/home_screen.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});
  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState
    extends State<LocationPermissionScreen> {
  bool _isLoading = false;

  Future<void> _requestLocation() async {
    setState(() => _isLoading = true);

    try {
      // Check if location services are enabled
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnack(AppTranslations.instance.tr('location_services_disabled'));
        setState(() => _isLoading = false);
        return;
      }

      // Check permission status
      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnack(AppTranslations.instance.tr('location_permission_denied'));
          setState(() => _isLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnack(AppTranslations.instance.tr('location_permission_permanently_denied'));
        setState(() => _isLoading = false);
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Save location
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('user_lat', position.latitude);
      await prefs.setDouble('user_lng', position.longitude);
      await prefs.setBool('location_granted', true);

      if (!mounted) return;
      _showSnack('${AppTranslations.instance.tr('location_access_granted')} ✅');
      await Future.delayed(const Duration(milliseconds: 800));
      _goHome();
    } catch (e) {
      _showSnack(AppTranslations.instance.tr('could_not_get_location'));
      setState(() => _isLoading = false);
    }
  }

  void _skipLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('location_granted', false);
    _goHome();
  }

  void _goHome() async {
    final loggedIn = await AuthPreferenceService.isLoggedIn();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => loggedIn ? const HomeScreen() : const ModuleSelectorScreen(),
      ),
      (_) => false,
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.navyMid,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),

              // Location icon with pulse
              FadeInDown(
                child: Container(
                  width: 110, height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.teal.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.teal.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: AppColors.teal,
                    size: 52,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Title
              FadeInUp(
                delay: const Duration(milliseconds: 100),
                child: Text(
                  AppTranslations.instance.tr('find_hospitals_near_you'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Description
              FadeInUp(
                delay: const Duration(milliseconds: 150),
                child: Text(
                  AppTranslations.instance.tr('allow_location_access_desc'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Feature cards
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Column(
                  children: [
                    _FeatureRow(
                      icon: Icons.local_hospital_rounded,
                      color: AppColors.blue,
                      title: AppTranslations.instance.tr('nearby_hospitals'),
                      subtitle: AppTranslations.instance.tr('see_hospitals_clinics'),
                    ),
                    const SizedBox(height: 10),
                    _FeatureRow(
                      icon: Icons.airport_shuttle_rounded,
                      color: AppColors.emergency,
                      title: AppTranslations.instance.tr('fast_ambulance_dispatch'),
                      subtitle: AppTranslations.instance.tr('emergency_sos_live_location'),
                    ),
                    const SizedBox(height: 10),
                    _FeatureRow(
                      icon: Icons.medication_rounded,
                      color: AppColors.teal,
                      title: AppTranslations.instance.tr('local_pharmacies'),
                      subtitle: AppTranslations.instance.tr('medicine_delivery_nearby'),
                    ),
                    const SizedBox(height: 10),
                    _FeatureRow(
                      icon: Icons.directions_rounded,
                      color: const Color(0xFF534AB7),
                      title: AppTranslations.instance.tr('navigation_directions'),
                      subtitle: AppTranslations.instance.tr('get_directions_instantly'),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Allow button
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _requestLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22, height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on_rounded, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                AppTranslations.instance.tr('allow_location_access'),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Skip button
              FadeInUp(
                delay: const Duration(milliseconds: 350),
                child: GestureDetector(
                  onTap: _skipLocation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      AppTranslations.instance.tr('skip_for_now'),
                      style: const TextStyle(
                        color: AppColors.textHint,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, subtitle;

  const _FeatureRow({
    required this.icon, required this.color,
    required this.title, required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Colors.white.withOpacity(0.08), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  )),
                const SizedBox(height: 2),
                Text(subtitle,
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 11,
                  )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
