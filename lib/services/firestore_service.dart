import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';
import '../models/feed_post.dart';
import '../models/workout.dart';
import '../models/challenge.dart';
import '../models/photo_entry.dart';

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
        .map((qs) =>
            qs.docs.map((d) => FeedPost.fromMap(d.id, d.data())).toList());
  }

  Future<String> saveWorkout(Workout workout) async {
    final doc = _db.collection('workouts').doc();
    await doc.set(workout.toMap());
    return doc.id;
  }

  Future<void> addWorkoutFeedPost({
    required String userId,
    required String workoutId,
    required String text,
  }) async {
    await _db.collection('activity_feed').add({
      'userId': userId,
      'type': 'workout',
      'workoutId': workoutId,
      'challengeId': null,
      'text': text,
      'createdAt': DateTime.now().toIso8601String(),
      'visibility': 'public',
      'reactionsCount': {},
    });
  }

  Stream<List<Challenge>> challengesStream() {
    return _db.collection('challenges').orderBy('title').snapshots().map(
        (qs) => qs.docs.map((d) => Challenge.fromMap(d.id, d.data())).toList());
  }

  Future<void> joinChallenge(String challengeId, String uid) async {
    final ref = _db
        .collection('challenges')
        .doc(challengeId)
        .collection('participants')
        .doc(uid);

    await ref.set({
      'userId': uid,
      'joinedAt': DateTime.now().toIso8601String(),
      'completedWorkoutsCount': 0,
      'streakDays': 0,
    }, SetOptions(merge: true));
  }

  Stream<List<Workout>> workoutsForUser(String uid) {
    return _db
        .collection('workouts')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((qs) =>
            qs.docs.map((d) => Workout.fromMap(d.id, d.data())).toList());
  }

  Stream<List<PhotoEntry>> photoEntriesForUser(String uid) {
    return _db
        .collection('photos')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((qs) =>
            qs.docs.map((d) => PhotoEntry.fromMap(d.id, d.data())).toList());
  }
}
