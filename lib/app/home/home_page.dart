
import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/services/auth.dart';

class HomePage extends StatelessWidget {

  final VoidCallback onSignOut;
  final AuthBase auth;

  HomePage({@required this.auth, @required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          FlatButton(
            child: Text('Logout', style: TextStyle(color: Colors.white, fontSize: 18.0)),
            onPressed: _signOut,
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    try{ 
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e.toString());
    }
  }
}