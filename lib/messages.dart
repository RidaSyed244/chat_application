// ignore_for_file: unused_field, unused_local_variable
import 'dart:io';

import 'package:chat_application/FetchData.dart';
import 'package:chat_application/SendDataToDB.dart';
import 'package:chat_application/SendImages.dart';
import 'package:chat_application/UserProfile.dart';
import 'package:chat_application/allMessages.dart';
import 'package:chat_application/messageBubbles.dart';
import 'package:chat_application/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multiple_images_picker/multiple_images_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class AttachFiles {
  final List<AttachTiles> details;
  final String title;
  final Function()? onPressed; // Callback function

  AttachFiles({required this.title, required this.details, this.onPressed});
}

class AttachTiles {
  final String description;
  final icon;

  AttachTiles({
    required this.description,
    required this.icon,
  });
}

class MessageScreen extends ConsumerStatefulWidget {
  MessageScreen({
    Key? key,
    required this.uid,
    this.message,
    required this.name,
    required this.profilePic,
    required this.email,
    required this.phoneNumber,
  }) : super(key: key);

  final String uid;
  final String name;
  final String? message;
  final String profilePic;
  final String email;
  final String phoneNumber;

  @override
  ConsumerState<MessageScreen> createState() => _MessagesState();
}

class _MessagesState extends ConsumerState<MessageScreen> {
  bool _isTyping = false;
  final _auth = FirebaseAuth.instance.currentUser?.uid;
  // final recorder = FlutterSoundRecorder();

  List<AttachFiles> tiles = [
    AttachFiles(onPressed: () async {}, title: "Camera", details: [
      AttachTiles(
          description: "",
          icon: Icon(
            Icons.camera,
            color: Colors.grey,
            size: 30,
          ))
    ]),
    AttachFiles(title: "Documents", details: [
      AttachTiles(
          description: "Share your files",
          icon: Icon(
            Icons.chat,
            color: Colors.grey,
            size: 30,
          ))
    ]),
    AttachFiles(title: "Create a poll", details: [
      AttachTiles(
          description: "Create a poll for any querry",
          icon: Icon(
            Icons.notifications,
            color: Colors.grey,
            size: 30,
          ))
    ]),
    AttachFiles(title: "Media", details: [
      AttachTiles(
          description: "Share photos and videos",
          icon: Icon(
            Icons.help,
            color: Colors.grey,
            size: 30,
          ))
    ]),
    AttachFiles(title: "Contacts", details: [
      AttachTiles(
          description: "Share your contacts",
          icon: Icon(
            Icons.storage,
            color: Colors.grey,
            size: 30,
          ))
    ]),
    AttachFiles(title: "Location", details: [
      AttachTiles(
          description: "Share your location",
          icon: Icon(
            Icons.insert_invitation,
            color: Colors.grey,
            size: 30,
          ))
    ])
  ];
  updateStatus() async {
    await FirebaseFirestore.instance
        .collection("Messages")
        .where("SenderUid", isEqualTo: _auth)
        .where("ReceiverUid", isEqualTo: widget.uid)
        .where("status", isEqualTo: "Unread")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("Messages")
            .doc(element.id)
            .update({"status": "Read"});
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // Change status of messages to read from unread
    updateStatus();
    // Listen to changes in the text field
    textEditingController.addListener(() {
      setState(() {
        _isTyping = textEditingController.text.isNotEmpty;
      });
    });
    // initRecorder();
  }

  // Future record() async {
  //   await recorder.startRecorder(toFile: 'audio');
  // }

  // Future stop() async {
  //   await recorder.stopRecorder();
  // }

  // Future initRecorder() async {
  //   final status = await Permission.microphone.request();
  //   if (status != PermissionStatus.granted) {
  //     throw "Microphone Permission not granted";
  //   }
  //   await recorder.openRecorder();
  // }

