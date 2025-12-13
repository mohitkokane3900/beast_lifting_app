import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/workout.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final Workout workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('EEE MMM d, h:mm a');
    final date = f.format(workout.createdAt);
    int totalSets = 0;
    double totalVolume = 0;
    for (final ex in workout.exercises) {
      for (final s in ex.sets) {
        totalSets += 1;
        totalVolume += s.weight * s.reps;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Workout Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workout.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(date),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('Sets: $totalSets')),
                Chip(label: Text('Volume: ${totalVolume.toStringAsFixed(0)}')),
                const Chip(label: Text('Duration: approx.')),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: workout.exercises.length,
                itemBuilder: (context, i) {
                  final ex = workout.exercises[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ex.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: ex.sets
                                .map(
                                  (s) => Text('${s.weight} x ${s.reps} reps'),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Linked photos not implemented yet'),
                    ),
                  );
                },
                child: const Text('View Linked Photos'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
