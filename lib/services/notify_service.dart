import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotifyNotifier extends StateNotifier<List<String>> {
  NotifyNotifier() : super([]);
  setSate() {
    state = [];
  }

  addSetState(String text) {
    state = [text, ...state];
  }
}

final notifyNotifierProvider =
    StateNotifierProvider<NotifyNotifier, List<String>>(
        (ref) => NotifyNotifier());
