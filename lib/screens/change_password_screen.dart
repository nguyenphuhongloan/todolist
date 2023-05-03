import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/constants/constants.dart';
import 'package:todolist/repositories/auth_repository.dart';
import '../widgets/show_loading_dialog.dart';
import 'home_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _retypeNewPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    _emailController.text = FirebaseAuth.instance.currentUser!.email ?? "";
    _passwordController.text = '';
    _newPasswordController.text = '';
    _retypeNewPasswordController.text = '';
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
                const Positioned(
                  bottom: 15,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Change password, more secure!',
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
                      enabled: false,
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
                        labelText: 'New Password',
                        hintText: 'Enter your new password',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your new password";
                        } else if (value.length < 6) {
                          return "Please enter at least 6 characters";
                        }
                        return null;
                      },
                      cursorColor: colorPrimary,
                      controller: _newPasswordController,
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
                        labelText: 'Retype New Password',
                        hintText: 'Enter your retype new password',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your retype password";
                        } else if (value.length < 6) {
                          return "Please enter at least 6 characters";
                        } else if (value != _newPasswordController.text) {
                          return "Retype password doesn't match";
                        }
                        return null;
                      },
                      cursorColor: colorPrimary,
                      controller: _retypeNewPasswordController,
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
                        String newPassword = _newPasswordController.text;

                        bool result = await AuthRepository()
                            .changePassword(email, password, newPassword);
                        if (context.mounted) {
                          Navigator.pop(context);
                          if (result) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: colorPrimary,
                                content: Text(
                                  'Password Changed!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
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
                          'Change Password',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
