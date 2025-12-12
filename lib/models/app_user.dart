class AppUser {
  final String uid;
  final String name;
  final String email;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
  });

  factory AppUser.fromMap(Map<String, dynamic> m) {
    return AppUser(
      uid: m['uid'] as String,
      name: m['name'] as String? ?? '',
      email: m['email'] as String? ?? '',
    );
  }
}
