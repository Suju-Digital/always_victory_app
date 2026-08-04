import 'dart:convert';
import 'dart:io';

import 'package:always_victory/data/app_config/app_config.dart';
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
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers(token: token),
      );
      print("URL => $baseUrl$endpoint");
      print("STATUS => ${response.statusCode}");
      print("BODY => ${response.body}");
      return _handleResponse(response);
    } on SocketException {
      throw Exception('No Internet Connection');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ================= POST =================

  static Future<dynamic> post(
      String endpoint, {
        Map<String, dynamic>? body,
        String? token,
      }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers(token: token),
        body: jsonEncode(body ?? {}),
      );
      print("URL => $baseUrl$endpoint");
      print("STATUS => ${response.statusCode}");
      print("BODY => ${response.body}");
      return _handleResponse(response);
    } on SocketException {
      throw Exception('No Internet Connection');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ================= PUT =================

  static Future<dynamic> put(
      String endpoint, {
        Map<String, dynamic>? body,
        String? token,
      }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers(token: token),
        body: jsonEncode(body ?? {}),
      );

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No Internet Connection');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ================= DELETE =================

  static Future<dynamic> delete(
      String endpoint, {
        String? token,
      }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers(token: token),
      );

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No Internet Connection');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ================= RESPONSE HANDLER =================

  static dynamic _handleResponse(
      http.Response response,
      ) {

    final data = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        return data;

      case 400:
        throw Exception(
          data['message'] ?? 'Bad Request',
        );

      case 401:
        throw Exception(
          data['message'] ?? 'Unauthorized',
        );

      case 403:
        throw Exception(
          data['message'] ?? 'Forbidden',
        );

      case 404:
        throw Exception(
          data['message'] ?? 'Not Found',
        );

      case 500:
        throw Exception(
          data['message'] ?? 'Server Error',
        );

      default:
        throw Exception(
          'Error: ${response.statusCode}',
        );
    }
  }
}