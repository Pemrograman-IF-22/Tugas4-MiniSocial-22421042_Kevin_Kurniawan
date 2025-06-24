import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_data';

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      await saveToken('dummy_token');
      await saveUser({
        'name': 'User',
        'email': email,
      });
      return true;
    } catch (e) {
      debugPrint('Error Login: $e');
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await saveToken('dummy_token');
      await saveUser({
        'name': name,
        'email': email,
      });
      return true;
    } catch (e) {
      debugPrint('Error Register: $e');
      return false;
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> saveUser(Map<String, String> user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user);
    await prefs.setString(_userKey, jsonString);
  }

  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);
    if (jsonString == null) return null;

    try {
      final Map<String, dynamic> userMap = jsonDecode(jsonString);
      return userMap;
    } catch (e) {
      debugPrint('Error decoding user data: $e');
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
      return true;
    } catch (e) {
      debugPrint('Logout error: $e');
      return false;
    }
  }
}
