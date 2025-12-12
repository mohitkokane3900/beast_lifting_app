import 'package:flutter/material.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final challenges = [
      _MockChallenge(
        title: '7-Day Pushup Streak',
        description: 'Complete at least one pushup workout every day.',
        days: 7,
      ),
      _MockChallenge(
        title: '30-Day Beast Mode',
        description: 'Log a workout every day for 30 days.',
        days: 30,
      ),
      _MockChallenge(
        title: 'Volume Builder',
        description: 'Accumulate high training volume this week.',
        days: 7,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Challenges')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: challenges.length,
        itemBuilder: (context, i) {
          final c = challenges[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(c.title),
              subtitle: Text(c.description),
              trailing: Text('${c.days} days'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Open ${c.title} (next commit)'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _MockChallenge {
  final String title;
  final String description;
  final int days;

  _MockChallenge({
    required this.title,
    required this.description,
    required this.days,
  });
}
