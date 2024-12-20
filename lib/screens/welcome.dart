import 'package:flutter/material.dart';
import 'package:shop_fashion/custom/button_view.dart';
import 'package:shop_fashion/screens/signin.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final List<String> imagePath = [
    "assets/screens/welcome1.png",
    "assets/screens/welcome2.png",
    "assets/screens/welcome3.png"
  ];

  late List<Widget> _page;
  final PageController _pageController = PageController();
  int _activepage = 0;
  @override
  void initState() {
    super.initState();
    _page = List.generate(
        imagePath.length,
        (index) => Image.asset(
              imagePath[index],
              fit: BoxFit.fill,
            ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Scaffold(
        body: Column(
      children: [
        SizedBox(
            height: availableHeight / 3.8,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "SHOP",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold),
                ),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                        color: Colors.black, fontSize: 16), // Kiểu chữ chung
                    children: [
                      TextSpan(text: 'Welcome to '),
                      TextSpan(
                        text: 'Shop',
                        style: TextStyle(
                            fontWeight: FontWeight.bold), // In đậm chữ "Shop"
                      ),
                      TextSpan(text: ", Let's shop!"),
                    ],
                  ),
                )
              ],
            )),
        SizedBox(
            height: (availableHeight - (availableHeight / 3.8)) / 1.3,
            width: double.infinity,
            child: Stack(children: [
              PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      _activepage = value;
                    });
                  },
                  itemCount: imagePath.length,
                  itemBuilder: (content, index) {
                    return _page[index];
                  }),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List<Widget>.generate(_page.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: CircleAvatar(
                            radius: 4,
                            backgroundColor: _activepage == index
                                ? Colors.orange
                                : Colors.grey,
                          ),
                        );
                      })
                    ],
                  ),
                ),
              )
            ])),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
              height: 40,
              width: double.infinity,
              child: ButtonView(
                text: "Continue",
                voidCallback: () {
                  if (_activepage != _page.length - 1) {
                    setState(() {
                      _activepage++;
                    });
                    _pageController.animateToPage(
                      _activepage,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ); // Chuyển trang
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const Signin()));
                  }
                },
              )),
        )
      ],
    ));
  }
}
