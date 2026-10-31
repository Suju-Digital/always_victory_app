import 'dart:convert';

import 'package:always_victory/helpers/debug_loger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/carousel_model.dart';
import '../models/class_model.dart';
import '../models/ebook_model.dart';
import '../models/progress_model.dart';
import '../models/review_model.dart';

class LocalStorage {
  LocalStorage._();

  static SharedPreferences? _prefs;

  /// Fast initialization during app launch in main()
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ================= KEYS =================
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _isOnboardingDoneKey = 'is_onboarding_done';
  static const String _isStudentKey = 'studentKey';

  static const String _classesKey = 'cached_classes';
  static const String _carouselKey = 'cached_carousel';
  static const String _ebooksKey = 'cached_ebooks';
  static const String _purchasedClassesKey = 'cached_purchased_classes';
  static const String _purchasedBooksKey = 'cached_purchased_books';
  static const String _enrollmentCountsKey = 'cached_enrollment_counts';
  static const String _reviewsKey = 'cached_reviews';
  static const String _progressKey = 'cached_progress';
  static const String _hasShownAnnouncementKey = 'has_shown_announcement';
  static const String _hasPlayedVoiceGreetingKey = 'has_played_voice_greeting';

  // ================= AUTH & USER =================

  /// Save Login Status
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await _instance;
    await prefs.setBool(_isLoggedInKey, value);
  }

  /// Get Login Status
  static Future<bool> isLoggedIn() async {
    final prefs = await _instance;
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// Save Onboarding Status
  static Future<void> setOnboardingDone(bool value) async {
    final prefs = await _instance;
    await prefs.setBool(_isOnboardingDoneKey, value);
  }

  /// Get Onboarding Status
  static Future<bool> isOnboardingDone() async {
    final prefs = await _instance;
    return prefs.getBool(_isOnboardingDoneKey) ?? false;
  }

  /// Logout User
  static Future<void> logout() async {
    final prefs = await _instance;
    await prefs.setBool(_isLoggedInKey, false);
  }

  /// Clear Everything
  static Future<void> clear() async {
    final prefs = await _instance;
    await prefs.clear();
  }

  static Future<void> saveStudent(Map<String, dynamic> data) async {
    final prefs = await _instance;
    await prefs.setString(_isStudentKey, jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> getStudent() async {
    final prefs = await _instance;
    final studentJson = prefs.getString(_isStudentKey);
    if (studentJson == null) return null;
    try {
      return jsonDecode(studentJson) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // ================= CACHED HOME DATA =================

  /// Cache Classes
  static Future<void> saveClasses(List<ClassModel> list) async {
    try {
      final prefs = await _instance;
      final encoded = jsonEncode(list.map((e) => e.toJson()).toList());
      await prefs.setString(_classesKey, encoded);
    } catch (e) {
      AppLog.error("saveClasses cache error: $e");
    }
  }

  /// Get Cached Classes
  static Future<List<ClassModel>> getClasses() async {
    try {
      final prefs = await _instance;
      final raw = prefs.getString(_classesKey);
      if (raw == null || raw.isEmpty) return [];
      final List<dynamic> decoded = jsonDecode(raw);
      return decoded.map((e) => ClassModel.fromJson(e)).toList();
    } catch (e) {
      AppLog.error("getClasses cache error: $e");
      return [];
    }
  }

  /// Cache Carousel Banners
  static Future<void> saveCarousel(List<CarouselModel> list) async {
    try {
      final prefs = await _instance;
      final encoded = jsonEncode(list.map((e) => e.toJson()).toList());
      await prefs.setString(_carouselKey, encoded);
    } catch (e) {
      AppLog.error("saveCarousel cache error: $e");
    }
  }

  /// Get Cached Carousel Banners
  static Future<List<CarouselModel>> getCarousel() async {
    try {
      final prefs = await _instance;
      final raw = prefs.getString(_carouselKey);
      if (raw == null || raw.isEmpty) return [];
      final List<dynamic> decoded = jsonDecode(raw);
      return decoded.map((e) => CarouselModel.fromJson(e)).toList();
    } catch (e) {
      AppLog.error("getCarousel cache error: $e");
      return [];
    }
  }

  /// Cache Ebooks
  static Future<void> saveEbooks(List<EbookModel> list) async {
    try {
      final prefs = await _instance;
      final encoded = jsonEncode(list.map((e) => e.toJson()).toList());
      await prefs.setString(_ebooksKey, encoded);
    } catch (e) {
      AppLog.error("saveEbooks cache error: $e");
    }
  }

  /// Get Cached Ebooks
  static Future<List<EbookModel>> getEbooks() async {
    try {
      final prefs = await _instance;
      final raw = prefs.getString(_ebooksKey);
      if (raw == null || raw.isEmpty) return [];
      final List<dynamic> decoded = jsonDecode(raw);
      return decoded.map((e) => EbookModel.fromJson(e)).toList();
    } catch (e) {
      AppLog.error("getEbooks cache error: $e");
      return [];
    }
  }

  /// Cache Purchased Classes Map
  static Future<void> savePurchasedClasses(Map<int, bool> map) async {
    try {
      final prefs = await _instance;
      final stringKeyMap = map.map((k, v) => MapEntry(k.toString(), v));
      await prefs.setString(_purchasedClassesKey, jsonEncode(stringKeyMap));
    } catch (e) {
      AppLog.error("savePurchasedClasses cache error: $e");
    }
  }

  /// Get Cached Purchased Classes Map
  static Future<Map<int, bool>> getPurchasedClasses() async {
    try {
      final prefs = await _instance;
      final raw = prefs.getString(_purchasedClassesKey);
      if (raw == null || raw.isEmpty) return {};
      final Map<String, dynamic> decoded = jsonDecode(raw);
      return decoded.map((k, v) => MapEntry(int.tryParse(k) ?? 0, v == true));
    } catch (e) {
      AppLog.error("getPurchasedClasses cache error: $e");
      return {};
    }
  }

  /// Cache Purchased Books Map
  static Future<void> savePurchasedBooks(Map<int, bool> map) async {
    try {
      final prefs = await _instance;
      final stringKeyMap = map.map((k, v) => MapEntry(k.toString(), v));
      await prefs.setString(_purchasedBooksKey, jsonEncode(stringKeyMap));
    } catch (e) {
      AppLog.error("savePurchasedBooks cache error: $e");
    }
  }

  /// Get Cached Purchased Books Map
  static Future<Map<int, bool>> getPurchasedBooks() async {
    try {
      final prefs = await _instance;
      final raw = prefs.getString(_purchasedBooksKey);
      if (raw == null || raw.isEmpty) return {};
      final Map<String, dynamic> decoded = jsonDecode(raw);
      return decoded.map((k, v) => MapEntry(int.tryParse(k) ?? 0, v == true));
    } catch (e) {
      AppLog.error("getPurchasedBooks cache error: $e");
      return {};
    }
  }

  /// Cache Enrollment Counts Map
  static Future<void> saveEnrollmentCounts(Map<int, int> map) async {
    try {
      final prefs = await _instance;
      final stringKeyMap = map.map((k, v) => MapEntry(k.toString(), v));
      await prefs.setString(_enrollmentCountsKey, jsonEncode(stringKeyMap));
    } catch (e) {
      AppLog.error("saveEnrollmentCounts cache error: $e");
    }
  }

  /// Get Cached Enrollment Counts Map
  static Future<Map<int, int>> getEnrollmentCounts() async {
    try {
      final prefs = await _instance;
      final raw = prefs.getString(_enrollmentCountsKey);
      if (raw == null || raw.isEmpty) return {};
      final Map<String, dynamic> decoded = jsonDecode(raw);
      return decoded.map((k, v) => MapEntry(int.tryParse(k) ?? 0, (v as num).toInt()));
    } catch (e) {
      AppLog.error("getEnrollmentCounts cache error: $e");
      return {};
    }
  }

  /// Cache Reviews
  static Future<void> saveReviews(List<ReviewModel> list) async {
    try {
      final prefs = await _instance;
      final encoded = jsonEncode(list.map((e) => e.toJson()).toList());
      await prefs.setString(_reviewsKey, encoded);
    } catch (e) {
      AppLog.error("saveReviews cache error: $e");
    }
  }

  /// Get Cached Reviews
  static Future<List<ReviewModel>> getReviews() async {
    try {
      final prefs = await _instance;
      final raw = prefs.getString(_reviewsKey);
      if (raw == null || raw.isEmpty) return [];
      final List<dynamic> decoded = jsonDecode(raw);
      return decoded.map((e) => ReviewModel.fromJson(e)).toList();
    } catch (e) {
      AppLog.error("getReviews cache error: $e");
      return [];
    }
  }

  /// Cache Progress
  static Future<void> saveProgress(List<ProgressModel> list) async {
    try {
      final prefs = await _instance;
      final encoded = jsonEncode(list.map((e) => e.toJson()).toList());
      await prefs.setString(_progressKey, encoded);
    } catch (e) {
      AppLog.error("saveProgress cache error: $e");
    }
  }

  /// Get Cached Progress
  static Future<List<ProgressModel>> getProgress() async {
    try {
      final prefs = await _instance;
      final raw = prefs.getString(_progressKey);
      if (raw == null || raw.isEmpty) return [];
      final List<dynamic> decoded = jsonDecode(raw);
      return decoded.map((e) => ProgressModel.fromJson(e)).toList();
    } catch (e) {
      AppLog.error("getProgress cache error: $e");
      return [];
    }
  }

  /// Has Announcement Popup been shown on this installation
  static Future<bool> hasShownAnnouncement() async {
    final prefs = await _instance;
    return prefs.getBool(_hasShownAnnouncementKey) ?? false;
  }

  /// Mark Announcement Popup as permanently shown
  static Future<void> setAnnouncementShown() async {
    final prefs = await _instance;
    await prefs.setBool(_hasShownAnnouncementKey, true);
  }

  /// Has Voice Greeting been played on this installation
  static Future<bool> hasPlayedVoiceGreeting() async {
    final prefs = await _instance;
    return prefs.getBool(_hasPlayedVoiceGreetingKey) ?? false;
  }

  /// Mark Voice Greeting as permanently played
  static Future<void> setVoiceGreetingPlayed() async {
    final prefs = await _instance;
    await prefs.setBool(_hasPlayedVoiceGreetingKey, true);
  }

  /// Cache Completed Days for a Student and Class
  static Future<void> saveCompletedDays(
      String studentId, int classId, Set<int> dayIds) async {
    try {
      final prefs = await _instance;
      await prefs.setStringList(
        'completed_days_${studentId}_$classId',
        dayIds.map((e) => e.toString()).toList(),
      );
    } catch (e) {
      AppLog.error("saveCompletedDays cache error: $e");
    }
  }

  /// Get Cached Completed Days for a Student and Class
  static Future<Set<int>> getCompletedDays(
      String studentId, int classId) async {
    try {
      final prefs = await _instance;
      final list = prefs.getStringList('completed_days_${studentId}_$classId');
      if (list == null) return {};
      return list.map((e) => int.tryParse(e)).whereType<int>().toSet();
    } catch (e) {
      AppLog.error("getCompletedDays cache error: $e");
      return {};
    }
  }
}
