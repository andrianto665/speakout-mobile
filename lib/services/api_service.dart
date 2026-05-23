import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }

  static Future<bool> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 && data['token'] != null) {
        await saveToken(data['token']);
        await _saveUserData(data['user']); // ✅ PENTING!
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('🔴 Login Error: $e');
      return false;
    }
  }

  static Future<bool> register(String name, String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password
        }),
      );
      return res.statusCode == 201;
    } catch (e) {
      debugPrint('🔴 Register Error: $e');
      return false;
    }
  }

  static Future<List<dynamic>> getCourses() async {
    try {
      final token = await getToken();
      final res = await http.get(
        Uri.parse('$baseUrl/courses'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
      return [];
    } catch (e) {
      debugPrint('🔴 Get Courses Error: $e');
      return [];
    }
  }

  static Future<bool> updateProgress(int courseId, int progress) async {
    try {
      final token = await getToken();
      final res = await http.post(
        Uri.parse('$baseUrl/courses/$courseId/progress'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode({'progress': progress}),
      );
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('🔴 Update Progress Error: $e');
      return false;
    }
  }

  static Future<void> logout() async => await clearAuth();

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // ✅ TAMBAHKAN METHOD INI
  static Future<String> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData == null) return 'user';
    
    try {
      final user = jsonDecode(userData);
      return user['role'] ?? 'user';
    } catch (e) {
      return 'user';
    }
  }

  // ✅ TAMBAHKAN METHOD INI
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData == null) return null;
    return jsonDecode(userData);
  }

  // ✅ METHOD PRIVATE INI HARUS ADA
  static Future<void> _saveUserData(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user));
  }
}