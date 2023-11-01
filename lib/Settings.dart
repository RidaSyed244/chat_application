import 'package:flutter/material.dart';

class SettingTiles {
  final List<Tiles> details;
  final String title;

  SettingTiles({required this.title, required this.details});
}

class Tiles {
  final String description;
  final icon;

  Tiles({
    required this.description,
    required this.icon,
  });
}

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<SettingTiles> tiles = [
    SettingTiles(title: "Account", details: [
      Tiles(
          description: "Privacy, security, change number",
          icon: Icon(
            Icons.key,
            color: Colors.grey,
            size: 30,
          ))
    ]),
    SettingTiles(title: "Chat", details: [
      Tiles(
          description: "Chat history,theme,wallpapers",
          icon: Icon(
            Icons.chat,
            color: Colors.grey,
            size: 30,
          ))
    ]),
    SettingTiles(title: "Notifications", details: [
      Tiles(
          description: "Messages, group and others",
          icon: Icon(
            Icons.notifications,
            color: Colors.grey,
            size: 30,
          ))
    ]),
    SettingTiles(title: "Help", details: [
      Tiles(
          description: "Help center,contact us, privacy policy",
          icon: Icon(
            Icons.help,
            color: Colors.grey,
            size: 30,
          ))
    ]),
    SettingTiles(title: "Storage and data", details: [
      Tiles(
          description: "Network usage, stogare usage",
          icon: Icon(
            Icons.storage,
            color: Colors.grey,
            size: 30,
          ))
    ]),
    SettingTiles(title: "Invite a afriend", details: [
      Tiles(
          description: "Invite your friend",
          icon: Icon(
            Icons.insert_invitation,
            color: Colors.grey,
            size: 30,
          ))
    ])
  ];
  // List settingTiles = [
  //   {
  //     "Name": "Account",
  //     "Description": "Privacy, security, change number",
  //     "icon": Icon(Icons.key),
  //   },
  //   {
  //     "Name": "Chat",
  //     "Description": "Chat history,theme,wallpapers",
  //     "icon": Icon(Icons.chat),
  //   },
  //   {
  //     "Name": "Notifications",
  //     "Description": "Messages, group and others",
  //     "icon": Icon(Icons.notifications),
  //   },
  //   {
  //     "Name": "Help",
  //     "Description": "Help center,contact us, privacy policy",
  //     "icon": Icon(Icons.help),
  //   },
  //   {
  //     "Name": "Storage and data",
  //     "Description": "Network usage, stogare usage",
  //     "icon": Icon(Icons.storage),
  //   },
  //   {
  //     "Name": "Invite a friend",
  //     "Description": "Invite your friend",
  //     "icon": Icon(Icons.insert_invitation_outlined),
  //   },
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Text(
            "Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
          child: IconButton(
            color: Colors.white,
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back,
              size: 30,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(170, 25, 170, 10),
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                ListTile(
                  leading: ClipOval(
                    child: NetworkImage('url') == true
                        ? Image.network(
                            '',
                            width: 65,
                            height: 65,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/images/defaultDp.jpg",
                            width: 65,
                            height: 65,
                            fit: BoxFit.cover,
                          ),
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.qr_code,
                      size: 25,
                    ),
                    color: Colors.green,
                  ),
                  title: Text(
                    "Rida Syed",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "This is description.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 228, 221, 221),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: tiles.length,
                    itemBuilder: (context, index) {
                      final SettingTiles det = tiles[index];
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListTile(
                          title: Text(
                            "${det.title}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color.fromARGB(255, 249, 249, 249),
                            child: ListView.builder(
                                itemCount: det.details.length,
                                itemBuilder: (context, doublesubIndex) {
                                  final Tiles icons =
                                      det.details[doublesubIndex];

                                  return CircleAvatar(
                                    radius: 30,
                                    backgroundColor:
                                        Color.fromARGB(255, 249, 249, 249),
                                    child: icons.icon,
                                  );
                                }),
                          ),
                          subtitle: Container(
                            height: 20,
                            child: ListView.builder(
                                itemCount: det.details.length,
                                itemBuilder: (context, subindex) {
                                  final Tiles desc = det.details[subindex];

                                  return Text(
                                    "${desc.description}",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  );
                                }),
                          ),
                        ),
                      );
                    })
              ],
            )),
      ),
    );
  }
}
