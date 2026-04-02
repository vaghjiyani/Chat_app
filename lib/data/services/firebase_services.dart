import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;

  Future<User?> register(String email, String password, String name) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userId = result.user;
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId.uid)
            .set({
              'userId': userId.uid,
              'name': name,
              'createdAt': FieldValue.serverTimestamp(),
            });
      }
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(
        'Failed to register with email id password : ${e.message}',
      );
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // firebasere firestore instance collection
      final userId = result.user;
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId.uid)
            .set({
              'userId': userId.uid,
              'createdAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
      }
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to sign in email and password: ${e.message}');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
