
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker_app/app/home/jobs/empty_content.dart';
import 'package:time_tracker_app/app/home/jobs/job_list_tile.dart';
import 'package:time_tracker_app/app/home/models/job.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/services/database.dart';
import 'package:time_tracker_app/app/widgets/platform_alert_dialog.dart';

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
        onPressed: () => EditJobPage.show(context),
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
            if (jobs.isNotEmpty) {
              final children = jobs.map((job) => JobListTile(
                                                  job: job,
                                                  onTap: () => EditJobPage.show(context, job: job)
                                                ),
                              )
                              .toList();
              return ListView(children: children,);
            } 
            return EmptyContent();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Some error occured.'),);
          }
          return Center(child: CircularProgressIndicator()) ; 
       },
       stream: database.jobsStream(),
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