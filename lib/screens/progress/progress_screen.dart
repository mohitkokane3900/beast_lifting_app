import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
import '../../models/workout.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final store = FirestoreService();
  final auth = AuthService();
  String mode = 'Workouts';

  int _calculateStreak(List<Workout> workouts) {
    if (workouts.isEmpty) return 0;
    int streak = 0;
    DateTime? lastDate;

    for (final w in workouts) {
      final d = DateTime(w.createdAt.year, w.createdAt.month, w.createdAt.day);
      if (lastDate == null) {
        streak = 1;
        lastDate = d;
      } else {
        final diff = lastDate.difference(d).inDays;
        if (diff == 1) {
          streak += 1;
          lastDate = d;
        } else {
          break;
        }
      }
    }
    return streak;
  }

  int _workoutsThisWeek(List<Workout> workouts) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 6));
    return workouts.where((w) => w.createdAt.isAfter(start)).length;
  }

  @override
  Widget build(BuildContext context) {
    final u = auth.currentUser;
    if (u == null) {
      return const Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: StreamBuilder<List<Workout>>(
        stream: store.workoutsForUser(u.uid),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final workouts = snap.data!;
          final streak = _calculateStreak(workouts);
          final weekCount = _workoutsThisWeek(workouts);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _toggleButton('Workouts'),
                    const SizedBox(width: 8),
                    _toggleButton('Volume'),
                    const SizedBox(width: 8),
                    _toggleButton('Streak'),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Simple chart: $mode over time',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _summaryCard('Current streak', '$streak days'),
                    const SizedBox(width: 8),
                    _summaryCard('This week', '$weekCount workouts'),
                    const SizedBox(width: 8),
                    _summaryCard(
                      'Total workouts',
                      workouts.length.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _toggleButton(String label) {
    final selected = mode == label;
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            mode = label;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? Colors.orange : null,
        ),
        child: Text(label),
      ),
    );
  }

  Widget _summaryCard(String title, String value) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
