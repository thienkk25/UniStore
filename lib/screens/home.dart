import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fashion/screens/bottomNavgBar/Cart.dart';
import 'package:shop_fashion/screens/bottomNavgBar/Explore.dart';
import 'package:shop_fashion/screens/bottomNavgBar/homeclient.dart';
import 'package:shop_fashion/screens/bottomNavgBar/wishlist.dart';
import 'package:shop_fashion/services/riverpod_product.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  int selectIndex = 0;
  final List<Widget> widgets = [
    const Homeclient(),
    const Explore(),
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
              icon: Icon(
                Icons.home,
                color: selectIndex == 0 ? Colors.orange : Colors.black,
              ),
              label: "Home"),
          NavigationDestination(
              icon: Icon(
                Icons.explore_outlined,
                color: selectIndex == 1 ? Colors.orange : Colors.black,
              ),
              label: "Explore"),
          NavigationDestination(
              icon: Icon(
                Icons.shopping_bag_outlined,
                color: selectIndex == 2 ? Colors.orange : Colors.black,
              ),
              label: "Cart"),
          NavigationDestination(
              icon: Icon(
                Icons.favorite_border_outlined,
                color: selectIndex == 3 ? Colors.orange : Colors.black,
              ),
              label: "Wishlist"),
        ],
      ),
    );
  }
}
