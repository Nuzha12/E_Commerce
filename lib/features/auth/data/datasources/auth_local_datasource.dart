import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthLocalDataSource {
  static const _userKey = 'current_user';

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;
    return UserModel.fromJson(jsonDecode(raw));
  }

  Future<UserModel> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_userKey);

    if (existing != null) {
      final user = UserModel.fromJson(jsonDecode(existing));
      if (user.email == email) {
        return user;
      }
    }

    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Demo User',
      email: email,
    );

    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    return user;
  }

  Future<UserModel> register(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
    );
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    return user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}