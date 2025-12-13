import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
import '../../models/feed_post.dart';
import '../workouts/new_workout_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final store = FirestoreService();
  final auth = AuthService();
  String filter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beast Mode'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(child: Icon(Icons.person)),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _chip('All'),
                const SizedBox(width: 8),
                _chip('Friends'),
                const SizedBox(width: 8),
                _chip('Challenges'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<List<FeedPost>>(
              stream: store.feedStream(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final posts = snap.data!;
                if (posts.isEmpty) {
                  return const Center(
                    child: Text('No activity yet. Log your first workout!'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: posts.length,
                  itemBuilder: (context, i) {
                    return _FeedCard(post: posts[i]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final u = auth.currentUser;
          if (u == null) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NewWorkoutScreen(userId: u.uid),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _chip(String label) {
    final selected = filter == label;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        setState(() {
          filter = label;
        });
      },
    );
  }
}

class _FeedCard extends StatelessWidget {
  final FeedPost post;
  const _FeedCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('MMM d, h:mm a');
    final timeLabel = f.format(post.createdAt);
    final text = post.text.isEmpty ? 'New workout logged' : post.text;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'User ${post.userId.substring(0, 4)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  timeLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Icon(Icons.thumb_up_alt_outlined, size: 18),
                SizedBox(width: 10),
                Icon(Icons.local_fire_department_outlined, size: 18),
                SizedBox(width: 10),
                Icon(Icons.percent, size: 18),
                Spacer(),
                Icon(Icons.mode_comment_outlined, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
