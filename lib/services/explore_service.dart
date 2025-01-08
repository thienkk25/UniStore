import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ExploreService {
  Stream<List> realTimeChat() {
    final fireDatabase = FirebaseDatabase.instance;

    return fireDatabase.ref('realTimeChat').onValue.map((event) {
      final dataMap = event.snapshot.value;

      if (dataMap is Map) {
        final data = List.from(dataMap.values);
        data.sort((a, b) => b['createAt'].compareTo(a['createAt']));

        return data;
      }
      return [];
    });
  }

  void sendRealTimeChat(String message) {
    final fireDatabase = FirebaseDatabase.instance;
    final auth = FirebaseAuth.instance;
    User user = auth.currentUser!;
    fireDatabase.ref('realTimeChat').push().set({
      "name": user.displayName ?? "Private",
      "email": user.email ?? "Private",
      "message": message,
      "createAt": DateTime.now().toIso8601String(),
    });
  }
}
