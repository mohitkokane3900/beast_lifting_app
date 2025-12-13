import 'package:flutter/material.dart';
import '../../models/challenge.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final Challenge challenge;
  const ChallengeDetailScreen({super.key, required this.challenge});

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  final store = FirestoreService();
  final auth = AuthService();
  bool joining = false;

  Future<void> _join() async {
    final u = auth.currentUser;
    if (u == null) return;
    setState(() {
      joining = true;
    });
    await store.joinChallenge(widget.challenge.id, u.uid);
    setState(() {
      joining = false;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Joined challenge')));
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.challenge;
    return Scaffold(
      appBar: AppBar(title: Text(c.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(c.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Text('Duration: ${c.durationDays} days'),
            const SizedBox(height: 12),
            const Text('Rule example: Log at least 1 workout every day.'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: joining ? null : _join,
                child: joining
                    ? const CircularProgressIndicator()
                    : const Text('Join Challenge'),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Recent Activity (placeholder)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'This section will show posts related to this challenge.',
            ),
          ],
        ),
      ),
    );
  }
}
