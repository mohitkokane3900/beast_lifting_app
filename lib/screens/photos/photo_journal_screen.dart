import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../models/photo_entry.dart';

class PhotoJournalScreen extends StatefulWidget {
  const PhotoJournalScreen({super.key});

  @override
  State<PhotoJournalScreen> createState() => _PhotoJournalScreenState();
}

class _PhotoJournalScreenState extends State<PhotoJournalScreen> {
  final auth = AuthService();
  final store = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final u = auth.currentUser;
    if (u == null) {
      return const Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Photo Journal')),
      body: StreamBuilder<List<PhotoEntry>>(
        stream: store.photoEntriesForUser(u.uid),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = snap.data!;
          if (list.isEmpty) {
            return const Center(child: Text('No photos yet'));
          }

          final f = DateFormat('MMM d, y');

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final p = list[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            f.format(p.createdAt),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(p.note ?? 'Workout photo'),
                          const SizedBox(height: 4),
                          Text(
                            p.workoutId == null
                                ? 'No linked workout'
                                : 'Linked workout: ${p.workoutId!.substring(0, 5)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.image),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add Photo will use image picker later'),
            ),
          );
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
