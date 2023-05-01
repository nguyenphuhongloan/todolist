import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String? id;
  String title;
  String content = "";
  DateTime timeModified;
  String? idUser;
  Task(
      {this.id,
      required this.title,
      required this.content,
      required this.timeModified,
      this.idUser});

  factory Task.fromFirebase(dynamic data) {
    Timestamp timestamp = data['timeModified'];
    DateTime timeModified = timestamp.toDate();
    return Task(
      id: data.id,
      content: data['content'],
      title: data['title'],
      idUser: data['idUser'],
      timeModified: timeModified);
  }
}
