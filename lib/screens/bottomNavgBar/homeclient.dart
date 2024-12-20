import 'dart:async';

import 'package:flutter/material.dart';
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
      body: Padding(
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
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndexType = index;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
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
            const Card(
              clipBehavior: Clip.antiAlias,
              child: Text("data"),
            )
          ],
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
