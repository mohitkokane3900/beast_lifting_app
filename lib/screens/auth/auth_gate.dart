import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../main_shell.dart';
import 'login_screen.dart';

class AuthGate extends StatefulWidget {
  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;

  const AuthGate({
    super.key,
    required this.darkMode,
    required this.onThemeChanged,
  });

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final auth = AuthService();
  late Stream<User?> _stream;

  @override
  void initState() {
    super.initState();
    _stream = auth.authState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _stream,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.data == null) {
          return LoginScreen(
            darkMode: widget.darkMode,
            onThemeChanged: widget.onThemeChanged,
          );
        }
        return MainShell(
          darkMode: widget.darkMode,
          onThemeChanged: widget.onThemeChanged,
        );
      },
    );
  }
}
