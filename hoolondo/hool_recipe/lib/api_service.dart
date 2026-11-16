import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Android emulator: 10.0.2.2, Chrome болон бусад: 127.0.0.1
  static String get baseUrl {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api/users';
    }
    return 'http://127.0.0.1:8000/api/users';
  }

  static const _json = {'Content-Type': 'application/json'};

  // Бүртгүүлэх
  static Future<bool> register(
      String username, String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: _json,
      body: jsonEncode(
          {'username': username, 'email': email, 'password': password}),
    );
    return res.statusCode == 201;
  }

  // Нэвтрэх: access token-оо утсанд хадгална
  static Future<bool> login(String username, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: _json,
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access', data['access']);
      await prefs.setString('refresh', data['refresh']);
      return true;
    }
    return false;
  }

  static Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access') ?? '';
    return {..._json, 'Authorization': 'Bearer $token'};
  }

  // Дуртай жагсаалт
  static Future<List<dynamic>> getFavorites() async {
    final res = await http.get(Uri.parse('$baseUrl/favorites/'),
        headers: await _authHeaders());
    if (res.statusCode == 200) return jsonDecode(utf8.decode(res.bodyBytes));
    return [];
  }

  static Future<bool> addFavorite(int recipeId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/favorites/'),
      headers: await _authHeaders(),
      body: jsonEncode({'recipe': recipeId}),
    );
    return res.statusCode == 201;
  }

  static Future<bool> removeFavorite(int favoriteId) async {
    final res = await http.delete(Uri.parse('$baseUrl/favorites/$favoriteId/'),
        headers: await _authHeaders());
    return res.statusCode == 204;
  }

  // Ангилал
  static Future<List<dynamic>> getCategories() async {
    final res = await http.get(Uri.parse('$baseUrl/categories/'));
    if (res.statusCode == 200) return jsonDecode(utf8.decode(res.bodyBytes));
    return [];
  }
}
