import 'package:firebase_auth/firebase_auth.dart';
import 'package:uni_store/services/user_firebase.dart';

class UserController {
  final UserFirebase userFirebase = UserFirebase();
  Future<String> signInController(String email, String password) {
    final result = userFirebase.signIn(email, password);
    return result;
  }

  Future<String> signOutController(String email, String password) {
    final result = userFirebase.signUp(email, password);
    return result;
  }

  Future<String> forgotController(String email) {
    final result = userFirebase.forgot(email);
    return result;
  }

  Future<String> logOutController() {
    final result = userFirebase.logOut();
    return result;
  }

  User? getInforUserAuthController() {
    final result = userFirebase.getInforUserAuth();
    return result;
  }
}
