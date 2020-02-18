import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/home/models/job.dart';

class JobListTile extends StatelessWidget {

  final Job job;
  final VoidCallback onTap;

  JobListTile({Key key, @required this.job, this.onTap}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Icon(Icons.chevron_right),
      title: Text(job.name),
      onTap: onTap,
    );
  }
}