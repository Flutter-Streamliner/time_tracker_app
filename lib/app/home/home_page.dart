
import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/services/auth.dart';

class HomePage extends StatelessWidget {

  final AuthBase auth;

  HomePage({@required this.auth});

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
    } catch (e) {
      print(e.toString());
    }
  }
}