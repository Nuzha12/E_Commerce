import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth/data/models/user_model.dart';

class ProfileLocalDataSource {
  static const _userKey = 'current_user';

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;
    return UserModel.fromJson(jsonDecode(raw));
  }

  Future<UserModel> updateProfile({
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getUser();
    final updated = UserModel(
      id: current?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
    );
    await prefs.setString(_userKey, jsonEncode(updated.toJson()));
    return updated;
  }
}