import 'package:flutter/material.dart';
import '../../models/app_user.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  final AppUser user;
  const SettingsScreen({super.key, required this.user});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final store = FirestoreService();
  final auth = AuthService();

  late bool showWorkouts;
  late bool showPhotos;
  late bool blurFace;

  @override
  void initState() {
    super.initState();
    showWorkouts = widget.user.showWorkouts;
    showPhotos = widget.user.showPhotos;
    blurFace = widget.user.blurFace;
  }

  Future<void> _save() async {
    await store.updatePrivacy(
      uid: widget.user.uid,
      showWorkouts: showWorkouts,
      showPhotos: showPhotos,
      blurFace: blurFace,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Settings saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Privacy')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Show workouts in public feed'),
              value: showWorkouts,
              onChanged: (v) {
                setState(() {
                  showWorkouts = v;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Show photos to friends'),
              value: showPhotos,
              onChanged: (v) {
                setState(() {
                  showPhotos = v;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Blur face in photo previews'),
              value: blurFace,
              onChanged: (v) {
                setState(() {
                  blurFace = v;
                });
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Save Settings'),
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Delete account would remove data; not implemented',
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Delete account',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
