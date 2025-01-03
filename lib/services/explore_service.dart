import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ExploreService {
  final fireDatabase = FirebaseDatabase.instance;
  final auth = FirebaseAuth.instance;

  Stream<List> realTimeChat() {
    return fireDatabase.ref('realTimeChat').onValue.map((event) {
      final dataMap = event.snapshot.value;

      if (dataMap is Map) {
        final data = List.from(dataMap.values);

        return data;
      }
      return [];
    });
  }

  void sendRealTimeChat(String message) {
    User user = auth.currentUser!;
    fireDatabase.ref('realTimeChat').push().set({
      "name": user.displayName ?? "Private",
      "email": user.email ?? "Private",
      "message": message,
      "createAt": DateTime.now().toIso8601String(),
    });
  }
}
