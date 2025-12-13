class Challenge {
  final String id;
  final String title;
  final String description;
  final int durationDays;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.durationDays,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  factory Challenge.fromMap(String id, Map<String, dynamic> m) {
    return Challenge(
      id: id,
      title: m['title'] as String? ?? '',
      description: m['description'] as String? ?? '',
      durationDays: (m['durationDays'] as num?)?.toInt() ?? 7,
      startDate: m['startDate'] != null
          ? DateTime.parse(m['startDate'] as String)
          : null,
      endDate: m['endDate'] != null
          ? DateTime.parse(m['endDate'] as String)
          : null,
      isActive: m['isActive'] as bool? ?? true,
    );
  }
}
