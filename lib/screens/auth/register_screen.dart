import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;

  const RegisterScreen({
    super.key,
    required this.darkMode,
    required this.onThemeChanged,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final auth = AuthService();
  final nameCtl = TextEditingController();
  final emailCtl = TextEditingController();
  final passCtl = TextEditingController();
  final confirmCtl = TextEditingController();
  String goal = 'Lose Fat';
  String errorText = '';
  bool busy = false;

  Future<void> _doRegister() async {
    if (passCtl.text.trim() != confirmCtl.text.trim()) {
      setState(() {
        errorText = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      busy = true;
      errorText = '';
    });

    final e = await auth.register(
      name: nameCtl.text.trim(),
      email: emailCtl.text.trim(),
      password: passCtl.text.trim(),
      fitnessGoal: goal,
    );

    setState(() {
      busy = false;
      errorText = e ?? '';
    });

    if (e == null) {
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final goals = ['Lose Fat', 'Gain Muscle', 'Stay Active'];

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameCtl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passCtl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmCtl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm password'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: goal,
              items: goals
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() {
                  goal = v;
                });
              },
              decoration: const InputDecoration(labelText: 'Fitness goal'),
            ),
            const SizedBox(height: 8),
            Text(
              'By continuing you agree to terms…',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: 8),
            if (errorText.isNotEmpty)
              Text(
                errorText,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: busy ? null : _doRegister,
                child: busy
                    ? const CircularProgressIndicator()
                    : const Text('Create Account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
