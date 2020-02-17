import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/home/models/job.dart';
import 'package:time_tracker_app/app/services/api_path.dart';
import 'package:time_tracker_app/app/services/firestore_service.dart';

abstract class Database {

  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();

}

class FirestoreDatabase implements Database {

  final String uid;
  final FirestoreService _service = FirestoreService.instance;

  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

  Future<void> createJob(Job job) async => await _service.setData(
    path: APIPath.job(uid, documentIdFromCurrentDate()),
    data: job.toMap(),
  );

  

  Stream<List<Job>> jobsStream() => _service.collectionStream(
    path: APIPath.jobs(uid), 
    builder: (data) => Job.fromMap(data)
  );

  

}