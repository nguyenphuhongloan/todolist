import 'package:flutter/material.dart';

Future<dynamic> showLoadingDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
      barrierDismissible: false,
      barrierColor: const Color(0x80000000));
}
