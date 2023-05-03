import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  Future<bool> login(email, password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> register(email, password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> resetPassword(email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> changePassword(email, password, newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user!.reauthenticateWithCredential(credential).then((value) async {
        await user.updatePassword(newPassword);
      });

      return true;
    } catch (error) {
      return false;
    }
  }
}
