import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shop_fashion/firebase_options.dart';
import 'package:shop_fashion/screens/bottomNavgBar/cart.dart';
import 'package:shop_fashion/screens/bottomNavgBar/explore.dart';
import 'package:shop_fashion/screens/bottomNavgBar/homeclient.dart';
import 'package:shop_fashion/screens/home.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );
  }
}
