import 'package:firebase_auth/firebase_auth.dart';

class UserFirebase {
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      final user = auth.currentUser;
      if (user != null) {
        return "Login success";
      } else {
        return "User not found after login";
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signUp(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return "Register success";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> forgot(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);

      return "Send email success, pls check letter";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> logOut() async {
    try {
      await auth.signOut();

      return "Exit success";
    } catch (e) {
      return e.toString();
    }
  }
}
