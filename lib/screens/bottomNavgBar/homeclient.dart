import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fashion/controllers/product_controller.dart';
import 'package:shop_fashion/models/product_model.dart';
import 'package:shop_fashion/screens/utilities/info_product.dart';
import 'package:shop_fashion/screens/utilities/notify.dart';
import 'package:shop_fashion/screens/utilities/profile.dart';
import 'package:shop_fashion/screens/utilities/view_more.dart';
import 'package:shop_fashion/services/riverpod.dart';

class Homeclient extends ConsumerStatefulWidget {
  const Homeclient({super.key});

  @override
  ConsumerState<Homeclient> createState() => _HomeclientState();
}

class _HomeclientState extends ConsumerState<Homeclient> {
  bool isDelayed = false;
  SearchController searchController = SearchController();
  ScrollController scrollController = ScrollController();

  int selectedIndexType = 0;
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
  // late List<bool> isCheckedFilter;
  bool isFilter = false;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isDelayed = true; // Thay đổi trạng thái để hiển thị nội dung sau 1 giây
      });
    });
    // isCheckedFilter = List.generate(types.length, (index) => false);
    // Future.microtask(() => fetchDataProduct());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchDataProduct();
    });

    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadMoreProduct();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void fetchDataProduct() {
    final productController = ref.read(productControllerProvider);
    productController.fetchDataProductController(ref);
  }

  void loadMoreProduct() async {
    final productController = ref.read(productControllerProvider);
    productController.loadMoreProductController(ref);
  }

  @override
  Widget build(BuildContext context) {
    final productController = ref.watch(productControllerProvider);
    final dataProductLoad = ref.watch(dataProductProvider);
    final dataProduc = productController.dataAllProductController(ref);
    List<String> types =
        dataProduc.map((e) => e.category).toList().toSet().toList();
    List<bool> isCheckedFilter = List.generate(types.length, (index) => false);
    List<String> dataListSearch = dataProduc.map((e) => e.title).toList();

    // Lọc các sản phẩm có createdAt sau ngày ...
    // DateTime filterDate = DateTime.parse("2023-01-01T08:56:21.620Z");
    // List<Product> newArrivals = dataProduc
    //     .where((element) => element.meta.createdAt.isAfter(filterDate))
    //     .toList();

    List<Product> newArrivals = productController.dataUriProductController(
        ref, "https://dummyjson.com/products?sortBy=createdAt&order=desc");
    List<Product> specialOffer = productController.dataUriProductController(ref,
        "https://dummyjson.com/products?sortBy=discountPercentage&order=desc");
    return isDelayed
        ? Scaffold(
            appBar: AppBar(
              title: const Text("Home"),
              actions: [
                SearchAnchor(
                  viewHintText: "Search...",
                  searchController: searchController,
                  builder: (context, controller) {
                    return IconButton(
                        onPressed: () {
                          controller.openView();
                        },
                        icon: const Icon(Icons.search));
                  },
                  suggestionsBuilder: (context, controller) {
                    final String data = controller.text.toLowerCase();
                    List<String> searchList = dataListSearch
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
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Notify()));
                  },
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Profile()));
                    },
                    icon: const Icon(Icons.account_box_rounded))
              ],
            ),
            body: SingleChildScrollView(
              controller: scrollController,
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
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Container(
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(width: 1))),
                                    child: const Text(
                                      "Filter",
                                    ),
                                  ),
                                  content: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setDialogState) {
                                      // `setDialogState` là hàm callback để thay đổi trạng thái của widget
                                      return SizedBox(
                                        height: 300, // Chiều cao của dialog
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        child: SingleChildScrollView(
                                          child: Wrap(
                                            clipBehavior: Clip.antiAlias,
                                            spacing: 5,
                                            runSpacing:
                                                5, // Khoảng cách giữa các dòng
                                            children: List.generate(
                                              types.length,
                                              (index) {
                                                return FilterChip(
                                                  side: const BorderSide(
                                                      color: Colors.orange),
                                                  selected:
                                                      isCheckedFilter[index],
                                                  onSelected: (bool value) {
                                                    setDialogState(() {
                                                      isCheckedFilter[index] =
                                                          value; // Cập nhật trạng thái của chip
                                                    });
                                                  },
                                                  selectedColor: Colors.orange,
                                                  label: Text(types[index]),
                                                  labelStyle: TextStyle(
                                                      color:
                                                          isCheckedFilter[index]
                                                              ? Colors.white
                                                              : Colors.orange),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  actions: [
                                    Container(
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(width: 1))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              bool check = isCheckedFilter.any(
                                                (element) => element == true,
                                              );
                                              setState(() {
                                                check
                                                    ? isFilter = true
                                                    : isFilter = false;
                                              });
                                            },
                                            child: const Text("Confirm"),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: isFilter
                                      ? Colors.orange
                                      : Colors.grey[300]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.filter_alt_outlined,
                                      color: isFilter
                                          ? Colors.white
                                          : Colors.black),
                                  Text(
                                    "Filter",
                                    style: TextStyle(
                                      color: isFilter
                                          ? Colors.white
                                          : Colors.black,
                                    ),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIndexType = index;
                                          isCheckedFilter = List.generate(
                                              types.length, (index) => false);
                                          isFilter = false;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: selectedIndexType == index &&
                                                  !isFilter
                                              ? Colors.orange
                                              : Colors.grey[300],
                                        ),
                                        child: Text(
                                          types[index],
                                          style: TextStyle(
                                            color: selectedIndexType == index &&
                                                    !isFilter
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ViewMore(
                                  textTitileAppbar: "Special Offer",
                                  data: specialOffer),
                            ));
                          },
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
                            builder: (context) => InfoProduct(
                              data: [specialOffer.first],
                            ),
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
                                      specialOffer.first.thumbnail,
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                        Text(specialOffer.first.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),
                                        Text(specialOffer.first.description,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                        Row(
                                          children: [
                                            Text(
                                              "\$ ${((specialOffer.first.price) / (1 - specialOffer.first.discountPercentage / 100)).toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "\$ ${specialOffer.first.price}",
                                              style: const TextStyle(
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ViewMore(
                                  textTitileAppbar: "Popular Product",
                                  data: popularProducts),
                            ));
                          },
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
                                  builder: (context) => InfoProduct(
                                    data: popularProducts[index],
                                  ),
                                )),
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              child: SizedBox(
                                width: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Stack(children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ViewMore(
                                  textTitileAppbar: "New Arrivals",
                                  data: newArrivals),
                            ));
                          },
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
                        itemCount: min(newArrivals.length, 8),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InfoProduct(
                                    data: [newArrivals[index]],
                                  ),
                                )),
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              child: SizedBox(
                                width: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          newArrivals[index].thumbnail,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        newArrivals[index].title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        newArrivals[index].description,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "\$ ${newArrivals[index].price.toString()}",
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
                    const Text(
                      "Product",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ref.watch(isLoadingProvider)
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    mainAxisExtent: 210),
                            itemCount: dataProductLoad.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InfoProduct(
                                        data: [dataProductLoad[index]],
                                      ),
                                    )),
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            dataProductLoad[index].thumbnail,
                                            height: 100,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(dataProductLoad[index].title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1),
                                        Text(
                                          dataProductLoad[index].description,
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "\$ ${((dataProductLoad[index].price) / (1 - dataProductLoad[index].discountPercentage / 100)).toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "\$ ${dataProductLoad[index].price}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                    if (ref.watch(isLoadingMoreProvider))
                      Container(
                        margin: const EdgeInsetsDirectional.only(
                            top: 20, bottom: 20),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                  ],
                ),
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