  // @override
  // void dispose() {
  //   recorder.closeRecorder();
  //   super.dispose();
  // }
  List<Asset> images = <Asset>[];
  String _error = 'No Error Detected';

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultipleImagesPicker.pickImages(
        maxImages: 30,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#000000",
          actionBarTitle: "ChatBox",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      // send images to database
      List<String> imageUrls =
          await ref.read(signup.notifier).uploadImageMessages(images);
      await ref.read(signup.notifier).saveImagesToFirestore(
          widget.uid, widget.name, widget.profilePic, imageUrls);
      print("Send image Message Successfully!");
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfile(
                              name: widget.name,
                              Dp: widget.profilePic,
                              email: widget.email,
                              phoneNumber: widget.phoneNumber,
                              address: '',
                            )));
              },
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 20,
                            )),
                        CircleAvatar(
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
                                      widget.profilePic.toString()),
                                ),
                              ),

                              // Green dot for online indicator
                              Positioned(
                                top: 36,
                                left: 45,
                                child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(widget.uid)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      final status = snapshot.data?["status"];
                                      if (snapshot.hasData &&
                                          status == "Online") {
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
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${widget.name}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("Users")
                                    .doc(widget.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.data?["status"] == "Online") {
                                    return Text("Active Now",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500));
                                  } else {
                                    return Text("Offline",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500));
                                  }
                                })
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.call_outlined,
                              color: Colors.black,
                              size: 30,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.video_call_outlined,
                              color: Colors.black,
                              size: 30,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
            AllMessages(
              uid: widget.uid,
            ),
            Container(
              padding: EdgeInsets.all(3),
              height: 100,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: MediaQuery.of(context).size.height *
                                  0.8, // Set a height constraint

                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.cancel_outlined,
                                              color: Colors.black)),
                                      SizedBox(
                                        width: 90,
                                      ),
                                      Text('Share Content',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        // physics: NeverScrollableScrollPhysics(),
                                        itemCount: tiles.length,
                                        itemBuilder: (context, index) {
                                          final AttachFiles det = tiles[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: ListTile(
                                              onTap: () async {
                                                if (det.title == "Camera") {
                                                  final ImagePicker _picker =
                                                      ImagePicker();
                                                  final pickedFile =
                                                      await _picker.pickImage(
                                                          source: ImageSource
                                                              .camera);

                                                  if (pickedFile != null) {
                                                    photo =
                                                        File(pickedFile.path);

                                                    if (photo == null) return;

                                                    final fileName =
                                                        basename(photo!.path);
                                                    final destination =
                                                        'AttachFileOfCamera/$fileName';

                                                    try {
                                                      final ref =
                                                          firebase_storage
                                                              .FirebaseStorage
                                                              .instance
                                                              .ref(destination)
                                                              .child('file');
                                                      await ref.putFile(photo!);
                                                      final url = await ref
                                                          .getDownloadURL();

                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "Messages")
                                                          .add({
                                                        "Message": '',
                                                        "VoiceMessage": "",
                                                        "ImageMessage": url,
                                                        "FileMessage": "",
                                                        "VideoMessage": "",
                                                        "Notification": "True",
                                                        "time": DateTime.now(),
                                                        "status": "Unread",
                                                        "SenderName":
                                                            currentUsername,
                                                        "SenderProfilePic":
                                                            currentprofilePic,
                                                        "ReceiverName":
                                                            widget.name,
                                                        "ReceiverProfilePic":
                                                            widget.profilePic,
                                                        "SenderUid":
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                ?.uid,
                                                        "ReceiverUid":
                                                            widget.uid,
                                                      });
                                                    } catch (e) {
                                                      print('error occurred');
                                                    }
                                                  } else {
                                                    print('No image selected.');
                                                  }
                                                }
                                              },
                                              title: Text(
                                                "${det.title}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              leading: CircleAvatar(
                                                radius: 30,
                                                backgroundColor: Color.fromARGB(
                                                    255, 249, 249, 249),
                                                child: ListView.builder(
                                                    itemCount:
                                                        det.details.length,
                                                    itemBuilder: (context,
                                                        doublesubIndex) {
                                                      final AttachTiles icons =
                                                          det.details[
                                                              doublesubIndex];

                                                      return CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                249, 249, 249),
                                                        child: icons.icon,
                                                      );
                                                    }),
                                              ),
                                              subtitle: Container(
                                                height: 20,
                                                child: ListView.builder(
                                                    itemCount:
                                                        det.details.length,
                                                    itemBuilder:
                                                        (context, subindex) {
                                                      final AttachTiles desc =
                                                          det.details[subindex];

                                                      return Text(
                                                        "${desc.description}",
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      );
                                                    }),
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.attach_file,
                        color: Colors.black,
                      )),
                  // recorder.isRecording
                  //     ? StreamBuilder<RecordingDisposition>(
                  //         stream: recorder.onProgress,
                  //         builder: (context, snapshot) {
                  //           final duration =
                  //               snapshot.data?.duration ?? Duration.zero;
                  //           String twoDigits(int n) => n.toString().padLeft(2);
                  //           final twoDigitMinutes =
                  //               twoDigits(duration.inMinutes.remainder(60));
                  //           final twoDigitSeconds =
                  //               twoDigits(duration.inSeconds.remainder(60));
                  //           final recordingTime =
                  //               "$twoDigitMinutes:$twoDigitSeconds";
                  //           print(recordingTime);
                  //           return Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Text(
                  //                 recordingTime,
                  //                 style: TextStyle(
                  //                   color: Colors.grey,
                  //                   fontSize: 14,
                  //                   fontWeight: FontWeight.w500,
                  //                 ),
                  //               ),
                  //               IconButton(
                  //                 icon: Icon(Icons.stop,
                  //                     color: Colors.red), // Show stop icon
                  //                 onPressed: () async {
                  //                   // await stop();
                  //                 },
                  //               ),
                  //             ],
                  //           );
                  //         },
                  //       )
                  //     :
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.file_copy_outlined),
                            onPressed: () {},
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 248, 245, 245),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 22.0,
                          ),
                          hintText: 'Write your message...',
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  _isTyping
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CircleAvatar(
                            radius: 23,
                            backgroundColor: Colors.green,
                            child: IconButton(
                                onPressed: () async {
                                  try {
                                    await ref
                                        .read(signup.notifier)
                                        .sendMessages(widget.uid, widget.name,
                                            widget.profilePic);
                                    textEditingController.clear();
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                )),
                          ),
                        )
                      : Row(
                          children: [
                            IconButton(
                                onPressed: loadAssets,
                                icon: Icon(
                                  Icons.camera_alt_outlined,
                                  color: const Color.fromARGB(255, 60, 60, 60),
                                  size: 27,
                                )),
                            IconButton(
                                onPressed: () async {
                                  // if (recorder.isRecording) {
                                  //   // await stop();
                                  // } else {
                                  //   // await record();
                                  // }
                                },
                                icon: Icon(
                                  // recorder.isRecording ? Icons.stop :
                                  Icons.mic,
                                  color: const Color.fromARGB(255, 60, 60, 60),
                                  size: 27,
                                )),
                          ],
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
