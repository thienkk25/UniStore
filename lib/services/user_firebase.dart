import 'package:firebase_auth/firebase_auth.dart';

class UserFirebase {
  Future<String> signIn(String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
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
    FirebaseAuth auth = FirebaseAuth.instance;
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
    FirebaseAuth auth = FirebaseAuth.instance;
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
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signOut();

      return "Exit success";
    } catch (e) {
      return e.toString();
    }
  }

  User? getInforUserAuth() {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser;
  }

  bool checksessionUser() {
    User? user = getInforUserAuth();
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }
}
