import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferenceService {
  static const _keyModule    = 'selected_module';
  static const _keyLoggedIn  = 'is_logged_in';
  static const _keyUserName  = 'user_name';
  static const _keyUserEmail = 'user_email';

  // Save selected module
  static Future<void> saveModule(String module) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyModule, module);
  }

  // Get saved module
  static Future<String?> getSavedModule() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyModule);
  }

  // Save login state
  static Future<void> saveLoginState({
    required String name,
    required String email,
    required String module,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyModule, module);
  }

  // Check if logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  // Get user name
  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName) ?? 'User';
  }

  // Logout — clear all
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
