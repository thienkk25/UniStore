import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:uni_store/firebase_options.dart';
import 'package:uni_store/keys.dart';
import 'package:uni_store/screens/home.dart';
import 'package:uni_store/screens/welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey = stripePublishableKey;
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late bool sessionUser;
  @override
  void initState() {
    checksessionUser();
    super.initState();
  }

  void checksessionUser() {
    sessionUser = FirebaseAuth.instance.currentUser != null ? true : false;
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
