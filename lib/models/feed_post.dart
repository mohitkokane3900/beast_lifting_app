class FeedPost {
  final String id;
  final String userId;
  final String type;
  final String text;
  final String? workoutId;
  final String? challengeId;
  final DateTime createdAt;
  final Map<String, int> reactions;

  FeedPost({
    required this.id,
    required this.userId,
    required this.type,
    required this.text,
    required this.workoutId,
    required this.challengeId,
    required this.createdAt,
    required this.reactions,
  });

  factory FeedPost.fromMap(String id, Map<String, dynamic> m) {
    final react = (m['reactionsCount'] as Map<String, dynamic>? ?? {})
        .map((k, v) => MapEntry(k, (v as num).toInt()));

    return FeedPost(
      id: id,
      userId: m['userId'] as String? ?? '',
      type: m['type'] as String? ?? 'workout',
      text: m['text'] as String? ?? '',
      workoutId: m['workoutId'] as String?,
      challengeId: m['challengeId'] as String?,
      createdAt: DateTime.parse(m['createdAt'] as String),
      reactions: react,
    );
  }
}
