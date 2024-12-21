import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_fashion/screens/utilities/info_product.dart';
import 'package:shop_fashion/screens/utilities/notify.dart';
import 'package:shop_fashion/screens/utilities/profile.dart';

class Homeclient extends StatefulWidget {
  const Homeclient({super.key});

  @override
  State<Homeclient> createState() => _HomeclientState();
}

class _HomeclientState extends State<Homeclient> {
  SearchController searchController = SearchController();
  List<String> dataList = ["thien", "dien", "thi"];
  List<String> suggestions = [];
  Timer? delayInput;
  List<String> types = ["All", "Official Store", "Nearest"];
  int selectedIndexType = 0;
  List popularProducts = [
    {
      "name": "A",
      "notes": "note A",
      "price": 1.00,
      "url":
          "https://res.cloudinary.com/dksr7si4o/image/upload/v1733016959/flutter/images/pizza_viy2lv.jpg"
    },
    {
      "name": "B",
      "notes": "note B",
      "price": 2.00,
      "url":
          "https://res.cloudinary.com/dksr7si4o/image/upload/v1733016959/flutter/images/pizza_viy2lv.jpg"
    },
    {
      "name": "C",
      "notes": "note C",
      "price": 3.00,
      "url":
          "https://res.cloudinary.com/dksr7si4o/image/upload/v1733016959/flutter/images/pizza_viy2lv.jpg"
    },
  ];

  @override
  void initState() {
    suggestions = dataList;
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    delayInput?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          SearchAnchor(
            viewHintText: "Search...",
            searchController: searchController,
            builder: (context, controller) {
              controller.addListener(() {
                onSearchChanged(controller.text);
              });
              return IconButton(
                  onPressed: () {
                    controller.openView();
                  },
                  icon: const Icon(Icons.search));
            },
            suggestionsBuilder: (context, controller) {
              final String data = controller.text.toLowerCase();
              List<String> searchList = dataList
                  .where((item) => item.toLowerCase().contains(data))
                  .toList();
              return searchList.isNotEmpty
                  ? List.generate(
                      searchList.length,
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
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Notify()));
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Profile()));
              },
              icon: const Icon(Icons.account_box_rounded))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 40,
                    width: 100,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[300],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.filter_alt_outlined),
                            Text(
                              "Filter",
                              // style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: types.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndexType = index;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: selectedIndexType == index
                                        ? Colors.orange
                                        : Colors.grey[300],
                                  ),
                                  child: Text(
                                    types[index],
                                    style: TextStyle(
                                      color: selectedIndexType == index
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Special Offer",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text("View More",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        )),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InfoProduct(),
                    )),
                child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadiusDirectional.circular(10),
                              child: Image.network(
                                "https://res.cloudinary.com/dksr7si4o/image/upload/v1733016959/flutter/images/pizza_viy2lv.jpg",
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  Text(
                                    "Skincare Bundle by Shop",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 2,
                                  ),
                                  Text(
                                    "For your intensive bodycare set",
                                    style: TextStyle(
                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 2,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "\$ 45.00",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "\$ 25.00",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                ]))
                          ],
                        ),
                      ),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Popular Product",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text("View More",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        )),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: min(popularProducts.length, 8),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InfoProduct(),
                          )),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: SizedBox(
                          width: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Stack(children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      popularProducts[index]['url'],
                                      height: 150,
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
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const Positioned(
                                  right: 0,
                                  bottom: 10,
                                  child: Icon(Icons.favorite))
                            ]),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "New Arrivals",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text("View More",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        )),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: min(popularProducts.length, 8),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InfoProduct(),
                          )),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: SizedBox(
                          width: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    popularProducts[index]['url'],
                                    height: 150,
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Product",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text("View More",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        )),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 400,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.65),
                  itemCount: min(popularProducts.length, 24),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InfoProduct(),
                          )),
                      child: SizedBox(
                        height: 260,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: SizedBox(
                            width: 200,
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
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSearchChanged(String search) {
    if (delayInput?.isActive ?? false) return delayInput?.cancel();

    delayInput = Timer(const Duration(milliseconds: 300), () {
      suggestions = dataList
          .where((item) => item.toLowerCase().contains(search))
          .toList();
    });
  }
}
