import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/screens/home_screen.dart';
import 'package:todolist/screens/login_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser);
    return FirebaseAuth.instance.currentUser != null
        ? HomeScreen()
        : LoginScreen();
  }
}
