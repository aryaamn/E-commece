import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final _auth = FirebaseAuth.instance;

  Future<dynamic> signUp(String email, String password) async {
    final authResult = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return authResult;
  }

  Future<dynamic> signIn(String email, String password) async {
    final authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return authResult;
  }

  // ignore: deprecated_member_use
  Future<FirebaseUser> getUser() async {
    return _auth.currentUser;
  }

  Future<dynamic> getUserID() async {
    return _auth.currentUser.uid;
  }

  Future<void> signOut() async => await _auth.signOut();
}
