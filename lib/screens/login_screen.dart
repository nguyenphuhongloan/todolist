import 'package:flutter/material.dart';
import 'package:todolist/constants/constants.dart';
import 'package:todolist/repositories/auth_repository.dart';
import 'package:todolist/screens/register_screen.dart';
import 'package:todolist/screens/reset_password.dart';

import '../widgets/show_loading_dialog.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    _emailController.text = '';
    _passwordController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/img_header_login.png',
                  fit: BoxFit.contain,
                ),
                // Positioned(
                //   top: 75,
                //   left: 20,
                //   child: Container(
                //     padding: const EdgeInsets.all(10),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(15),
                //       color: Colors.white,
                //     ),
                //     child: const Icon(
                //       Icons.arrow_back,
                //       size: 16,
                //     ),
                //   ),
                // ),
                const Positioned(
                  bottom: 15,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Hi, Welcome back!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        final RegExp emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: colorPrimary,
                          ),
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                        ),
                      ),
                      cursorColor: colorPrimary,
                      controller: _emailController,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      obscureText: isVisible,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          child: Icon(
                            isVisible ? Icons.visibility : Icons.visibility_off,
                            size: 20,
                            color: colorPrimary,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: colorPrimary,
                          ),
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        } else if (value.length < 6) {
                          return "Please enter at least 6 characters";
                        }
                        return null;
                      },
                      cursorColor: colorPrimary,
                      controller: _passwordController,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ResetPassword()),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 18.0),
                        child: Text(
                          'Forgot password',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 15,
                            color: colorPrimary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () async {
                      if (_formkey.currentState!.validate()) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        showLoadingDialog(context);
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        bool result =
                            await AuthRepository().login(email, password);
                        if (mounted) {
                          Navigator.pop(context);
                          if (result) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: colorPrimary,
                                content: Text(
                                  'Credentials are not correct!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      //margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [colorPrimary, Color(0xff6357CC)],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Log In',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                      children: [
                        const TextSpan(
                          text: "Don't have an account? ",
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RegisterScreen()),
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: colorPrimary,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
