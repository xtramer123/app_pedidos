import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/api_config.dart';
import '../models/almuerzo.dart';
import '../models/usuario.dart';
import 'session_store.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});
  @override
  String toString() => message;
}

class ApiService {
  final SessionStore _session;
  ApiService(this._session);

  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (auth) {
      final token = await _session.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  dynamic _decode(http.Response res) {
    if (res.body.isEmpty) return null;
    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  ApiException _error(http.Response res) {
    final body = _decode(res);
    final detail = body is Map && body['detail'] != null ? body['detail'].toString() : 'Error ${res.statusCode}';
    return ApiException(detail, statusCode: res.statusCode);
  }

  Usuario _userFromToken(String token, {String? fallbackName, String? fallbackEmail}) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) throw Exception();
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final map = jsonDecode(payload) as Map<String, dynamic>;
      return Usuario(
        id: int.tryParse(map['sub']?.toString() ?? ''),
        nombre: (map['nombre'] ?? fallbackName ?? 'Usuario') as String,
        email: (map['email'] ?? fallbackEmail ?? '') as String,
        rol: (map['rol'] ?? 'USER') as String,
      );
    } catch (_) {
      return Usuario(nombre: fallbackName ?? 'Usuario', email: fallbackEmail ?? '', rol: 'USER');
    }
  }

  Future<Usuario> register({
    required String nombre,
    required String email,
    required String password,
    String rol = 'USER',
  }) async {
    final res = await http.post(
      _uri('/auth/register'),
      headers: await _headers(),
      body: jsonEncode({'nombre': nombre, 'email': email, 'password': password, 'rol': rol}),
    );
    if (res.statusCode != 201) throw _error(res);
    final data = _decode(res) as Map<String, dynamic>;
    final token = data['access_token'] as String;
    final user = _userFromToken(token, fallbackName: nombre, fallbackEmail: email);
    await _session.saveSession(token, user);
    return user;
  }

  Future<Usuario> login({required String email, required String password}) async {
    final res = await http.post(
      _uri('/auth/login'),
      headers: await _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode != 200) throw _error(res);
    final data = _decode(res) as Map<String, dynamic>;
    final token = data['access_token'] as String;
    final user = _userFromToken(token, fallbackEmail: email);
    await _session.saveSession(token, user);
    return user;
  }

  Future<void> logout() => _session.clear();

  Future<List<Almuerzo>> getAlmuerzos() async {
    final res = await http.get(_uri('/almuerzos'), headers: await _headers(auth: true));
    if (res.statusCode == 401) throw ApiException('Sesión expirada', statusCode: 401);
    if (res.statusCode != 200) throw _error(res);
    final list = _decode(res) as List<dynamic>;
    return list.map((e) => Almuerzo.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Almuerzo> createAlmuerzo({
    required String cliente,
    required String plato,
    required int cantidad,
    required double precio,
  }) async {
    final res = await http.post(
      _uri('/almuerzos'),
      headers: await _headers(auth: true),
      body: jsonEncode({'cliente': cliente, 'plato': plato, 'cantidad': cantidad, 'precio': precio}),
    );
    if (res.statusCode == 401) throw ApiException('Sesión expirada', statusCode: 401);
    if (res.statusCode != 201) throw _error(res);
    return Almuerzo.fromJson(_decode(res) as Map<String, dynamic>);
  }

  Future<Almuerzo> updateAlmuerzo(int id, Map<String, dynamic> payload) async {
    final res = await http.put(
      _uri('/almuerzos/$id'),
      headers: await _headers(auth: true),
      body: jsonEncode(payload),
    );
    if (res.statusCode == 401) throw ApiException('Sesión expirada', statusCode: 401);
    if (res.statusCode != 200) throw _error(res);
    return Almuerzo.fromJson(_decode(res) as Map<String, dynamic>);
  }

  Future<void> deleteAlmuerzo(int id) async {
    final res = await http.delete(_uri('/almuerzos/$id'), headers: await _headers(auth: true));
    if (res.statusCode == 401) throw ApiException('Sesión expirada', statusCode: 401);
    if (res.statusCode != 204) throw _error(res);
  }
}
