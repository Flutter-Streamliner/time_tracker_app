import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/home/home_page.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  FirebaseUser _user;

  void _updateUser(FirebaseUser user) {
    setState(() {
      _user = user;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    _updateUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return _user == null ? SignInPage(onSignIn: _updateUser) : HomePage(onSignOut: () => _updateUser(null));
  }
}