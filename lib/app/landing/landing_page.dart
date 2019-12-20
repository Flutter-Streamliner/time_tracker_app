import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/home/home_page.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_page.dart';

class LandingPage extends StatefulWidget {

  final AuthBase auth;

  LandingPage({@required this.auth});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  User _user;

  void _updateUser(User user) {
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
    User user = await widget.auth.currentUser();
    _updateUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return _user == null ? 
      SignInPage(
        auth: widget.auth, 
        onSignIn: _updateUser,
      ): 
      HomePage(
        auth: widget.auth,
        onSignOut: () => _updateUser(null),
      );
  }
}