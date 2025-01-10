import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:uni_store/controllers/product_controller.dart';
import 'package:uni_store/custom/button_view.dart';
import 'package:uni_store/models/product_model.dart';
import 'package:uni_store/services/notify_service.dart';
import 'package:uni_store/services/riverpod_home_view.dart';
import 'package:uni_store/services/stripe_service.dart';

import '../../services/riverpod_product.dart';

class Cart extends ConsumerStatefulWidget {
  const Cart({super.key});

  @override
  ConsumerState<Cart> createState() => _CartState();
}

class _CartState extends ConsumerState<Cart> {
  late List<Product> dataYourCarts;
  late List<bool> checkBoxYourCarts;
  late List<TextEditingController> textEditingControllerYourCarts;
  double subTotalProduct = 0;
  double discountProduct = 0;
  double totalProduct = 0;
  @override
  void initState() {
    Future.microtask(() {
      ref.read(productControllerProvider).fetchCartProductController(ref);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dataYourCarts = ref.watch(cartProductNotifierProvider);
    checkBoxYourCarts = ref.watch(checkBoxYourCartsProvider);
    textEditingControllerYourCarts =
        ref.watch(textEditingControllerYourCartsProvider);
    if (dataYourCarts.isNotEmpty &&
        checkBoxYourCarts.isNotEmpty &&
        textEditingControllerYourCarts.isNotEmpty &&
        dataYourCarts.length == checkBoxYourCarts.length &&
        checkBoxYourCarts.length == textEditingControllerYourCarts.length) {
      sumTotalProduct();
      return Scaffold(
        appBar: AppBar(
          title: const Text("Your Cart"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 330) {
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dataYourCarts.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Slidable(
                            key: Key(dataYourCarts[index].id.toString()),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              // A pane can dismiss the Slidable.
                              dismissible:
                                  DismissiblePane(onDismissed: () async {
                                deleteCart(dataYourCarts[index].id, index);
                                setState(() {
                                  sumTotalProduct();
                                });
                              }),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    deleteCart(dataYourCarts[index].id, index);
                                    setState(() {
                                      sumTotalProduct();
                                    });
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
                                    Checkbox(
                                      value: checkBoxYourCarts[index],
                                      onChanged: (value) {
                                        ref
                                            .read(checkBoxYourCartsProvider
                                                .notifier)
                                            .toggleStateCheckBoxYourCarts(
                                                index);
                                      },
                                    ),
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadiusDirectional.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            dataYourCarts[index].thumbnail,
                                        progressIndicatorBuilder:
                                            (context, url, progress) =>
                                                Lottie.asset(
                                                    "/lotties/loading.json",
                                                    height: 100,
                                                    width: 100,
                                                    fit: BoxFit.contain),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                        fit: BoxFit.cover,
                                        height: 50,
                                        width: 50,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                          setState(() {
                                                            sumTotalProduct();
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              width: 1),
                                                          color:
                                                              Colors.grey[300],
                                                        ),
                                                        child: const Icon(
                                                          Icons.add,
                                                          size: 20,
                                                          color: Colors.orange,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                    width: 40,
                                                    child: TextField(
                                                      onChanged: (value) {
                                                        if (value.isNotEmpty) {
                                                          setState(() {
                                                            sumTotalProduct();
                                                          });
                                                        }
                                                      },
                                                      controller:
                                                          textEditingControllerYourCarts[
                                                              index],
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                      cursorHeight: 14,
                                                      cursorColor:
                                                          Colors.orange,
                                                      decoration:
                                                          const InputDecoration(
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .zero,
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 1)),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.zero,
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1),
                                                        ),
                                                        contentPadding:
                                                            EdgeInsets.symmetric(
                                                                vertical: -2,
                                                                horizontal:
                                                                    0), // Căn giữa nội dung
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        LengthLimitingTextInputFormatter(
                                                            3)
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
                                                              int.parse(textEditingControllerYourCarts[
                                                                          index]
                                                                      .text) ==
                                                                  1) {
                                                          } else {
                                                            textEditingControllerYourCarts[
                                                                    index]
                                                                .text = (int.parse(ref
                                                                        .watch(textEditingControllerYourCartsProvider)[
                                                                            index]
                                                                        .text) -
                                                                    1)
                                                                .toString();
                                                            setState(() {
                                                              sumTotalProduct();
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                      width: 1),
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
                                                            child: const Icon(
                                                              Icons.remove,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
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
                        );
                      });
                }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: dataYourCarts.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Slidable(
                          key: Key(dataYourCarts[index].id.toString()),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            // A pane can dismiss the Slidable.
                            dismissible: DismissiblePane(onDismissed: () async {
                              deleteCart(dataYourCarts[index].id, index);
                              setState(() {
                                sumTotalProduct();
                              });
                            }),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  deleteCart(dataYourCarts[index].id, index);
                                  setState(() {
                                    sumTotalProduct();
                                  });
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
                                  Checkbox(
                                    value: checkBoxYourCarts[index],
                                    onChanged: (value) {
                                      ref
                                          .read(checkBoxYourCartsProvider
                                              .notifier)
                                          .toggleStateCheckBoxYourCarts(index);
                                    },
                                  ),
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: dataYourCarts[index].thumbnail,
                                      progressIndicatorBuilder:
                                          (context, url, progress) =>
                                              Lottie.asset(
                                                  "assets/lotties/loading.json",
                                                  height: 100,
                                                  width: 100,
                                                  fit: BoxFit.contain),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
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
                                                        setState(() {
                                                          sumTotalProduct();
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1),
                                                        color: Colors.grey[300],
                                                      ),
                                                      child: const Icon(
                                                        Icons.add,
                                                        size: 20,
                                                        color: Colors.orange,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                  width: 40,
                                                  child: TextField(
                                                    onChanged: (value) {
                                                      if (value.isNotEmpty) {
                                                        setState(() {
                                                          sumTotalProduct();
                                                        });
                                                      }
                                                    },
                                                    controller:
                                                        textEditingControllerYourCarts[
                                                            index],
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                    cursorHeight: 14,
                                                    cursorColor: Colors.orange,
                                                    decoration:
                                                        const InputDecoration(
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .zero,
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width:
                                                                          1)),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.zero,
                                                        borderSide: BorderSide(
                                                            width: 1),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: -2,
                                                              horizontal:
                                                                  0), // Căn giữa nội dung
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      LengthLimitingTextInputFormatter(
                                                          3)
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
                                                            int.parse(textEditingControllerYourCarts[
                                                                        index]
                                                                    .text) ==
                                                                1) {
                                                        } else {
                                                          textEditingControllerYourCarts[
                                                                  index]
                                                              .text = (int.parse(ref
                                                                      .watch(textEditingControllerYourCartsProvider)[
                                                                          index]
                                                                      .text) -
                                                                  1)
                                                              .toString();
                                                          setState(() {
                                                            sumTotalProduct();
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                width: 1),
                                                            color: Colors
                                                                .grey[300],
                                                          ),
                                                          child: const Icon(
                                                            Icons.remove,
                                                            size: 20,
                                                            color:
                                                                Colors.orange,
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
                      );
                    });
              },
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
                          Text(
                            "\$ ${subTotalProduct.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Discount:",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(
                            "\$ ${discountProduct.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        height: 2,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color:
                                    const Color.fromARGB(255, 200, 200, 200))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total:",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(
                            "\$ ${totalProduct.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ButtonView(
                          text: "Checkout",
                          voidCallback: () {
                            checkOutCart();
                            // StripeService().makePayment(totalProduct);
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return const Center(
      child: Text("No product"),
    );
  }

  Future<void> deleteCart(int id, int index) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
        child: Lottie.asset("assets/lotties/loading.json",
            height: 100, width: 100, fit: BoxFit.contain),
      ),
    );
    Product dataTemporary = dataYourCarts[index];
    ref
        .read(cartProductNotifierProvider.notifier)
        .removeStateCartProduct(dataTemporary);
    ref
        .read(textEditingControllerYourCartsProvider.notifier)
        .removeStateTextEditingControllerYourCarts(index);
    ref
        .read(checkBoxYourCartsProvider.notifier)
        .removeStatecheckBoxYourCarts(index);
    ref.read(badgeCartProvider.notifier).state--;
    dataYourCarts.removeAt(index);
    String result = await ref
        .watch(productControllerProvider)
        .deleteCartProductController(id);

    ref
        .read(notifyNotifierProvider.notifier)
        .addSetState("$result ${dataTemporary.title}");
    ref.read(badgeNotifyProvider.notifier).state++;
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
  }

  void sumTotalProduct() {
    subTotalProduct = dataYourCarts.fold(0, (sum, item) {
      int quanlity = 0;
      if (textEditingControllerYourCarts[dataYourCarts.indexOf(item)]
          .text
          .isNotEmpty) {
        quanlity = int.parse(
            textEditingControllerYourCarts[dataYourCarts.indexOf(item)].text);
      }
      double index = checkBoxYourCarts[dataYourCarts.indexOf(item)]
          ? quanlity * item.price
          : 0;
      return sum + index;
    });
    discountProduct = 0;
    totalProduct = subTotalProduct + discountProduct;
  }

  void checkOutCart() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
        child: Lottie.asset("assets/lotties/loading.json",
            height: 100, width: 100, fit: BoxFit.contain),
      ),
    );

    final result = await StripeService().makePayment(totalProduct);

    if (!mounted) return;
    Navigator.of(context).pop();
    if (result == "Success payment") {
      showDialog(
        barrierColor: Colors.amber[50],
        barrierDismissible: false,
        context: context,
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset("assets/lotties/success.json",
                  repeat: false, height: 100, width: 100, fit: BoxFit.contain),
            ),
            Text(
              result,
              style: const TextStyle(color: Colors.orange),
            ),
          ],
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.of(context).pop();
    } else {
      showDialog(
        barrierColor: Colors.amber[50],
        barrierDismissible: false,
        context: context,
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset("assets/lotties/error.json",
                  repeat: false, height: 100, width: 100, fit: BoxFit.contain),
            ),
            Text(
              result,
              style: const TextStyle(color: Colors.orange),
            ),
          ],
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }
}
