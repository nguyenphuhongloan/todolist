import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/task.dart';

class TaskRepository {
  Future<bool> createTask(Task task) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').add({
        'title': task.title,
        'content': task.content,
        'timeModified': task.timeModified,
        'idUser': FirebaseAuth.instance.currentUser!.uid,
      });
      return true;
    } catch (error) {
      return false;
    }
  }
  Future<bool> editTask(Task task) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(task.id).update({
        'title': task.title,
        'content': task.content,
        'timeModified': task.timeModified,
        'idUser': FirebaseAuth.instance.currentUser!.uid,
      });
      return true;
    } catch (error) {
      return false;
    }
  }
  Future<bool> removeTask(String id) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
