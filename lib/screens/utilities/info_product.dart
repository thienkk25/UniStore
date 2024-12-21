import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
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
                    // controller: PageController(),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 10), // Duy trì khoảng cách nếu cần
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
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Color.fromARGB(255, 255, 193, 99)
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
