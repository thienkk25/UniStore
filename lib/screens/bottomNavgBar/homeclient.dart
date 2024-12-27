import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
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
  int? selectedIndexType;
  bool isFilter = false;
  List<String> types = [
    "beauty",
    "fragrances",
    "furniture",
    "groceries",
    "home-decoration",
    "kitchen-accessories",
    "laptops",
    "mens-shirts",
    "mens-shoes",
    "mens-watches",
    "mobile-accessories",
    "motorcycle",
    "skin-care",
    "smartphones",
    "sports-accessories",
    "sunglasses",
    "tablets",
    "tops",
    "vehicle",
    "womens-bags",
    "womens-dresses",
    "womens-jewellery",
    "womens-shoes",
    "womens-watches"
  ];
  late List<bool> isCheckedFilter;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isDelayed = true;
      });
    });
    isCheckedFilter = List.generate(types.length, (index) => false);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   fetchDataProduct();
    // });
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
                    List<String> searchList = dataProduct
                        .map((e) => e.title)
                        .where((item) => item.toLowerCase().contains(data))
                        .toList();
                    return searchList.isNotEmpty
                        ? List.generate(
                            min(searchList.length, 20),
                            (index) => InkWell(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => InfoProduct(
                                            data: dataProduct[index],
                                          ))),
                              child: Container(
                                decoration: const BoxDecoration(
                                    border:
                                        Border(bottom: BorderSide(width: 1))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: Image.network(
                                      dataProduct[index].thumbnail,
                                      fit: BoxFit.cover,
                                      height: 50,
                                      width: 50,
                                    ),
                                    title: Column(
                                      children: [
                                        Text(
                                          searchList[index],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "\$ ${((dataProduct[index].price) / (1 - dataProduct[index].discountPercentage / 100)).toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "\$ ${dataProduct[index].price}",
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
                                      onTap: () async {
                                        try {
                                          if (!mounted) return;
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) => const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                          final url = Uri.parse(
                                              "https://dummyjson.com/products/category/${types[index]}");
                                          final response = await http.get(url);
                                          if (response.statusCode == 200) {
                                            final json =
                                                jsonDecode(response.body);

                                            // Lấy dữ liệu sản phẩm từ API
                                            List<Product> data =
                                                List<Product>.from(
                                              json['products'].map(
                                                  (e) => Product.fromJson(e)),
                                            );
                                            if (!mounted) return;
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pop();
                                            // Sau khi dữ liệu được tải, thực hiện setState và điều hướng
                                            setState(() {
                                              selectedIndexType = index;
                                              isCheckedFilter = List.generate(
                                                  types.length,
                                                  (index) => false);
                                              isFilter = false;
                                            });
                                            if (!mounted) return;
                                            // Điều hướng tới màn hình ViewMore với dữ liệu
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => ViewMore(
                                                  textTitileAppbar:
                                                      types[index],
                                                  data: data,
                                                ),
                                              ),
                                            );
                                          } else {
                                            if (!mounted) return;
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pop();
                                            // Nếu API không trả về mã 200, thông báo lỗi
                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Failed to load data: ${response.statusCode}')),
                                            );
                                          }
                                        } catch (e) {
                                          if (!mounted) return;
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context).pop();
                                          // Nếu có lỗi xảy ra, hiển thị thông báo lỗi
                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text('Error: $e')),
                                          );
                                        }
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
                              child: CircularProgressIndicator(),
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
                                            child: Image.network(
                                              popularProducts[index].thumbnail,
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
                      error: (error, stackTrace) => const Center(
                        child: Text("Error"),
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
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
                              child: CircularProgressIndicator(),
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
                            child: CircularProgressIndicator(),
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
                                                child: Image.network(
                                                  dataProductLoad[index]
                                                      .thumbnail,
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
                                                child: Image.network(
                                                  dataProductLoad[index]
                                                      .thumbnail,
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
                          child: CircularProgressIndicator(),
                        ),
                      )
                  ],
                ),
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
