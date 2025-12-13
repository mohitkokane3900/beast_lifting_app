import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/firestore_service.dart';
import '../../models/workout.dart';

class NewWorkoutScreen extends StatefulWidget {
  final String userId;
  const NewWorkoutScreen({super.key, required this.userId});

  @override
  State<NewWorkoutScreen> createState() => _NewWorkoutScreenState();
}

class _NewWorkoutScreenState extends State<NewWorkoutScreen> {
  final store = FirestoreService();
  final titleCtl = TextEditingController();
  final List<_ExerciseBlock> blocks = [];
  late DateTime createdAt;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    createdAt = DateTime.now();
    blocks.add(_ExerciseBlock());
  }

  void _addBlock() {
    setState(() {
      blocks.add(_ExerciseBlock());
    });
  }

  Future<void> _saveWorkout({required bool share}) async {
    if (titleCtl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter workout title')));
      return;
    }

    final exercises = <WorkoutExercise>[];
    for (final b in blocks) {
      final name = b.exerciseCtl.text.trim();
      if (name.isEmpty || b.sets.isEmpty) continue;
      exercises.add(WorkoutExercise(name: name, sets: List.of(b.sets)));
    }

    if (exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one exercise and set')),
      );
      return;
    }

    setState(() {
      saving = true;
    });

    final workout = Workout(
      id: '',
      userId: widget.userId,
      title: titleCtl.text.trim(),
      createdAt: createdAt,
      exercises: exercises,
      linkedChallengeIds: [],
    );

    final id = await store.saveWorkout(workout);
    if (share) {
      await store.addWorkoutFeedPost(
        userId: widget.userId,
        workoutId: id,
        text: '${titleCtl.text.trim()} • ${exercises.length} exercises',
      );
    }

    setState(() {
      saving = false;
    });

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('EEE MMM d, h:mm a');
    final dateLabel = f.format(createdAt);

    return Scaffold(
      appBar: AppBar(title: const Text('Log Workout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateLabel),
            const SizedBox(height: 12),
            TextField(
              controller: titleCtl,
              decoration: const InputDecoration(
                labelText: 'Workout title',
                hintText: 'Push Day at GSU Gym',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Column(children: blocks.map((b) => _buildBlock(b)).toList()),
            const SizedBox(height: 12),
            _wideButton(
              text: '+ Add Exercise',
              color: Colors.blueGrey,
              onTap: _addBlock,
            ),
            const SizedBox(height: 16),
            _wideButton(
              text: 'Save & Share to Feed',
              color: Colors.green,
              onTap: saving ? null : () => _saveWorkout(share: true),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: saving ? null : () => _saveWorkout(share: false),
              child: const Text('Save Private'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlock(_ExerciseBlock b) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: b.exerciseCtl,
              decoration: const InputDecoration(
                labelText: 'Exercise name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: b.weightCtl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Weight',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: b.repsCtl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Reps',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final wt = double.tryParse(b.weightCtl.text.trim());
                    final rp = int.tryParse(b.repsCtl.text.trim());
                    if (wt == null || rp == null) return;
                    setState(() {
                      b.sets.add(WorkoutSet(weight: wt, reps: rp));
                      b.weightCtl.clear();
                      b.repsCtl.clear();
                    });
                  },
                  child: const Text('+ Set'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (b.sets.isEmpty)
              const Text('No sets yet')
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: b.sets
                    .map((s) => Text('${s.weight} x ${s.reps}'))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _wideButton({
    required String text,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color),
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }
}

class _ExerciseBlock {
  final TextEditingController exerciseCtl = TextEditingController();
  final TextEditingController weightCtl = TextEditingController();
  final TextEditingController repsCtl = TextEditingController();
  final List<WorkoutSet> sets = [];
}
