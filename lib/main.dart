import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shop_fashion/firebase_options.dart';
import 'package:shop_fashion/screens/bottomNavgBar/cart.dart';
import 'package:shop_fashion/screens/bottomNavgBar/explore.dart';
import 'package:shop_fashion/screens/bottomNavgBar/homeclient.dart';
import 'package:shop_fashion/screens/home.dart';
import 'package:shop_fashion/screens/signin.dart';
import 'package:shop_fashion/screens/signup.dart';
import 'package:shop_fashion/screens/utilities/info_product.dart';
import 'package:shop_fashion/screens/utilities/profile.dart';
import 'package:shop_fashion/screens/utilities/view_more.dart';
import 'package:shop_fashion/screens/welcome.dart';

Future<void> main() async {
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
  late bool statusUser;
  @override
  void initState() {
    checkStatusUser();
    super.initState();
  }

  void checkStatusUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      statusUser = true;
    } else {
      statusUser = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: statusUser ? const Home() : const Welcome(),
      ),
    );
  }
}
