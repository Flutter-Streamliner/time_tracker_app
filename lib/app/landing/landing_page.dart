import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/home/home_page.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_page.dart';

class LandingPage extends StatelessWidget {

  final AuthBase auth;

  LandingPage({@required this.auth});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage(
              auth: auth, 
            );
          }
          return HomePage(
            auth: auth,
          );
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator(),),
          );
        }
      },
    );
      
  }
}