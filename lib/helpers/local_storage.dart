import 'dart:convert';

import 'package:always_victory/helpers/debug_loger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._();

  static const String _isLoggedInKey = 'is_logged_in';
  static const String _isOnboardingDoneKey = 'is_onboarding_done';
  static const String _isStudentKey= 'studentKey';

  /// Save Login Status
  static Future<void> setLoggedIn(bool value) async {
    AppLog.info("Login set.....................");

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  /// Get Login Status
  static Future<bool> isLoggedIn() async {
    AppLog.info("Login Loading.....................");

    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// Save Onboarding Status
  static Future<void> setOnboardingDone(bool value) async {
    AppLog.info("onBoarding set.....................");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isOnboardingDoneKey, value);
  }

  /// Get Onboarding Status
  static Future<bool> isOnboardingDone() async {
    AppLog.info("onBoarding Loading.....................");

    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isOnboardingDoneKey) ?? false;
  }

  /// Logout User
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
  }

  /// Clear Everything
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> saveStudent(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_isStudentKey, jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> getStudent() async {
    final prefs = await SharedPreferences.getInstance();

    final studentJson = prefs.getString(_isStudentKey);

    if (studentJson == null) return null;

    return jsonDecode(studentJson) as Map<String, dynamic>;
  }

}