import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/home/models/job.dart';
import 'package:time_tracker_app/app/services/api_path.dart';

abstract class Database {

  Future<void> createJob(Job job);
  void readJobs();

}

class FirestoreDatabase implements Database {

  final String uid;

  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  Future<void> createJob(Job job) async => _setData(
    path: APIPath.job(uid, 'job_abc'),
    data: job.toMap(),
  );

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    print('$path: $data');
    await reference.setData(data);
  }

  void readJobs() {
    final path = APIPath.jobs(uid);
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    snapshots.listen((snapshot){
      snapshot.documents.forEach((snapshot) => print(snapshot.data));
    });
  }
}