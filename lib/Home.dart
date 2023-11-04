import 'package:chat_application/FetchData.dart';
import 'package:chat_application/newStoryByCU.dart';
import 'package:chat_application/searchContacts.dart';
import 'package:chat_application/storyView.dart';
import 'package:chat_application/text.dart';
import 'package:chat_application/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
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

  @override
  void initState() {
    super.initState();
    getUserData();
    getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    final allmessageUsers = ref.watch(alluserMessageStream);
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
                      return Container(
                        height: 100,
                        decoration: BoxDecoration(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: ClipOval(
                                  child: NetworkImage(users.profilePic!) != null
                                      ? Image.network(
                                          users.profilePic!,
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
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 25, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "${users.name}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      "Hey there! I am using WhatsApp",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(43, 25, 0, 0),
                                child: Column(
                                  children: [
                                    Text(
                                      "10:00 AM",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "2",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 6, 0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              25, 25, 0, 0),
                                          child: Container(
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.notifications,
                                                size: 25,
                                              ),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 25, 0, 0),
                                          child: Container(
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.delete_outline,
                                                size: 25,
                                              ),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                error: (e, s) {
                  return Text(e.toString());
                },
                loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ))
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
