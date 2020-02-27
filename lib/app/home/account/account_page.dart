import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/widgets/avatar.dart';
import 'package:time_tracker_app/app/widgets/platform_alert_dialog.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text('Logout', style: TextStyle(color: Colors.white, fontSize: 18.0)),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _buildUserInfo(user),
        ),
      ),
    );
  }

  Widget _buildUserInfo(User user) {
    return Column(
      children: <Widget>[
        Avatar(
          radius: 50, 
          photoUrl: user.photoUrl,
        ),
        SizedBox(height: 8,),
        if (user.displayName != null) 
          Text(user.displayName, style: TextStyle(color: Colors.white)),
        SizedBox(height: 8,),
      ],
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try{ 
      await Provider.of<AuthBase>(context, listen: false).signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',
    ).show(context);
    if (didRequestSignOut == true) _signOut(context);
  }
}