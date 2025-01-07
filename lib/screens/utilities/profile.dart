import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_fashion/controllers/user_controller.dart';
import 'package:shop_fashion/main.dart';
import 'package:shop_fashion/screens/welcome.dart';
import 'package:shop_fashion/services/user_firebase.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String notification = "Allow";
  String theme = "Light";
  String language = "En";
  @override
  Widget build(BuildContext context) {
    final double availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final double availableWidth = MediaQuery.of(context).size.width;
    User? dataInforUser = UserFirebase().getInforUserAuth();

    return Scaffold(
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: availableHeight / 5,
                child: Container(
                  color: Colors.orangeAccent,
                ),
              ),
              Positioned(
                  right: 0,
                  left: 0,
                  bottom: -(availableHeight / 5) / 2,
                  child: CircleAvatar(
                    radius: 70,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        dataInforUser!.photoURL ??
                            "assets/screens/avatar_default.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
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
            ],
          ),
          const SizedBox(
            height: 70,
          ),
          Text(
            dataInforUser.displayName ?? "Your Name",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(dataInforUser.email ?? "yourname@gmail.com"),
          const SizedBox(
            height: 10,
          ),
          Card(
            child: InkWell(
              onTap: () {},
              child: const ListTile(
                leading: Icon(Icons.manage_accounts),
                trailing: Icon(Icons.chevron_right),
                title: Text("My Profile"),
              ),
            ),
          ),
          Card(
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (BuildContext context,
                          StateSetter setShowModalBottomSheet) {
                        return Container(
                          margin: const EdgeInsets.all(20),
                          height: availableHeight / 3,
                          width: availableWidth / 1.5,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Settings",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  InkWell(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: const Icon(Icons.close))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Theme"),
                                  Row(
                                    children: [
                                      PopupMenuButton(
                                        onSelected: (value) {
                                          setShowModalBottomSheet(() {
                                            theme = value;
                                          });
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                              value: "Light",
                                              child: Text("Light")),
                                          const PopupMenuItem(
                                              value: "Dark",
                                              child: Text("Dark")),
                                        ],
                                        child: Row(
                                          children: [
                                            Text(theme),
                                            const Icon(
                                                Icons.keyboard_arrow_down),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Language"),
                                  Row(
                                    children: [
                                      PopupMenuButton(
                                        onSelected: (value) {
                                          setShowModalBottomSheet(() {
                                            language = value;
                                          });
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                              value: "En", child: Text("En")),
                                          const PopupMenuItem(
                                              value: "Vn", child: Text("Vn")),
                                        ],
                                        child: Row(
                                          children: [
                                            Text(language),
                                            const Icon(
                                                Icons.keyboard_arrow_down),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: const ListTile(
                leading: Icon(Icons.settings),
                trailing: Icon(Icons.chevron_right),
                title: Text("Settings"),
              ),
            ),
          ),
          Card(
            child: InkWell(
              onTap: () async {
                final selectedValue = await showMenu<String>(
                  context: context,
                  items: [
                    const PopupMenuItem<String>(
                      value: 'Allow',
                      child: Text("Allow"),
                    ),
                    const PopupMenuItem<String>(
                      value: "Mute",
                      child: Text("Mute"),
                    ),
                  ],
                  position: RelativeRect.fromLTRB(
                      availableWidth, availableHeight / 2, 0, 0),
                );

                if (selectedValue != null) {
                  setState(() {
                    notification = selectedValue;
                  });
                }
              },
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text("Notification"),
                trailing: Text(notification),
              ),
            ),
          ),
          Card(
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text("You sure logout?"),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Cancel")),
                            TextButton(
                                onPressed: () => logOut(),
                                child: const Text("Confirm")),
                          ],
                        ));
              },
              child: const ListTile(
                leading: Icon(Icons.logout),
                title: Text("Log Out"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void logOut() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      ),
    );
    final UserController userController = UserController();
    String result = await userController.logOutController();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    Navigator.of(context).pop();
    if (result == "Exit success") {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const MyApp(),
        ),
        (route) => false,
      );
    }
  }
}
