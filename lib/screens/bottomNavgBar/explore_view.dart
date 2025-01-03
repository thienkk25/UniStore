import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shop_fashion/controllers/user_controller.dart';
import 'package:shop_fashion/services/explore_service.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  TextEditingController textEditingController = TextEditingController();
  String emailUser =
      UserController().getInforUserAuthController()!.email.toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Explore"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(emailUser),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            "assets/screens/avatar_default.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                          child: TextField(
                        controller: textEditingController,
                        decoration: const InputDecoration(
                            hintText: "Enter text...",
                            border: OutlineInputBorder()),
                      )),
                      const SizedBox(
                        width: 5,
                      ),
                      TextButton.icon(
                        label: const Icon(Icons.send),
                        onPressed: () {
                          if (textEditingController.text.isNotEmpty) {
                            sendExplore(textEditingController.text);
                          }
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                  stream: ExploreService().realTimeChat(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error"),
                      );
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      List dataChat = snapshot.data!.reversed.toList();
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: dataChat.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          dataChat[index]['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      dataChat[index]['createAt'],
                                      style: TextStyle(
                                          fontSize: 8, color: Colors.grey[500]),
                                    )
                                  ],
                                ),
                                Text(
                                  dataChat[index]['email'],
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[500]),
                                ),
                                Text(dataChat[index]['message']),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Center(child: Text("No data available"));
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }

  void sendExplore(String message) {
    ExploreService().sendRealTimeChat(message);
  }
}
