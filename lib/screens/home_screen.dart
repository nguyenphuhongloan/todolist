import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:todolist/app.dart';
import 'package:todolist/constants/constants.dart';
import 'package:todolist/screens/change_password_screen.dart';
import 'package:todolist/screens/create_todo_screen.dart';
import 'package:todolist/widgets/show_loading_dialog.dart';
import 'package:todolist/widgets/task_view.dart';
import '../widgets/todo_view.dart';
import 'create_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Todo List"),
          backgroundColor: colorPrimary,
          bottom: PreferredSize(
              preferredSize: _tabBar.preferredSize,
              child: Material(
                color: const Color(0xfff8F9FA),
                child: _tabBar,
              )),
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
                                    if(mounted){
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const App()),
                                        (Route<dynamic> route) => false,
                                      );
                                    }
                                    
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
                        builder: (context) => _tabController.index == 0 ? const CreateTaskScreen() : const CreateTodoScreen()));
              },
              elevation: 3,
              backgroundColor: colorPrimary,
              child: const Icon(Icons.add, size: 30),
            ),
          ),
        ),
        body: TabBarView(
            controller: _tabController, children: const [TaskView(), TodoView()]),
      ),
    );
  }

  TabBar get _tabBar => TabBar(
        labelColor: colorPrimary,
        unselectedLabelColor: Colors.grey,
        indicatorColor: colorPrimary,
        controller: _tabController,
        tabs: const [
          Tab(child: Text("Task")),
          Tab(child: Text("Todo")),
        ],
      );
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
