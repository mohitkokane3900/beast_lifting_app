import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _store = FirestoreService();

  Stream<User?> authState() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<AppUser?> getCurrentProfile() async {
    final u = _auth.currentUser;
    if (u == null) return null;
    return _store.getUserProfile(u.uid);
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Login failed';
    }
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
    required String fitnessGoal,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final u = cred.user;
      if (u == null) return 'Could not create user';
      await _store.createUserProfile(
        uid: u.uid,
        name: name,
        email: email,
        fitnessGoal: fitnessGoal,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Registration failed';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
