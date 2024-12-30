import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shop_fashion/custom/button_view.dart';
import 'package:shop_fashion/models/product_model.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<Product> dataYourCarts = YourCarts().dataYourCarts;
  late List<bool> checkBoxYourCarts;
  late List<TextEditingController> textEditingControllerYourCarts;
  @override
  void initState() {
    checkBoxYourCarts = List.generate(dataYourCarts.length, (index) => true);
    textEditingControllerYourCarts = List.generate(dataYourCarts.length,
        (index) => TextEditingController(text: 1.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: dataYourCarts.length,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Slidable(
                key: Key(dataYourCarts[index].id.toString()),
                // The start action pane is the one at the left or the top side.
                startActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const ScrollMotion(),

                  // All actions are defined in the children parameter.
                  children: [
                    // A SlidableAction can have an icon and/or a label.
                    SlidableAction(
                      onPressed: (context) {
                        setState(() {
                          checkBoxYourCarts[index] = !checkBoxYourCarts[index];
                        });
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: checkBoxYourCarts[index]
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  // A pane can dismiss the Slidable.
                  dismissible: DismissiblePane(onDismissed: () {
                    dataYourCarts.removeAt(index);
                    checkBoxYourCarts.removeAt(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Delete success")));
                  }),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        setState(() {
                          if (dataYourCarts.isNotEmpty) {
                            dataYourCarts.removeAt(index);
                            checkBoxYourCarts.removeAt(index);
                          }
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Delete success")));
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Card(
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadiusDirectional.circular(10),
                          child: Image.network(
                            dataYourCarts[index].thumbnail,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(dataYourCarts[index].title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Text(dataYourCarts[index].category,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\$ ${dataYourCarts[index].price}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (textEditingControllerYourCarts[
                                                        index]
                                                    .text
                                                    .isEmpty) {
                                                  textEditingControllerYourCarts[
                                                          index]
                                                      .text = "1";
                                                } else if (int.parse(
                                                        textEditingControllerYourCarts[
                                                                index]
                                                            .text) ==
                                                    999) {
                                                } else {
                                                  textEditingControllerYourCarts[
                                                          index]
                                                      .text = (int.parse(
                                                              textEditingControllerYourCarts[
                                                                      index]
                                                                  .text) +
                                                          1)
                                                      .toString();
                                                }
                                              });
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
                                          controller:
                                              textEditingControllerYourCarts[
                                                  index],
                                          style: const TextStyle(fontSize: 14),
                                          cursorHeight: 14,
                                          cursorColor: Colors.orange,
                                          decoration: const InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.zero,
                                                borderSide: BorderSide(
                                                    color: Colors.black,
                                                    width: 1)),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.zero,
                                              borderSide: BorderSide(width: 1),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: -2,
                                                    horizontal:
                                                        0), // Căn giữa nội dung
                                          ),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(3)
                                          ],
                                          maxLines: 1,
                                          textAlign: TextAlign
                                              .center, // Căn giữa nội dung văn bản
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (textEditingControllerYourCarts[
                                                        index]
                                                    .text
                                                    .isEmpty) {
                                                  textEditingControllerYourCarts[
                                                          index]
                                                      .text = "1";
                                                } else if (int.parse(
                                                            textEditingControllerYourCarts[
                                                                    index]
                                                                .text) ==
                                                        0 ||
                                                    int.parse(
                                                            textEditingControllerYourCarts[
                                                                    index]
                                                                .text) ==
                                                        1) {
                                                } else {
                                                  textEditingControllerYourCarts[
                                                          index]
                                                      .text = (int.parse(
                                                              textEditingControllerYourCarts[
                                                                      index]
                                                                  .text) -
                                                          1)
                                                      .toString();
                                                }
                                              });
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
                                      const SizedBox(
                                        width: 10,
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
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
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sub Total:",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const Text(
                          "\$ 128.00",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sub Total:",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const Text(
                          "\$ 5.00",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      height: 2,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: const Color.fromARGB(255, 200, 200, 200))),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total:",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const Text(
                          "\$ 123.00",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
                Center(
                  child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ButtonView(text: "Checkout", voidCallback: () {}),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
