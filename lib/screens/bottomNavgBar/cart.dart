import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shop_fashion/controllers/product_controller.dart';
import 'package:shop_fashion/custom/button_view.dart';
import 'package:shop_fashion/models/product_model.dart';

import '../../services/riverpod_product.dart';

class Cart extends ConsumerStatefulWidget {
  const Cart({super.key});

  @override
  ConsumerState<Cart> createState() => _CartState();
}

class _CartState extends ConsumerState<Cart> {
  @override
  Widget build(BuildContext context) {
    final productController = ref.watch(productControllerProvider);
    final dataProduct = productController.dataAllProductController(ref);

    return StreamBuilder(
      stream: fetchCartProduct(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: Colors.orange,
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<Product> dataTemporary = dataProduct
              .where((element) =>
                  snapshot.data!.any((product) => product['id'] == element.id))
              .toList();
          Future.microtask(() {
            final currentData = ref.watch(dataYourCartsProvider);

            if (!listEquals(dataTemporary, currentData)) {
              ref.read(dataYourCartsProvider.notifier).state = dataTemporary;

              if (ref.watch(checkBoxYourCartsProvider).isEmpty ||
                  ref.watch(checkBoxYourCartsProvider).length !=
                      dataTemporary.length) {
                ref.read(checkBoxYourCartsProvider.notifier).state =
                    List.generate(dataTemporary.length, (index) => true);
                ref
                        .read(textEditingControllerYourCartsProvider.notifier)
                        .state =
                    List.generate(dataTemporary.length,
                        (index) => TextEditingController(text: '1'));
              }
            }
          });
          double subTotal =
              ref.watch(dataYourCartsProvider).fold(0, (sum, item) {
            double index = ref.watch(checkBoxYourCartsProvider)[
                    ref.watch(dataYourCartsProvider).indexOf(item)]
                ? item.price
                : 0;
            return sum + index;
          });
          double discount = 0;
          double total = subTotal + discount;

          return Scaffold(
            appBar: AppBar(
              title: const Text("Your Cart"),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: ref.watch(dataYourCartsProvider).length,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Slidable(
                      key: Key(ref
                          .watch(dataYourCartsProvider)[index]
                          .id
                          .toString()),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        // A pane can dismiss the Slidable.
                        dismissible: DismissiblePane(onDismissed: () async {
                          setState(() {
                            deleteCart(
                                ref.watch(dataYourCartsProvider)[index].id);
                          });
                        }),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              if (ref.watch(dataYourCartsProvider).isNotEmpty) {
                                deleteCart(
                                    ref.watch(dataYourCartsProvider)[index].id);
                              }
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
                                value:
                                    ref.watch(checkBoxYourCartsProvider)[index],
                                onChanged: (value) {
                                  List<bool> updatedCheckBoxState = List.from(
                                      ref.watch(checkBoxYourCartsProvider));
                                  updatedCheckBoxState[index] =
                                      !updatedCheckBoxState[index];
                                  ref
                                      .read(checkBoxYourCartsProvider.notifier)
                                      .state = updatedCheckBoxState;
                                },
                              ),
                              ClipRRect(
                                borderRadius:
                                    BorderRadiusDirectional.circular(10),
                                child: Image.network(
                                  ref
                                      .watch(dataYourCartsProvider)[index]
                                      .thumbnail,
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                        ref
                                            .watch(dataYourCartsProvider)[index]
                                            .title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    Text(
                                        ref
                                            .watch(dataYourCartsProvider)[index]
                                            .category,
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
                                          "\$ ${ref.watch(dataYourCartsProvider)[index].price}",
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
                                                    if (ref
                                                        .watch(textEditingControllerYourCartsProvider)[
                                                            index]
                                                        .text
                                                        .isEmpty) {
                                                      ref
                                                          .watch(textEditingControllerYourCartsProvider)[
                                                              index]
                                                          .text = "1";
                                                    } else if (int.parse(ref
                                                            .watch(textEditingControllerYourCartsProvider)[
                                                                index]
                                                            .text) ==
                                                        999) {
                                                    } else {
                                                      ref
                                                          .watch(textEditingControllerYourCartsProvider)[
                                                              index]
                                                          .text = (int.parse(ref
                                                                  .watch(textEditingControllerYourCartsProvider)[
                                                                      index]
                                                                  .text) +
                                                              1)
                                                          .toString();
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
                                                      ))),
                                            ),
                                            SizedBox(
                                              height: 20,
                                              width: 40,
                                              child: TextField(
                                                controller: ref.watch(
                                                        textEditingControllerYourCartsProvider)[
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
                                                              BorderRadius.zero,
                                                          borderSide: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: 1)),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                    borderSide:
                                                        BorderSide(width: 1),
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
                                                    if (ref
                                                        .watch(textEditingControllerYourCartsProvider)[
                                                            index]
                                                        .text
                                                        .isEmpty) {
                                                      ref
                                                          .watch(textEditingControllerYourCartsProvider)[
                                                              index]
                                                          .text = "1";
                                                    } else if (int.parse(ref
                                                                .watch(textEditingControllerYourCartsProvider)[
                                                                    index]
                                                                .text) ==
                                                            0 ||
                                                        int.parse(ref
                                                                .watch(textEditingControllerYourCartsProvider)[
                                                                    index]
                                                                .text) ==
                                                            1) {
                                                    } else {
                                                      ref
                                                          .watch(textEditingControllerYourCartsProvider)[
                                                              index]
                                                          .text = (int.parse(ref
                                                                  .watch(textEditingControllerYourCartsProvider)[
                                                                      index]
                                                                  .text) -
                                                              1)
                                                          .toString();
                                                    }
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1),
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
                              Text(
                                "\$ $subTotal",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
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
                                "\$ $discount",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
                                    color: const Color.fromARGB(
                                        255, 200, 200, 200))),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total:",
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              Text(
                                "\$ $total",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                      Center(
                        child: SizedBox(
                          height: 40,
                          width: double.infinity,
                          child:
                              ButtonView(text: "Checkout", voidCallback: () {}),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Text('No data found');
        }
      },
    );
  }

  Future<void> deleteCart(int id) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      ),
    );
    final result = await ref
        .watch(productControllerProvider)
        .deleteCartProductController(id);
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
  }
}
