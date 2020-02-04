
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/home/jobs/add_job_page.dart';
import 'package:time_tracker_app/app/home/models/job.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/services/database.dart';
import 'package:time_tracker_app/app/widgets/platform_alert_dialog.dart';
import 'package:time_tracker_app/app/widgets/platform_exception_alert_dialog.dart';

class JobPage extends StatelessWidget {

  JobPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Page'),
        actions: <Widget>[
          FlatButton(
            child: Text('Logout', style: TextStyle(color: Colors.white, fontSize: 18.0)),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddJobPage.show(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
     final database = Provider.of<Database>(context);
     return StreamBuilder<List<Job>>(
       builder: (context, snapshot) {
          if (snapshot.hasData) {
            final jobs = snapshot.data;
            final children = jobs.map((job) => Text(job.name)).toList( );
            return ListView(children: children,);
          }
          if (snapshot.hasError) {
            return Center(child: Text('Some error occured.'),);
          }
          return Center(child: CircularProgressIndicator()) ; 
       },
       stream: database.jobsStream(),
     );
  }

  Future<void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(Job(name: 'Programming', ratePerHour: 8));
    } on PlatformException catch(e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
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