import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fashion/services/riverpod_firebase.dart';

class UserController {
  AsyncValue<String> signInController(
      WidgetRef ref, String email, String password) {
    final result =
        ref.watch(signInProvider({email: email, password: password}));
    return result;
  }

  AsyncValue<String> signOutController(
      WidgetRef ref, String email, String password) {
    final result =
        ref.watch(signOutProvider({email: email, password: password}));
    return result;
  }

  AsyncValue<String> logOutController(WidgetRef ref) {
    final result = ref.watch(logOutProvider);
    return result;
  }
}

final userControllerProvider = Provider((ref) => UserController);
