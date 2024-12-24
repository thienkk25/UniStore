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
          const Card(
            child: ListTile(
              leading: Icon(Icons.manage_accounts),
              trailing: Icon(Icons.chevron_right),
              title: Text("My Profile"),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.settings),
              trailing: Icon(Icons.chevron_right),
              title: Text("Settings"),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  setState(() {
                    notification = value;
                  });
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'Allow',
                    child: Text("Allow"),
                  ),
                  const PopupMenuItem(
                    value: "Mute",
                    child: Text("Mute"),
                  ),
                ],
                child: Container(
                  width: 30,
                  decoration: const BoxDecoration(),
                  child: Text(notification),
                ),
              ),
              title: const Text("Notification"),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text("Log Out"),
            ),
          ),
        ],
      ),
    );
  }
}
