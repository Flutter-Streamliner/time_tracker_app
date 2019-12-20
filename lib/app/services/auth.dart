import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {

  final _firebaseAuth = FirebaseAuth.instance;
  
  User _userFromFirebase(FirebaseUser user) {
    if (user == null) return null;
    return User(uid: user.uid);
  }

  Future<User> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

}

class User {

  final String uid;

  User({@required this.uid});

}