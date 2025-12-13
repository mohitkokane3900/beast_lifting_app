class WorkoutSet {
  final double weight;
  final int reps;

  WorkoutSet({required this.weight, required this.reps});

  Map<String, dynamic> toMap() {
    return {'weight': weight, 'reps': reps};
  }

  factory WorkoutSet.fromMap(Map<String, dynamic> m) {
    return WorkoutSet(
      weight: (m['weight'] as num).toDouble(),
      reps: (m['reps'] as num).toInt(),
    );
  }
}

class WorkoutExercise {
  final String name;
  final List<WorkoutSet> sets;

  WorkoutExercise({required this.name, required this.sets});

  Map<String, dynamic> toMap() {
    return {'name': name, 'sets': sets.map((s) => s.toMap()).toList()};
  }

  factory WorkoutExercise.fromMap(Map<String, dynamic> m) {
    final list = (m['sets'] as List<dynamic>? ?? [])
        .map((e) => WorkoutSet.fromMap(e as Map<String, dynamic>))
        .toList();
    return WorkoutExercise(name: m['name'] as String? ?? '', sets: list);
  }
}

class Workout {
  final String id;
  final String userId;
  final String title;
  final DateTime createdAt;
  final List<WorkoutExercise> exercises;
  final List<String> linkedChallengeIds;

  Workout({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    required this.exercises,
    required this.linkedChallengeIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'linkedChallengeIds': linkedChallengeIds,
    };
  }

  factory Workout.fromMap(String id, Map<String, dynamic> m) {
    final ex = (m['exercises'] as List<dynamic>? ?? [])
        .map((e) => WorkoutExercise.fromMap(e as Map<String, dynamic>))
        .toList();
    return Workout(
      id: id,
      userId: m['userId'] as String? ?? '',
      title: m['title'] as String? ?? '',
      createdAt: DateTime.parse(m['createdAt'] as String),
      exercises: ex,
      linkedChallengeIds: (m['linkedChallengeIds'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}
