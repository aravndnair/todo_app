import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get currentUser => _user;

  // Updated SignUp with error message return
  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // null = success
    } on FirebaseAuthException catch (e) {
      print('🔥 SignUp Error: ${e.code} - ${e.message}');
      return e.message; // return error to UI
    } catch (e) {
      print('🔥 Unknown SignUp Error: $e');
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // Updated SignIn with error message return
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      print('🔥 SignIn Error: ${e.code} - ${e.message}');
      return e.message;
    } catch (e) {
      print('🔥 Unknown SignIn Error: $e');
      return 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
