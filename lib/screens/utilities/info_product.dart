// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';
import 'package:shop_fashion/controllers/product_controller.dart';

import 'package:shop_fashion/custom/button_view.dart';
import 'package:shop_fashion/models/product_model.dart';
import 'package:shop_fashion/services/notify_service.dart';
import 'package:shop_fashion/services/riverpod_home_view.dart';
import 'package:shop_fashion/services/riverpod_product.dart';

class InfoProduct extends ConsumerStatefulWidget {
  final Product data;
  const InfoProduct({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<InfoProduct> createState() => _InfoProductState();
}

class _InfoProductState extends ConsumerState<InfoProduct> {
  int selectedIndexImage = 0;
  List<String> tabSupport = ["Description", "Reviews", "Policy"];
  int selectedIndexSupport = 0;
  int currentSupportPageProvider = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> pagesSupport = [
      PageOneSupport(
        description: widget.data.description,
      ),
      PageTwoSupport(product: widget.data),
      PageThreeSupport(product: widget.data),
    ];
    final PageController pageController = PageController();
    final double availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: availableHeight / 2,
              width: double.infinity,
              child: Stack(
                children: [
                  PageView.builder(
                    onPageChanged: (value) => setState(() {
                      selectedIndexImage = value;
                    }),
                    controller: pageController,
                    itemCount: widget.data.images.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onDoubleTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageViewerPage(
                                  initialIndex: index,
                                  imageProduct: widget.data.images,
                                ),
                              ));
                        },
                        child: CachedNetworkImage(
                          imageUrl: widget.data.images[index],
                          progressIndicatorBuilder: (context, url, progress) =>
                              Lottie.asset("assets/lotties/loading.json",
                                  height: 100, width: 100, fit: BoxFit.contain),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 30,
                    left: 10,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Lottie.asset("assets/lotties/arrow_left.json",
                          width: 30, height: 30, fit: BoxFit.contain),
                    ),
                  ),
                  Positioned(
                      right: 0,
                      left: 0,
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(
                              widget.data.images.length,
                              (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: CircleAvatar(
                                      radius: 4,
                                      backgroundColor:
                                          selectedIndexImage == index
                                              ? Colors.orange
                                              : Colors.grey,
                                    ),
                                  ))
                        ],
                      )),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        height: 40,
                        width: 40,
                        margin: const EdgeInsets.only(top: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.orange, width: 1)),
                        child: InkWell(
                          onTap: () {
                            addFavorite();
                          },
                          child: const Icon(
                            Icons.favorite_border_outlined,
                            color: Colors.orange,
                          ),
                        )),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.data.category,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              widget.data.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: FittedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "\$ ${((widget.data.price) / (1 - widget.data.discountPercentage / 100)).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "\$ ${widget.data.price}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: tabSupport.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndexSupport = index;
                                  currentSupportPageProvider = index;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                    color: selectedIndexSupport == index
                                        ? Colors.orange
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  tabSupport[index],
                                  style: TextStyle(
                                      color: selectedIndexSupport == index
                                          ? Colors.white
                                          : Colors.orange),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      IndexedStack(
                        index: currentSupportPageProvider,
                        children: pagesSupport,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.orangeAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 40,
                width: 150,
                child: InkWell(
                  onTap: () {
                    addToCart();
                  },
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange, width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.orange,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Add to Cart",
                            style: TextStyle(color: Colors.orange),
                          ),
                        ],
                      )),
                ),
              ),
              SizedBox(
                height: 40,
                width: 150,
                child: ButtonView(text: "Buy Now", voidCallback: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addToCart() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
        child: Lottie.asset("assets/lotties/loading.json",
            height: 100, width: 100, fit: BoxFit.contain),
      ),
    );

    final result = await ref
        .watch(productControllerProvider)
        .addCartProductController(widget.data.id);
    if (result == "Add Success") {
      ref
          .read(cartProductNotifierProvider.notifier)
          .addStateCartProduct(widget.data);
      ref
          .read(textEditingControllerYourCartsProvider.notifier)
          .addStateTextEditingControllerYourCarts(
              ref.watch(quantityProvider).toString());
      ref.read(checkBoxYourCartsProvider.notifier).addStatecheckBoxYourCarts();
      ref.read(quantityProvider.notifier).state = 1;
      ref.read(badgeCartProvider.notifier).state++;
      ref
          .read(notifyNotifierProvider.notifier)
          .addSetState("$result ${widget.data.title}");
      ref.read(badgeNotifyProvider.notifier).state++;
    }

    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
  }

  Future<void> addFavorite() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
        child: Lottie.asset("assets/lotties/loading.json",
            height: 100, width: 100, fit: BoxFit.contain),
      ),
    );
    ref
        .read(favoriteProductNotifierProvider.notifier)
        .addStateFavorite(widget.data);

    final result = await ref
        .watch(productControllerProvider)
        .addFavoriteProductController(widget.data.id);
    if (result == "Favorite Success") {
      ref.read(badgeFavoriteProvider.notifier).state++;
      ref
          .read(notifyNotifierProvider.notifier)
          .addSetState("$result ${widget.data.title}");
      ref.read(badgeNotifyProvider.notifier).state++;
    }
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
  }
}

