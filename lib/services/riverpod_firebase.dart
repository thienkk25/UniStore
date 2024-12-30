// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<String> signIn(String email, String password) async {
  try {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signInWithEmailAndPassword(email: email, password: password);
    final user = auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return "User not found after login";
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == "invalid-email") {
      return "Email address is not valid";
    } else if (e.code == "wrong-password") {
      return "Email or Password not correct";
    }
    return "Unknown error";
  } catch (e) {
    return e.toString();
  }
}

final signInProvider =
    FutureProvider.family<String, Map<String, String>>((ref, prams) {
  return signIn(prams['email']!, prams['password']!);
});

Future<String> signUp(String email, String password) async {
  try {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.createUserWithEmailAndPassword(email: email, password: password);

    return "Register success";
  } on FirebaseAuthException catch (e) {
    if (e.code == "email-already-in-use") {
      return "Email already exists";
    } else if (e.code == "invalid-email") {
      return "Email address is not valid";
    } else if (e.code == "weak-password") {
      return "Password too weak";
    }
    return "Unknown error";
  } catch (e) {
    return e.toString();
  }
}

final signOutProvider =
    FutureProvider.family<String, Map<String, String>>((ref, prams) {
  return signUp(prams['email']!, prams['password']!);
});

Future<String> logOut() async {
  try {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    return "Exit success";
  } catch (e) {
    return e.toString();
  }
}

final logOutProvider = FutureProvider<String>((ref) => logOut());
