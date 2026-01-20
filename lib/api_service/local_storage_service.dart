import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile/models/user_model.dart';

class LocalStorageService {
  static const String _userDataKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  // Save user data to local storage
  static Future<bool> saveUserData(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = json.encode(user.toJson());
      await prefs.setString(_userDataKey, userJson);
      await prefs.setBool(_isLoggedInKey, true);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get user data from local storage
  static Future<UserModel?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userDataKey);

      if (userJson == null) return null;

      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  // Clear user data (logout)
  static Future<bool> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userDataKey);
      await prefs.setBool(_isLoggedInKey, false);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Save individual preference
  static Future<bool> saveString(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(key, value);
    } catch (e) {
      return false;
    }
  }

  // Get individual preference
  static Future<String?> getString(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      return null;
    }
  }
}
