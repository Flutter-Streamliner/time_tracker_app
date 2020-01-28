import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/home/models/job.dart';
import 'package:time_tracker_app/app/services/api_path.dart';

abstract class Database {

  Future<void> createJob(Job job);

}

class FirestoreDatabase implements Database {

  final String uid;

  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  Future<void> createJob(Job job) async {
    final path = APIPath.job(uid, 'job_abc'); //'/users/$uid/jobs/job_123';
    final documentReference = Firestore.instance.document(path);
    await documentReference.setData(job.toMap());
  }

}