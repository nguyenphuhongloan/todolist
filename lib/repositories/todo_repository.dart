import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo.dart';

class TodoRepository {
  Future<bool> createTodo(Todo todo) async {
    try {
      await FirebaseFirestore.instance.collection('todo').add({
        'title': todo.title,
        'idUser': FirebaseAuth.instance.currentUser!.uid,
        'items': todo.items?.map((e) => e.toMap()).toList() ?? [],
        'timeModified': todo.timeModified
      });
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> editTodo(Todo todo) async {
    try {
      await FirebaseFirestore.instance.collection('todo').doc(todo.id).update({
        'title': todo.title,
        'idUser': FirebaseAuth.instance.currentUser!.uid,
        'items': todo.items?.map((e) => e.toMap()).toList() ?? [],
        'timeModified': todo.timeModified
      });
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> removeTodo(String id) async {
    try {
      await FirebaseFirestore.instance.collection('todo').doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
