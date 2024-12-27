import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String notification = "Allow";

  @override
  Widget build(BuildContext context) {
    final double availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final double availableWidth = MediaQuery.of(context).size.width;
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
                        "assets/screens/avatar_default.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ))
            ],
          ),
          const SizedBox(
            height: 70,
          ),
          const Text(
            "Your Name",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text("yourname@gmail.com"),
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
                    return Container(
                      margin: const EdgeInsets.all(20),
                      height: availableHeight / 3,
                      width: availableWidth / 1.5,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Settings",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Theme"),
                              Row(
                                children: [
                                  PopupMenuButton(
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(child: Text("Light")),
                                      const PopupMenuItem(child: Text("Dark")),
                                    ],
                                    child: const Row(
                                      children: [
                                        Text("Light"),
                                        Icon(Icons.keyboard_arrow_down),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Language"),
                              InkWell(
                                onTap: () {},
                                child: const Row(
                                  children: [
                                    Text("En"),
                                    Icon(Icons.keyboard_arrow_down)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
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
              onTap: () {},
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
}