class ImageViewerPage extends StatefulWidget {
  final int initialIndex;
  final List<String> imageProduct;

  const ImageViewerPage(
      {super.key, required this.initialIndex, required this.imageProduct});

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  late int onLocation;
  @override
  void initState() {
    onLocation = widget.initialIndex + 1;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PageController pageController =
        PageController(initialPage: widget.initialIndex);
    return Scaffold(
        body: Stack(
      children: [
        PageView.builder(
          onPageChanged: (value) {
            setState(() {
              onLocation = value + 1;
            });
          },
          controller: pageController,
          itemCount: widget.imageProduct.length,
          itemBuilder: (context, index) {
            return Hero(
              tag: widget.imageProduct[index],
              child: CachedNetworkImage(
                imageUrl: widget.imageProduct[index],
                progressIndicatorBuilder: (context, url, progress) =>
                    Lottie.asset("assets/lotties/loading.json",
                        height: 100, width: 100, fit: BoxFit.contain),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            );
          },
        ),
        Positioned(
          top: 30,
          left: 10,
          child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back,
                size: 30,
              )),
        ),
        Positioned(
          top: 30,
          right: 10,
          child: Text("$onLocation/${widget.imageProduct.length}"),
        ),
      ],
    ));
  }
}

class PageOneSupport extends ConsumerStatefulWidget {
  final String description;
  const PageOneSupport({super.key, required this.description});

  @override
  ConsumerState<PageOneSupport> createState() => _PageOneSupportState();
}

class _PageOneSupportState extends ConsumerState<PageOneSupport> {
  TextEditingController quantityController = TextEditingController(text: "1");
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReadMoreText(
          widget.description,
          style: const TextStyle(color: Colors.grey),
          trimMode: TrimMode.Line,
          trimLines: 3,
          colorClickableText: Colors.black,
          trimCollapsedText: 'Show more',
          trimExpandedText: 'Show less',
          moreStyle: const TextStyle(
              color: Colors.orange, fontWeight: FontWeight.bold),
          lessStyle:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Quantity:"),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {});
                        if (quantityController.text.isEmpty) {
                          quantityController.text = "1";
                        } else if (int.parse(quantityController.text) == 999) {
                        } else {
                          quantityController.text =
                              (int.parse(quantityController.text) + 1)
                                  .toString();
                          ref.read(quantityProvider.notifier).state =
                              int.parse(quantityController.text);
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            color: Colors.grey[300],
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 20,
                            color: Colors.orange,
                          ))),
                ),
                SizedBox(
                  height: 20,
                  width: 40,
                  child: TextField(
                    controller: quantityController,
                    style: const TextStyle(fontSize: 14),
                    cursorHeight: 14,
                    cursorColor: Colors.orange,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide:
                              BorderSide(color: Colors.black, width: 1)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(width: 1),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: -2, horizontal: 0), // Căn giữa nội dung
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3)
                    ],
                    maxLines: 1,
                    textAlign: TextAlign.center, // Căn giữa nội dung văn bản
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {});
                        if (quantityController.text.isEmpty) {
                          quantityController.text = "1";
                        } else if (int.parse(quantityController.text) == 0 ||
                            int.parse(quantityController.text) == 1) {
                        } else {
                          quantityController.text =
                              (int.parse(quantityController.text) - 1)
                                  .toString();
                          ref.read(quantityProvider.notifier).state =
                              int.parse(quantityController.text);
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            color: Colors.grey[300],
                          ),
                          child: const Icon(
                            Icons.remove,
                            size: 20,
                            color: Colors.orange,
                          ))),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}

class PageTwoSupport extends StatefulWidget {
  final Product product;
  const PageTwoSupport({super.key, required this.product});

  @override
  State<PageTwoSupport> createState() => _PageTwoSupportState();
}

class _PageTwoSupportState extends State<PageTwoSupport> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.star,
              color: Colors.orange,
            ),
            Text(widget.product.rating.toString())
          ],
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) => ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.product.reviews[index].reviewerName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            Text(
                                widget.product.reviews[index].rating.toString())
                          ],
                        ),
                      ],
                    ),
                    Text(
                      widget.product.reviews[index].date
                          .toString()
                          .substring(0, 10),
                      style: TextStyle(fontSize: 8, color: Colors.grey[500]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
                Text(
                  widget.product.reviews[index].reviewerEmail,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                Text(widget.product.reviews[index].comment),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class PageThreeSupport extends StatefulWidget {
  final Product product;
  const PageThreeSupport({super.key, required this.product});

  @override
  State<PageThreeSupport> createState() => _PageThreeSupportState();
}

class _PageThreeSupportState extends State<PageThreeSupport> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          "Warranty Information: ${widget.product.warrantyInformation}",
          style: TextStyle(color: Colors.grey[500]),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "Shipping Information: ${widget.product.shippingInformation}",
          style: TextStyle(color: Colors.grey[500]),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "Return Policy: ${widget.product.returnPolicy}",
          style: TextStyle(color: Colors.grey[500]),
        ),
      ],
    );
  }
}
