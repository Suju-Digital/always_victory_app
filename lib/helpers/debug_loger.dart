import 'dart:convert';

import 'package:flutter/foundation.dart';

class AppLog {
  static void success(String message) {
    if (kDebugMode) {
      debugPrint('🟢 SUCCESS: $message');
    }
  }

  static void error(
      dynamic error, {
        StackTrace? stackTrace,
      }) {
    if (kDebugMode) {
      debugPrint('🔴 ERROR: $error');

      if (stackTrace != null) {
        debugPrint('📍 STACKTRACE:\n$stackTrace');
      }
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      debugPrint('🟡 WARNING: $message');
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      debugPrint('🔵 INFO: $message');
    }
  }



  static void response(dynamic data) {
    if (kDebugMode) {
      final encoder = JsonEncoder.withIndent('  ');
      final prettyJson = encoder.convert(data);

      debugPrint('📦 RESPONSE:\n$prettyJson');
    }
  }

  static void request(
      String url, {
        dynamic body,
      }) {
    if (kDebugMode) {
      debugPrint('🚀 REQUEST: $url');
      debugPrint('📤 BODY: $body');
    }
  }
}