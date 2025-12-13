class AppUser {
  final String uid;
  final String name;
  final String email;
  final String fitnessGoal;
  final String? photoUrl;
  final bool showWorkouts;
  final bool showPhotos;
  final bool blurFace;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.fitnessGoal,
    this.photoUrl,
    required this.showWorkouts,
    required this.showPhotos,
    required this.blurFace,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'fitnessGoal': fitnessGoal,
      'photoUrl': photoUrl,
      'privacySettings': {
        'showWorkouts': showWorkouts,
        'showPhotos': showPhotos,
        'blurFace': blurFace,
      },
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> m) {
    final privacy = m['privacySettings'] as Map<String, dynamic>? ?? {};
    return AppUser(
      uid: m['uid'] as String,
      name: m['name'] as String? ?? '',
      email: m['email'] as String? ?? '',
      fitnessGoal: m['fitnessGoal'] as String? ?? '',
      photoUrl: m['photoUrl'] as String?,
      showWorkouts: privacy['showWorkouts'] as bool? ?? true,
      showPhotos: privacy['showPhotos'] as bool? ?? true,
      blurFace: privacy['blurFace'] as bool? ?? false,
    );
  }
}
