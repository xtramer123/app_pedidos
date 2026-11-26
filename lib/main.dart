import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/api_service.dart';
import 'services/session_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SessionStore _session = SessionStore();
  late final ApiService _api = ApiService(_session);
  bool _loading = true;
  bool _authed = false;
  dynamic _user;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final token = await _session.getToken();
    final user = await _session.getUser();
    if (!mounted) return;
    setState(() {
      _authed = token != null && token.isNotEmpty && user != null;
      _user = user;
      _loading = false;
    });
  }

  Future<void> _handleAuthed() async {
    final user = await _session.getUser();
    if (!mounted) return;
    setState(() {
      _authed = true;
      _user = user;
    });
  }

  Future<void> _handleLogout() async {
    await _session.clear();
    if (!mounted) return;
    setState(() {
      _authed = false;
      _user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Pedidos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: _loading
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : _authed && _user != null
              ? HomeScreen(api: _api, user: _user, onLogout: _handleLogout)
              : LoginScreen(api: _api, onAuthed: _handleAuthed),
    );
  }
}
