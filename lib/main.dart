import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shop_fashion/firebase_options.dart';
import 'package:shop_fashion/screens/home.dart';
import 'package:shop_fashion/screens/welcome.dart';
import 'package:shop_fashion/services/user_firebase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool sessionUser;
  @override
  void initState() {
    checksessionUser();
    super.initState();
  }

  void checksessionUser() {
    bool user = UserFirebase().checksessionUser();
    sessionUser = user;
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: sessionUser ? const Home() : const Welcome(),
      ),
    );
  }
}
