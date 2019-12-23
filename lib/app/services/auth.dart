import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<void> signOut();
}

class Auth implements AuthBase {

  final _firebaseAuth = FirebaseAuth.instance;
  
  User _userFromFirebase(FirebaseUser user) {
    if (user == null) return null;
    return User(uid: user.uid);
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override Future<User> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      if (googleSignInAuthentication.idToken != null && googleSignInAuthentication.accessToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.getCredential(
            idToken: googleSignInAuthentication.idToken, 
            accessToken: googleSignInAuthentication.accessToken
          ),
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final authResult = await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.getCredential(accessToken: result.accessToken.token)
        );
        return _userFromFirebase(authResult.user);
        break;
      case FacebookLoginStatus.cancelledByUser:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
        break;
      case FacebookLoginStatus.error:
        throw PlatformException(
          code: 'ERROR_MISSING_FACEBOOK_AUTH_TOKEN',
          message: 'Missing Facebook Auth Token',
        );
        break;  
      default:
        throw PlatformException(
          code: 'ERROR_FACEBOOK_AUTH',
          message: 'Unknown Error Facebook Auth',
        );
    }
  }

  @override 
  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final FacebookLogin facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }

}

class User {

  final String uid;

  User({@required this.uid});

}