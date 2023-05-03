import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todolist/widgets/task_card_widget.dart';

import '../models/task.dart';
import '../repositories/task_repository.dart';
import '../screens/create_task_screen.dart';

class TaskView extends StatelessWidget {
  const TaskView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .where('idUser', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy("timeModified", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Task task = Task.fromFirebase(snapshot.data!.docs[index]);
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const BehindMotion(),
                    extentRatio: 0.2,
                    children: [
                      SlidableAction(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        onPressed: (context) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text("Confirm delete"),
                                    content: const Text(
                                        "Are you sure you want to delete this note?"),
                                    actions: [
                                      TextButton(
                                        child: const Text("Cancel"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("OK"),
                                        onPressed: () {
                                          TaskRepository()
                                              .removeTask(task.id ?? "");
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ));
                        },
                        backgroundColor: Colors.transparent,
                        foregroundColor: const Color.fromARGB(255, 190, 56, 56),
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    child: TaskCard(task: task),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateTaskScreen(
                                    task: task,
                                  )));
                    },
                  ),
                );
              });
        });
  }
}
