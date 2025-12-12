import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String filter = 'All';

  @override
  Widget build(BuildContext context) {
    final posts = List.generate(
      5,
      (i) => _MockPost(
        user: 'User ${i + 1}',
        text: 'Crushed a workout today',
        time: DateTime.now().subtract(Duration(hours: i * 3)),
      ),
    );

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
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, i) {
                return _FeedCard(post: posts[i]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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

class _MockPost {
  final String user;
  final String text;
  final DateTime time;

  _MockPost({
    required this.user,
    required this.text,
    required this.time,
  });
}

class _FeedCard extends StatelessWidget {
  final _MockPost post;

  const _FeedCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('MMM d, h:mm a');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    post.user,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  f.format(post.time),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(post.text),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.thumb_up_alt_outlined, size: 18),
                SizedBox(width: 8),
                Icon(Icons.local_fire_department_outlined, size: 18),
                SizedBox(width: 8),
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
