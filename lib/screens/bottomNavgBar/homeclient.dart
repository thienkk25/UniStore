import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fashion/controllers/product_controller.dart';
import 'package:shop_fashion/models/product_model.dart';
import 'package:shop_fashion/screens/utilities/info_product.dart';
import 'package:shop_fashion/screens/utilities/notify.dart';
import 'package:shop_fashion/screens/utilities/profile.dart';
import 'package:shop_fashion/screens/utilities/view_more.dart';
import 'package:shop_fashion/services/riverpod_home_view.dart';
import 'package:shop_fashion/services/riverpod_product.dart';

class Homeclient extends ConsumerStatefulWidget {
  const Homeclient({super.key});

  @override
  ConsumerState<Homeclient> createState() => _HomeclientState();
}

class _HomeclientState extends ConsumerState<Homeclient> {
  bool isDelayed = false;
  SearchController searchController = SearchController();
  ScrollController scrollController = ScrollController();
  int? selectedIndexType;
  bool isFilter = false;
  List<String> types = TypesProduct().types;
  late List<bool> isCheckedFilter;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isDelayed = true;
      });
    });
    isCheckedFilter = List.generate(types.length, (index) => false);
    Future.microtask(() => fetchDataProduct());
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
    final productController = ref.watch(productControllerProvider);
    productController.fetchDataProductController(ref);
  }

  void loadMoreProduct() async {
    final productController = ref.watch(productControllerProvider);
    productController.loadMoreProductController(ref);
  }

  @override
  Widget build(BuildContext context) {
    final productController = ref.watch(productControllerProvider);
    List<Product> dataProduct = productController.dataAllProductController(ref);
    final dataProductLoad = ref.watch(dataProductProvider);
    AsyncValue<List<Product>> specialOfferAsyncValue =
        productController.dataUriProductController(ref,
            "https://dummyjson.com/products?sortBy=discountPercentage&order=desc");

    AsyncValue<List<Product>> popularProductsAsyncValue =
        productController.dataUriProductController(
            ref, "https://dummyjson.com/products?sortBy=rating&order=desc");
    AsyncValue<List<Product>> newArrivalsAsyncValue =
        productController.dataUriProductController(
            ref, "https://dummyjson.com/products?sortBy=createdAt&order=desc");
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
                    List<Product> searchList = dataProduct
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
                                    leading: CachedNetworkImage(
                                      imageUrl: searchList[index].thumbnail,
                                      progressIndicatorBuilder:
                                          (context, url, progress) =>
                                              const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
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
                  icon: ref.watch(badgeNotifyProvider) != 0
                      ? Badge(
                          label:
                              Text(ref.watch(badgeNotifyProvider).toString()),
                          child: const Icon(Icons.notifications))
                      : const Icon(Icons.notifications),
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
                                      return SizedBox(
                                        height: 300,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        child: SingleChildScrollView(
                                          child: Wrap(
                                            clipBehavior: Clip.antiAlias,
                                            spacing: 5,
                                            runSpacing: 5,
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
                                                          value;
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
                                              confirmFilter(dataProduct);
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
                                        typesPushViewMore(index, dataProduct);
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
                            specialOfferAsyncValue.whenData((specialOffer) =>
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ViewMore(
                                      textTitileAppbar: "Special Offer",
                                      data: specialOffer),
                                )));
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
                    specialOfferAsyncValue.when(
                        data: (specialOffer) => GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InfoProduct(
                                      data: specialOffer.first,
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
                                                BorderRadiusDirectional
                                                    .circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  specialOffer.first.thumbnail,
                                              progressIndicatorBuilder: (context,
                                                      url, progress) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                Text(
                                                    specialOffer[0].description,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "\$ ${((specialOffer[0].price) / (1 - specialOffer[0].discountPercentage / 100)).toStringAsFixed(2)}",
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "\$ ${specialOffer[0].price}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                )
                                              ]))
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                        error: (error, stackTrace) => const Text("Error"),
                        loading: () => const Center(
                              child: CircularProgressIndicator(
                                color: Colors.orange,
                              ),
                            )),
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
                            popularProductsAsyncValue.whenData(
                                (popularProducts) => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ViewMore(
                                          textTitileAppbar: "Popular Product",
                                          data: popularProducts),
                                    )));
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
                    popularProductsAsyncValue.when(
                      data: (popularProducts) => SizedBox(
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
                                            child: CachedNetworkImage(
                                              imageUrl: popularProducts[index]
                                                  .thumbnail,
                                              progressIndicatorBuilder: (context,
                                                      url, progress) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                              height: 150,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            popularProducts[index].title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            popularProducts[index].description,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "\$ ${((popularProducts[index].price) / (1 - popularProducts[index].discountPercentage / 100)).toStringAsFixed(2)}",
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "\$ ${popularProducts[index].price}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                          left: 2,
                                          top: 2,
                                          child: Row(
                                            children: [
                                              Text(popularProducts[index]
                                                  .rating
                                                  .toString()),
                                              const Icon(
                                                Icons.star,
                                                color: Colors.orange,
                                              )
                                            ],
                                          ))
                                    ]),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      error: (error, stackTrace) => const Center(
                        child: Text("Error"),
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                        ),
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
                            newArrivalsAsyncValue.whenData((newArrivals) =>
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ViewMore(
                                      textTitileAppbar: "New Arrivals",
                                      data: newArrivals),
                                )));
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
                    newArrivalsAsyncValue.when(
                        data: (newArrivals) => SizedBox(
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
                                            data: newArrivals[index],
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
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  imageUrl: newArrivals[index]
                                                      .thumbnail,
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              progress) =>
                                                          const CircularProgressIndicator(),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                  height: 150,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                newArrivals[index].title,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                        error: (error, stackTrace) => const Center(
                              child: Text("Error"),
                            ),
                        loading: () => const Center(
                              child: CircularProgressIndicator(
                                color: Colors.orange,
                              ),
                            )),
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
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                            ),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              if (constraints.maxWidth < 650) {
                                return GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                          mainAxisExtent: 230),
                                  itemCount: dataProductLoad.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => InfoProduct(
                                              data: dataProductLoad[index],
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
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      dataProductLoad[index]
                                                          .thumbnail,
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              progress) =>
                                                          const CircularProgressIndicator(),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                  height: 100,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(dataProductLoad[index].title,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1),
                                              Text(
                                                dataProductLoad[index]
                                                    .description,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Wrap(
                                                alignment:
                                                    WrapAlignment.spaceBetween,
                                                runAlignment:
                                                    WrapAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "\$ ${((dataProductLoad[index].price) / (1 - dataProductLoad[index].discountPercentage / 100)).toStringAsFixed(2)}",
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "\$ ${dataProductLoad[index].price}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
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
                                              data: dataProductLoad[index],
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
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      dataProductLoad[index]
                                                          .thumbnail,
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              progress) =>
                                                          const CircularProgressIndicator(),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                  height: 100,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(dataProductLoad[index].title,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1),
                                              Text(
                                                dataProductLoad[index]
                                                    .description,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "\$ ${((dataProductLoad[index].price) / (1 - dataProductLoad[index].discountPercentage / 100)).toStringAsFixed(2)}",
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "\$ ${dataProductLoad[index].price}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
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
                    if (ref.watch(isLoadingMoreProvider))
                      Container(
                        margin: const EdgeInsetsDirectional.only(
                            top: 20, bottom: 20),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
  }

  void typesPushViewMore(int index, List<Product> dataProduct) {
    setState(() {
      selectedIndexType = index;
      isCheckedFilter = List.generate(types.length, (index) => false);
      isFilter = false;
    });
    List<Product> dataProductFilter = [];

    dataProductFilter = dataProduct
        .where((element) => element.category == types[index])
        .toList();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          ViewMore(textTitileAppbar: types[index], data: dataProductFilter),
    ));
  }

  void confirmFilter(List<Product> dataProduct) {
    bool check = isCheckedFilter.any(
      (element) => element == true,
    );

    setState(() {
      if (check) {
        Navigator.of(context).pop();
        isFilter = true;
        List<Product> dataProductFilter = [];

        dataProductFilter = dataProduct
            .where((element) => List.generate(isCheckedFilter.length, (index) {
                  if (isCheckedFilter[index]) {
                    return types[index];
                  }
                  return null; // Return null for unchecked filters
                })
                    .where((category) => category != null)
                    .contains(element.category))
            .toList();

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ViewMore(textTitileAppbar: "Filter", data: dataProductFilter),
        ));
      } else {
        isFilter = false;
      }
    });
  }
}
