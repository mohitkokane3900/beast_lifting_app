class PhotoEntry {
  final String id;
  final String userId;
  final String? workoutId;
  final String imageUrl;
  final String? note;
  final String visibility;
  final bool blurred;
  final DateTime createdAt;

  PhotoEntry({
    required this.id,
    required this.userId,
    required this.workoutId,
    required this.imageUrl,
    required this.note,
    required this.visibility,
    required this.blurred,
    required this.createdAt,
  });

  factory PhotoEntry.fromMap(String id, Map<String, dynamic> m) {
    return PhotoEntry(
      id: id,
      userId: m['userId'] as String? ?? '',
      workoutId: m['workoutId'] as String?,
      imageUrl: m['imageUrl'] as String? ?? '',
      note: m['note'] as String?,
      visibility: m['visibility'] as String? ?? 'private',
      blurred: m['blurred'] as bool? ?? false,
      createdAt: DateTime.parse(m['createdAt'] as String),
    );
  }
}
