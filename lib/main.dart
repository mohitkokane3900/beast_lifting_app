import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const BeastAppRoot());
}

class BeastAppRoot extends StatefulWidget {
  const BeastAppRoot({super.key});
  @override
  State<BeastAppRoot> createState() => _BeastAppRootState();
}

class _BeastAppRootState extends State<BeastAppRoot> {
  bool isDark = false;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getBool('darkMode') ?? false;
    setState(() {
      isDark = v;
      loaded = true;
    });
  }

  Future<void> _setTheme(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', v);
    setState(() {
      isDark = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return MaterialApp(home: Container(color: Colors.black));
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beast Mode',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: AuthGate(darkMode: isDark, onThemeChanged: _setTheme),
    );
  }
}
