import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:todolist/app.dart';
import 'package:todolist/constants/constants.dart';
import 'package:todolist/repositories/task_repository.dart';
import 'package:todolist/screens/change_password_screen.dart';
import 'package:todolist/widgets/showLoadingDialog.dart';
import '../models/task.dart';
import '../widgets/task_cart_widget.dart';
import 'create_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Todo List"),
        backgroundColor: colorPrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
                child: const Icon(
                  Icons.dehaze,
                  size: 27,
                ),
                onTap: () {
                  SideSheet.right(
                      width: size.width * 0.7,
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).padding.top,
                            ),
                            const SizedBox(
                              height: 52,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Account",
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w300)),
                              ),
                            ),
                            Column(children: [
                              const Divider(
                                height: 1,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                  height: 70,
                                  width: size.width,
                                  //decoration:
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 70,
                                        child: Text(
                                          "Email:",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          FirebaseAuth.instance.currentUser!
                                                  .email ??
                                              "",
                                          maxLines: 3,
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    ],
                                  )),
                              OptionCard(
                                title: "Change Password",
                                icon: Icons.keyboard_arrow_right,
                                size: size,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                            const ChangePasswordScreen()));
                                },
                              ),
                              OptionCard(
                                title: "Log out",
                                icon: Icons.logout,
                                size: size,
                                onTap: () async {
                                  showLoadingDialog(context);
                                  await FirebaseAuth.instance.signOut();
                                   Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const App()),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                              )
                            ])
                          ],
                        ),
                      ),
                      context: context);
                }),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(18),
        child: SizedBox(
          width: 65,
          height: 65,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateTaskScreen()));
            },
            elevation: 3,
            backgroundColor: colorPrimary,
            child: const Icon(Icons.add, size: 30),
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .where('idUser',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .orderBy("timeModified", descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                      content:
                                          const Text("Are you sure you want to delete this note?"),
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
                          foregroundColor:
                              const Color.fromARGB(255, 190, 56, 56),
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
          }),
    );
  }
}

class OptionCard extends StatelessWidget {
  const OptionCard(
      {super.key,
      required this.size,
      required this.title,
      required this.icon,
      required this.onTap});
  final String title;
  final IconData icon;
  final void Function() onTap;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          height: 1,
          color: Colors.grey,
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 70,
            width: size.width,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Icon(icon),
                    )
                  ]),
          ),
        ),
      ],
    );
  }
}
