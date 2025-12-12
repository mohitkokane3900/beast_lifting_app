import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';
import '../models/feed_post.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
  }) async {
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
    });
  }

  Future<AppUser?> getUserProfile(String uid) async {
    final snap = await _db.collection('users').doc(uid).get();
    if (!snap.exists) return null;
    return AppUser.fromMap(snap.data()!);
  }

  Stream<List<FeedPost>> feedStream() {
    return _db
        .collection('activity_feed')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (qs) => qs.docs.map((d) => FeedPost.fromMap(d.id, d.data())).toList(),
        );
  }
}
