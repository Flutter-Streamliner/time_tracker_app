import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/sign_in/email_sign_in_form.dart';

class EmailSignInPage extends StatelessWidget {

  final AuthBase auth;

  EmailSignInPage({@required this.auth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        elevation: 2.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(child: EmailSignInForm(auth: auth,)),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

}