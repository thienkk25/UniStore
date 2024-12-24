import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:readmore/readmore.dart';
import 'package:shop_fashion/custom/button_view.dart';

class InfoProduct extends StatefulWidget {
  const InfoProduct({super.key});

  @override
  State<InfoProduct> createState() => _InfoProductState();
}

class _InfoProductState extends State<InfoProduct> {
  List<String> imageProduct = [
    "https://res.cloudinary.com/dksr7si4o/image/upload/v1733016959/flutter/images/pizza_viy2lv.jpg",
    "https://res.cloudinary.com/dksr7si4o/image/upload/v1733016958/flutter/images/curry_oshkjg.jpg",
    "https://res.cloudinary.com/dksr7si4o/image/upload/v1733016957/flutter/images/pho_bjsnip.jpg",
  ];
  int selectedIndexImage = 0;
  List<String> tabSupport = ["Description", "Reviews", "How to use"];
  int selectedIndexSupport = 0;
  int currentSupportPageProvider = 0;
  List<Widget> pagesSupport = [
    const PageOneSupport(),
    const PageTwoSupport(),
    const PageThreeSupport(),
  ];

  @override
  Widget build(BuildContext context) {
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
                    itemCount: imageProduct.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onDoubleTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageViewerPage(
                                  initialIndex: index,
                                  imageProduct: imageProduct,
                                ),
                              ));
                        },
                        child: Image.network(
                          imageProduct[index],
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
                      right: 0,
                      left: 0,
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(
                              imageProduct.length,
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
                        child: const Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.orange,
                        )),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Curology",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Brightening Facial Foam",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "\$ 32.00",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              textAlign: TextAlign.end,
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
            colors: [
              Colors.white,
              Colors.orangeAccent
            ], // Gradient từ đỏ sang xanh
            begin: Alignment.centerLeft, // Bắt đầu từ bên trái
            end: Alignment.centerRight, // Kết thúc ở bên phải
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
                  onTap: () {},
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
}

// Tạo một màn hình mới để hiển thị ảnh ở chế độ vuốt
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
              child: Image.network(
                widget.imageProduct[index],
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

class PageOneSupport extends StatefulWidget {
  const PageOneSupport({super.key});

  @override
  State<PageOneSupport> createState() => _PageOneSupportState();
}

class _PageOneSupportState extends State<PageOneSupport> {
  List<double> capacity = [150, 250, 350];
  int? selectedIndexCapacity;
  TextEditingController quantityController = TextEditingController();
  @override
  void initState() {
    quantityController.text = "1";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ReadMoreText(
          "The Curology cleanser works into a gentle, lightly foaming lather to simply clean your skin, leaving it balanced, hydrated, soft, and refreshed.",
          style: TextStyle(color: Colors.grey),
          trimMode: TrimMode.Line,
          trimLines: 3,
          colorClickableText: Colors.black,
          trimCollapsedText: 'Show more',
          trimExpandedText: 'Show less',
          moreStyle:
              TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          lessStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: capacity.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndexCapacity = index;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: selectedIndexCapacity == index
                          ? Colors.orange
                          : Colors.grey[200],
                    ),
                    child: Text(
                      "${capacity[index]} ml",
                      style: TextStyle(
                          color: selectedIndexCapacity == index
                              ? Colors.white
                              : Colors.orange),
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
  const PageTwoSupport({super.key});

  @override
  State<PageTwoSupport> createState() => _PageTwoSupportState();
}

class _PageTwoSupportState extends State<PageTwoSupport> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [Text("Review")],
    );
  }
}

class PageThreeSupport extends StatefulWidget {
  const PageThreeSupport({super.key});

  @override
  State<PageThreeSupport> createState() => _PageThreeSupportState();
}

class _PageThreeSupportState extends State<PageThreeSupport> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [Text("How to use")],
    );
  }
}
