import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class Database {

  Future<void> createJob(Map<String, dynamic> jobData);

}

class FirestoreDatabase implements Database {

  final String uid;

  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  Future<void> createJob(Map<String, dynamic> jobData) async {
    final path = '/users/$uid/jobs/job_123';
    final documentReference = Firestore.instance.document(path);
    await documentReference.setData(jobData);
  }

}