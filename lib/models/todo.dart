import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String? id;
  String title;
  Todo({this.id, required this.title, this.items, required this.timeModified});
  DateTime timeModified;
  List<TodoItem>? items;
  factory Todo.fromFirebase(dynamic data) {
    Timestamp timestamp = data['timeModified'];
    DateTime timeModified = timestamp.toDate();
    List<TodoItem>? items =
        (data['items'] as List).map((e) => TodoItem.fromMap(e)).toList();
    return Todo(
      id: data.id,
      title: data['title'] ?? '',
      timeModified: timeModified,
      items: items,
    );
  }
}

class TodoItem {
  String subtitle;
  bool check;
  TodoItem({
    required this.subtitle,
    this.check = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'subtitle': subtitle,
      'check': check,
    };
  }

  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      subtitle: map['subtitle'] ?? '',
      check: map['check'] ?? false,
    );
  }

  factory TodoItem.fromJson(String source) =>
      TodoItem.fromMap(json.decode(source));

  @override
  String toString() => 'TodoItem(subtitle: $subtitle, check: $check)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TodoItem &&
        other.subtitle == subtitle &&
        other.check == check;
  }

  @override
  int get hashCode => subtitle.hashCode ^ check.hashCode;
}
