import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/home/models/job.dart';
import 'package:time_tracker_app/app/services/api_path.dart';
import 'package:time_tracker_app/app/services/firestore_service.dart';

abstract class Database {

  Future<void> setJob(Job job);
  Stream<List<Job>> jobsStream();

}

class FirestoreDatabase implements Database {

  final String uid;
  final FirestoreService _service = FirestoreService.instance;

  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  static String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

  Future<void> setJob(Job job) async => await _service.setData(
    path: APIPath.job(uid, job.id),
    data: job.toMap(),
  );

  

  Stream<List<Job>> jobsStream() => _service.collectionStream(
    path: APIPath.jobs(uid), 
    builder: (data, documentId) => Job.fromMap(data, documentId)
  );

  

}