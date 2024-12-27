import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_fashion/screens/utilities/info_product.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  SearchController searchController = SearchController();
  List<String> dataList = ["thien", "dien", "thi"];

  List popularProducts = [
    {
      "name": "A",
      "notes": "note A",
      "price": 1.00,
      "url":
          "https://res.cloudinary.com/dksr7si4o/image/upload/v1733016957/flutter/images/pho_bjsnip.jpg"
    },
    {
      "name": "B",
      "notes": "note B",
      "price": 2.00,
      "url":
          "https://res.cloudinary.com/dksr7si4o/image/upload/v1733016957/flutter/images/bunbohue_xp0hkv.jpg"
    },
    {
      "name": "C",
      "notes": "note C",
      "price": 3.00,
      "url":
          "https://res.cloudinary.com/dksr7si4o/image/upload/v1733016957/flutter/images/banhxeo_rweqcc.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final double availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
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
                List<String> searchList = dataList
                    .where((item) => item.toLowerCase().contains(data))
                    .toList();
                return searchList.isNotEmpty
                    ? List.generate(
                        min(searchList.length, 20),
                        (index) => ListTile(
                          title: Text(searchList[index]),
                        ),
                      )
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
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 220),
              itemCount: popularProducts.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => InfoProduct(
                      data: popularProducts[index],
                    ),
                  )),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              popularProducts[index]['url'],
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(popularProducts[index]['name'],
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1),
                          Text(
                            popularProducts[index]['notes'],
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            "\$ ${popularProducts[index]['price'].toString()}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ));
  }
}
