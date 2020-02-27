import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/home/home_page.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/services/database.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_page.dart';

class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          }
          return Provider<User>.value(
            value: user,
            child: Provider<Database>(
              create: (_) => FirestoreDatabase(uid: user.uid),
              child: HomePage()),
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