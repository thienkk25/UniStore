import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Slidable(
                key: const Key("1"),
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
                          checked = !checked;
                        });
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: checked
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  // A pane can dismiss the Slidable.
                  dismissible: DismissiblePane(onDismissed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Delete success")));
                  }),
                  children: [
                    SlidableAction(
                      onPressed: (context) {},
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
                          child: Image.asset(
                            "assets/screens/avatar_default.png",
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
                              const Text("title",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              const Text("category",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "\$ price",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                              setState(() {});
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
                                          // controller: quantityController,
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
                                              setState(() {});
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
            ],
          ),
        ),
      ),
    );
  }
}
