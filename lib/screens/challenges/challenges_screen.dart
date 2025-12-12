import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../models/challenge.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Challenges')),
      body: StreamBuilder<List<Challenge>>(
        stream: store.challengesStream(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = snap.data!;
          if (list.isEmpty) {
            return const Center(child: Text('No challenges yet'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final c = list[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(c.title),
                  subtitle: Text(c.description),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Open ${c.title} details next'),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
