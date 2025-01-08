import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_fashion/screens/bottomNavgBar/Cart.dart';
import 'package:shop_fashion/screens/bottomNavgBar/explore_view.dart';
import 'package:shop_fashion/screens/bottomNavgBar/homeclient.dart';
import 'package:shop_fashion/screens/bottomNavgBar/wishlist.dart';
import 'package:shop_fashion/services/riverpod_home_view.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  int selectIndex = 0;
  final List<Widget> widgets = [
    const Homeclient(),
    const ExploreView(),
    const Cart(),
    const Wishlist()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: selectIndex, children: widgets),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.amber[50],
        animationDuration: const Duration(milliseconds: 300),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        backgroundColor: Colors.black26,
        selectedIndex: selectIndex,
        onDestinationSelected: (value) {
          setState(() {
            selectIndex = value;
          });
        },
        destinations: [
          NavigationDestination(
              icon: Lottie.asset("assets/lotties/home.json",
                  height: 30, width: 30, fit: BoxFit.contain),
              label: "Home"),
          NavigationDestination(
              icon: Lottie.asset("assets/lotties/globe.json",
                  height: 30, width: 30, fit: BoxFit.contain),
              label: "Explore"),
          NavigationDestination(
              icon: ref.watch(badgeCartProvider) != 0
                  ? Badge(
                      label: Text(ref.watch(badgeCartProvider).toString()),
                      child: Lottie.asset("assets/lotties/cart.json",
                          height: 30, width: 30, fit: BoxFit.contain),
                    )
                  : Lottie.asset("assets/lotties/cart.json",
                      height: 30, width: 30, fit: BoxFit.contain),
              label: "Cart"),
          NavigationDestination(
              icon: ref.watch(badgeFavoriteProvider) != 0
                  ? Badge(
                      label: Text(ref.watch(badgeFavoriteProvider).toString()),
                      child: Lottie.asset("assets/lotties/heart.json",
                          height: 30, width: 30, fit: BoxFit.contain),
                    )
                  : Lottie.asset("assets/lotties/heart.json",
                      height: 30, width: 30, fit: BoxFit.contain),
              label: "Wishlist"),
        ],
      ),
    );
  }
}
