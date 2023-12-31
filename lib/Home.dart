// ignore_for_file: override_on_non_overriding_member

import 'package:chat_application/FetchData.dart';
import 'package:chat_application/messages.dart';
import 'package:chat_application/newStoryByCU.dart';
import 'package:chat_application/storyView.dart';
import 'package:chat_application/text.dart';
import 'package:chat_application/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

Future<void> ChangeNotificationForChat(receiverUid) async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
      .instance
      .collection("Messages")
      .where("SenderUid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where("ReceiverUid", isEqualTo: receiverUid)
      .get();

  for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
      in querySnapshot.docs) {
    String currentNotificationValue = documentSnapshot["Notification"];
    String newNotificationValue =
        currentNotificationValue == "True" ? "False" : "True";

    await FirebaseFirestore.instance
        .collection("Messages")
        .doc(documentSnapshot.id)
        .update({"Notification": newNotificationValue});
  }
}

DleteChat(receiverUid) async {
  await FirebaseFirestore.instance
      .collection("Messages")
      .where("SenderUid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where("ReceiverUid", isEqualTo: receiverUid)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      FirebaseFirestore.instance
          .collection("Messages")
          .doc(element.id)
          .delete();
    });
  });
}

void doNothing(BuildContext context) {}

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with WidgetsBindingObserver {
  Future<void> getCurrentUserData() async {
    final getCurrentUsers = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    uid = getCurrentUsers["uid"];
    profilePic = getCurrentUsers["profilePic"];
    setState(() {
      currentuid = getCurrentUsers["uid"];
      currentprofilePic = getCurrentUsers["profilePic"];
      currentUsername = getCurrentUsers["name"];
    });
  }

  String? docid;
  Future<void> getUserData() async {
    final userData = await FirebaseFirestore.instance.collection("Users").get();

    for (var userDoc in userData.docs) {
      uid = userDoc["uid"];
      name = userDoc["name"];
      profilePic = userDoc["profilePic"];

      final userStories = await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .collection('Stories')
          .get();

      final stories = userStories.docs.map((storyDoc) {
        return Story(
          storyType: storyDoc["storyType"],
          content: storyDoc["content"],
        );
      }).toList();

      setState(() {
        users.add(
          AllUsers(
            name: name,
            profilePic: profilePic,
            stories: stories,
            uid: uid,
          ),
        );
        currentUserIndex = users.indexWhere((user) => user.uid == currentuid);
        if (currentUserIndex != -1) {
          final currentUser = users.removeAt(currentUserIndex);
          users.insert(0, currentUser);
        }
        allusers = users;
      });
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getUserData();
    getCurrentUserData();
    WidgetsBinding.instance.addObserver(
      this,
    );
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore.collection('Users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    final allmessageUsers = ref.watch(alluserMessageStream);
    final getLstMessage = ref.watch(getLastMessagesStream);
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "Home",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: IconButton(
            color: Colors.white,
            onPressed: () {},
            icon: Icon(
              Icons.search,
              size: 30,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
            child: CircleAvatar(
              radius: 35,
              backgroundImage: currentprofilePic != null
                  ? NetworkImage(currentprofilePic!)
                  : NetworkImage("url"),
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: allusers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (allusers[index].uid == currentuid &&
                                      allusers[currentUserIndex]
                                              .stories
                                              .length ==
                                          0) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NewStory()));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MoreStories(
                                                  userId: allusers[index].uid,
                                                  users: allusers,
                                                )));
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 37,
                                  backgroundImage:
                                      NetworkImage(allusers[index].profilePic),
                                ),
                              ),
                              if (index == 0)
                                Positioned(
                                  right: 1,
                                  left: 56,
                                  top: 46,
                                  child: GestureDetector(
                                    onTap: () {
                                      showStoryPicker();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20,
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.black,
                                          size: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          SizedBox(height: 8), // Adjust the spacing as needed
                          Text(
                            allusers[index].uid == currentuid
                                ? 'My Status'
                                : '${allusers[index].name}',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ));
                },
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: allmessageUsers.when(
                  data: (data) {
                    return ListView.builder(
                      itemCount: data.docs.length,
                      itemBuilder: (context, index) {
                        final singleUser = data.docs[index];
                        Users users = Users.fromMap(singleUser.data());
                        return Slidable(
                          key: ValueKey(0),
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("Messages")
                                      .where("SenderUid",
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser?.uid)
                                      .where("ReceiverUid",
                                          isEqualTo: users.uid)
                                      .where("Notification", isEqualTo: "True")
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return SlidableAction(
                                          flex: 1,
                                          onPressed: (BuildContext context) =>
                                              ChangeNotificationForChat(
                                                  users.uid),
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                          icon: Icons.notifications);
                                    } else {
                                      return SlidableAction(
                                        flex: 1,
                                        onPressed: (BuildContext context) =>
                                            ChangeNotificationForChat(
                                                users.uid),
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                        icon: Icons.notifications_off,
                                      );
                                    }
                                  }),
                              SlidableAction(
                                onPressed: (BuildContext context) =>
                                    DleteChat(users.uid),
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 8),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MessageScreen(
                                      name: users.name.toString(),
                                      email: users.email.toString(),
                                      phoneNumber: users.phoneNumber.toString(),
                                      profilePic: users.profilePic.toString(),
                                      uid: users.uid.toString(),
                                    ),
                                  ),
                                );
                              },
                              title: Text(
                                '${users.name}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: getLstMessage.when(
                                data: (messagesData) {
                                  if (messagesData.isNotEmpty &&
                                      index < messagesData.length) {
                                    return Text(
                                      '${messagesData[index].Message}',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  } else {
                                    return Text("Start Conversation...");
                                  }
                                },
                                error: (e, s) {
                                  return Container();
                                },
                                loading: () => Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 28,
                                child: Stack(
                                  children: [
                                    // User's profile picture
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: CircleAvatar(
                                        radius: 28,
                                        backgroundImage: NetworkImage(
                                            users.profilePic.toString()),
                                      ),
                                    ),

                                    // Green dot for online indicator
                                    Positioned(
                                      top: 36,
                                      left: 45,
                                      child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection("Users")
                                              .doc(users.uid)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            final status =
                                                snapshot.data?["status"];
                                            if (snapshot.hasData) {
                                              return Container(
                                                height: 12,
                                                width: 12,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: status == "Online"
                                                      ? Colors.green
                                                      : Colors.grey,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 2,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container(
                                                height: 12,
                                                width: 12,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  getLstMessage.when(
                                    data: (messagesData) {
                                      if (messagesData.isNotEmpty &&
                                          index < messagesData.length) {
                                        final convertTime = DateFormat("h:mm a")
                                            .format(messagesData[index]
                                                .time
                                                .toDate());
                                        return Text(
                                          "${convertTime}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                          ),
                                        );
                                      } else {
                                        return Text("");
                                      }
                                    },
                                    error: (e, s) {
                                      return Container();
                                    },
                                    loading: () => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  // StreamBuilder(
                                  //   stream: FirebaseFirestore.instance
                                  //       .collection("Messages")
                                  //       .where("SenderUid",
                                  //           isNotEqualTo: FirebaseAuth
                                  //               .instance.currentUser?.uid)
                                  //       .where("status", isEqualTo: "Unread")
                                  //       .snapshots(),
                                  //   builder: (context, snapshot) {
                                  //     if (snapshot.hasError) {
                                  //       return Text('');
                                  //     }

                                  //     int unreadCount =
                                  //         snapshot.data?.docs.length ?? 0;
                                  //     bool notifications = snapshot.hasData &&
                                  //         snapshot.data!.docs.any((element) =>
                                  //             element["Notification"] ==
                                  //             "True");

                                  //     return Container(
                                  //       height: 25,
                                  //       width: 25,
                                  //       decoration: BoxDecoration(
                                  //         color:
                                  //             notifications || unreadCount > 0
                                  //                 ? Colors.red
                                  //                 : Colors.white,
                                  //         borderRadius:
                                  //             BorderRadius.circular(50),
                                  //       ),
                                  //       child: Center(
                                  //         child: Text(
                                  //           "${snapshot.data?.docs.length ?? ''}",
                                  //           style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 13,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     );
                                  //   },
                                  // )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  error: (e, s) {
                    return Text("");
                  },
                  loading: () => Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showpicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(8),
            height: 101,
            child: Column(
              children: [
                Text("Choose Profile Photo",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await ref
                            .read(signup.notifier)
                            .uploadDP(ImageSource.camera);
                      },
                      icon: Icon(Icons.camera_alt),
                    ),
                    Text("Camera",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(width: 50),
                    IconButton(
                      onPressed: () async {
                        await ref
                            .read(signup.notifier)
                            .uploadDP(ImageSource.gallery);
                      },
                      icon: Icon(Icons.photo_library),
                    ),
                    Text("Gallery",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void showStoryPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(6),
            height: 155,
            child: Column(
              children: [
                Text("What type of story you want to upload!",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TextStory()),
                          );
                        },
                        icon: Icon(Icons.text_fields),
                      ),
                      Text("Text",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          )),
                      Spacer(),
                      IconButton(
                        onPressed: () async {
                          await ref
                              .read(signup.notifier)
                              .uploadVideoStory(ImageSource.gallery);
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.video_camera_back),
                      ),
                      Text("Video",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await ref
                            .read(signup.notifier)
                            .uploadImageStory(ImageSource.camera);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.camera_alt),
                    ),
                    Text("Camera",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        )),
                    Spacer(),
                    IconButton(
                      onPressed: () async {
                        await ref
                            .read(signup.notifier)
                            .uploadImageStory(ImageSource.gallery);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.photo_library),
                    ),
                    Text("Gallery",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
