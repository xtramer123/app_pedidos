import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/usuario.dart';

class SessionStore {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> saveSession(String token, Usuario user) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
  }

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<Usuario?> getUser() async {
    final raw = await _storage.read(key: _userKey);
    if (raw == null) return null;
    return Usuario.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}
