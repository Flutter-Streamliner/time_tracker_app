import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/home/models/job.dart';

abstract class Database {

  Future<void> createJob(Job job);

}

class FirestoreDatabase implements Database {

  final String uid;

  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  Future<void> createJob(Job job) async {
    final path = '/users/$uid/jobs/job_123';
    final documentReference = Firestore.instance.document(path);
    await documentReference.setData(job.toMap());
  }

}