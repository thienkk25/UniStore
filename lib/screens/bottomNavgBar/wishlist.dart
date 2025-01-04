import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fashion/controllers/product_controller.dart';
import 'package:shop_fashion/models/product_model.dart';
import 'package:shop_fashion/screens/utilities/info_product.dart';
import 'package:shop_fashion/services/notify_service.dart';
import 'package:shop_fashion/services/riverpod_home_view.dart';
import 'package:shop_fashion/services/riverpod_product.dart';

class Wishlist extends ConsumerStatefulWidget {
  const Wishlist({super.key});
  @override
  ConsumerState<Wishlist> createState() => _Whilist();
}

class _Whilist extends ConsumerState<Wishlist> {
  late List<Product> favoriteProducts;
  @override
  void initState() {
    Future.microtask(() {
      ref.read(productControllerProvider).fetchFavoriteProductController(ref);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SearchController searchController = SearchController();
    final double availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    favoriteProducts = ref.watch(favoriteProductNotifierProvider);

    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: availableHeight / 7,
          width: double.infinity,
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.orange, Colors.orangeAccent])),
            padding: const EdgeInsets.all(10.0),
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                "Wish List",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 60,
          width: double.infinity,
          child: Container(
            margin: const EdgeInsets.all(10),
            child: SearchAnchor.bar(
              viewHintText: "Search...",
              searchController: searchController,
              suggestionsBuilder: (context, controller) {
                final String data = controller.text.toLowerCase();
                List<Product> searchList = favoriteProducts
                    .where((e) => e.title.toLowerCase().contains(data))
                    .toList();
                return searchList.isNotEmpty
                    ? List.generate(
                        min(searchList.length, 10),
                        (index) => InkWell(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => InfoProduct(
                                            data: searchList[index],
                                          ))),
                              child: Container(
                                decoration: const BoxDecoration(
                                    border:
                                        Border(bottom: BorderSide(width: 1))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: Image.network(
                                      searchList[index].thumbnail,
                                      fit: BoxFit.cover,
                                      height: 50,
                                      width: 50,
                                    ),
                                    title: Column(
                                      children: [
                                        Text(
                                          searchList[index].title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "\$ ${((searchList[index].price) / (1 - searchList[index].discountPercentage / 100)).toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "\$ ${searchList[index].price}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ))
                    : [
                        const ListTile(
                          title: Text("No results found"),
                        )
                      ];
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 650) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            mainAxisExtent: 220),
                    itemCount: favoriteProducts.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => InfoProduct(
                              data: favoriteProducts[index],
                            ),
                          ));
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        favoriteProducts[index].thumbnail,
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      favoriteProducts[index].title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      favoriteProducts[index].description,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "\$ ${((favoriteProducts[index].price) / (1 - favoriteProducts[index].discountPercentage / 100)).toStringAsFixed(2)}",
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "\$ ${favoriteProducts[index].price}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: TextButton(
                                    onPressed: () {
                                      deleteFavorite(favoriteProducts[index].id,
                                          favoriteProducts[index]);
                                    },
                                    child: const Text(
                                      "Unfavorite",
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            mainAxisExtent: 220),
                    itemCount: favoriteProducts.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => InfoProduct(
                              data: favoriteProducts[index],
                            ),
                          ));
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        favoriteProducts[index].thumbnail,
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      favoriteProducts[index].title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      favoriteProducts[index].description,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "\$ ${((favoriteProducts[index].price) / (1 - favoriteProducts[index].discountPercentage / 100)).toStringAsFixed(2)}",
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "\$ ${favoriteProducts[index].price}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: TextButton(
                                    onPressed: () {
                                      deleteFavorite(favoriteProducts[index].id,
                                          favoriteProducts[index]);
                                    },
                                    child: const Text(
                                      "Unfavorite",
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ],
    ));
  }

  Future<void> deleteFavorite(int id, Product product) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      ),
    );
    ref
        .read(favoriteProductNotifierProvider.notifier)
        .removeStateFavorite(product);

    ref.read(badgeFavoriteProvider.notifier).state--;
    final result = await ref
        .watch(productControllerProvider)
        .deleteFavoriteProductController(id);
    ref
        .read(notifyNotifierProvider.notifier)
        .addSetState("$result ${product.title}");
    ref.read(badgeNotifyProvider.notifier).state++;
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
  }
}
