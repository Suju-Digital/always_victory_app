import 'dart:convert';
import 'dart:io';

import 'package:always_victory/data/app_config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  static const String baseUrl = AppConfig.baseUrl;

  static Map<String, String> headers({
    String? token,
  }) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ================= GET =================

  static Future<dynamic> get(
    String endpoint, {
    String? token,
  }) async {
    try {
      final safeUrl = Uri.encodeFull('$baseUrl$endpoint');
      final response = await http.get(
        Uri.parse(safeUrl),
        headers: headers(token: token),
      );
      debugPrint("URL => $safeUrl");
      debugPrint("STATUS => ${response.statusCode}");
      debugPrint("BODY => ${response.body}");
      return _handleResponse(response);
    } on SocketException {
      return {'status': false, 'message': 'No Internet Connection'};
    } catch (e) {
      debugPrint("GET Error => $e");
      return {'status': false, 'message': e.toString()};
    }
  }

  // ================= POST =================

  static Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final safeUrl = Uri.encodeFull('$baseUrl$endpoint');
      final response = await http.post(
        Uri.parse(safeUrl),
        headers: headers(token: token),
        body: jsonEncode(body ?? {}),
      );
      debugPrint("URL => $safeUrl");
      debugPrint("STATUS => ${response.statusCode}");
      debugPrint("BODY => ${response.body}");
      return _handleResponse(response);
    } on SocketException {
      return {'status': false, 'message': 'No Internet Connection'};
    } catch (e) {
      debugPrint("POST Error => $e");
      return {'status': false, 'message': e.toString()};
    }
  }

  // ================= PUT =================

  static Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final safeUrl = Uri.encodeFull('$baseUrl$endpoint');
      final response = await http.put(
        Uri.parse(safeUrl),
        headers: headers(token: token),
        body: jsonEncode(body ?? {}),
      );

      return _handleResponse(response);
    } on SocketException {
      return {'status': false, 'message': 'No Internet Connection'};
    } catch (e) {
      return {'status': false, 'message': e.toString()};
    }
  }

  // ================= DELETE =================

  static Future<dynamic> delete(
    String endpoint, {
    String? token,
  }) async {
    try {
      final safeUrl = Uri.encodeFull('$baseUrl$endpoint');
      final response = await http.delete(
        Uri.parse(safeUrl),
        headers: headers(token: token),
      );

      return _handleResponse(response);
    } on SocketException {
      return {'status': false, 'message': 'No Internet Connection'};
    } catch (e) {
      return {'status': false, 'message': e.toString()};
    }
  }

  // ================= RESPONSE HANDLER =================

  static dynamic _handleResponse(http.Response response) {
    try {
      final bodyText = response.body.trim();
      if (bodyText.isEmpty) {
        return {
          'status': false,
          'message': 'Empty response from server (HTTP ${response.statusCode})',
        };
      }

      final data = jsonDecode(bodyText);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      }

      if (data is Map) {
        return {
          'status': false,
          'message': data['message'] ?? 'Server error (${response.statusCode})',
          'data': data['data'] ?? [],
        };
      }

      return {
        'status': false,
        'message': 'Error ${response.statusCode}',
      };
    } catch (e) {
      debugPrint("JSON Decode Error => $e");
      return {
        'status': false,
        'message': 'Invalid response format (${response.statusCode})',
      };
    }
  }
}
