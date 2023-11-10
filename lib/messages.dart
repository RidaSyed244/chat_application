// ignore_for_file: unused_field
import 'package:chat_application/SendDataToDB.dart';
import 'package:chat_application/UserProfile.dart';
import 'package:chat_application/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class AttachFiles {
  final List<AttachTiles> details;
  final String title;

  AttachFiles({required this.title, required this.details});
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
  MessageScreen(
      {required this.uid,
      required this.name,
      required this.profilePic,
      required this.email,
      required this.phoneNumber});
  final String uid;
  final String name;
  final String profilePic;
  final String email;
  final String phoneNumber;

  @override
  ConsumerState<MessageScreen> createState() => _MessagesState();
}

class _MessagesState extends ConsumerState<MessageScreen> {
  bool _isTyping = false;
  final _auth = FirebaseAuth.instance.currentUser?.uid;
  final recorder = FlutterSoundRecorder();
  List<AttachFiles> tiles = [
    AttachFiles(title: "Camera", details: [
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
  @override
  void initState() {
    super.initState();

    // Listen to changes in the text field
    textEditingController.addListener(() {
      setState(() {
        _isTyping = textEditingController.text.isNotEmpty;
      });
    });
    initRecorder();
  }

  Future record() async {
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    await recorder.stopRecorder();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw "Microphone Permission not granted";
    }
    await recorder.openRecorder();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(getAllMessagesStream);
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
                          radius: 30,
                          backgroundImage: NetworkImage("${widget.profilePic}"),
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
                            Text("Active Now",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500))
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
            messages.when(data: (data) {
              final messages = data.map((e) => e.toMap()).toList().reversed;
              List<Messagebubble> messageBubbles = [];
              for (var message in messages) {
                final messageText = message['Message'];
                final messageTime = message["time"];
                //Show time like this 09: 44
                final convertTime =
                    DateFormat("h:mm a").format(messageTime.toDate());

                final sendertext = message['SenderUid'];
                final receiverMessages = message['ReceiverUid'];
                final senderName = message['SenderName'];
                final receiverName = message['ReceiverName'];
                final receiverDp = message['SenderProfilePic'];
                final messageBubble = Messagebubble(
                  receiver: receiverMessages,
                  receiverDp: receiverDp,
                  messageTime: convertTime,
                  text: messageText,
                  senderName: senderName,
                  receiverName: receiverName,
                  sender: sendertext,
                  isMe: _auth == sendertext,
                );
                // messageBubbles.add(messageBubble);
                // To  separate messages between two users
                if (widget.uid == message["SenderUid"] &&
                        _auth == message["ReceiverUid"] ||
                    widget.uid == message["ReceiverUid"] &&
                        _auth == message["SenderUid"]) {
                  messageBubbles.add(messageBubble);
                }
              }
              return Expanded(
                child: ListView(
                  children: messageBubbles,
                  reverse: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 20.0,
                  ),
                ),
              );
            }, error: (e, s) {
              return Text("${e}");
            }, loading: () {
              return Center(child: CircularProgressIndicator());
            }),
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
                  recorder.isRecording
                      ? StreamBuilder<RecordingDisposition>(
                          stream: recorder.onProgress,
                          builder: (context, snapshot) {
                            final duration =
                                snapshot.data?.duration ?? Duration.zero;
                            String twoDigits(int n) => n.toString().padLeft(2);
                            final twoDigitMinutes =
                                twoDigits(duration.inMinutes.remainder(60));
                            final twoDigitSeconds =
                                twoDigits(duration.inSeconds.remainder(60));
                            final recordingTime =
                                "$twoDigitMinutes:$twoDigitSeconds";
                            print(recordingTime);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  recordingTime,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.stop,
                                      color: Colors.red), // Show stop icon
                                  onPressed: () async {
                                    await stop();
                                  },
                                ),
                              ],
                            );
                          },
                        )
                      : Expanded(
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
                                fillColor:
                                    const Color.fromARGB(255, 248, 245, 245),
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

                                    Navigator.pop(context);
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
                                onPressed: () {},
                                icon: Icon(
                                  Icons.camera_alt_outlined,
                                  color: const Color.fromARGB(255, 60, 60, 60),
                                  size: 27,
                                )),
                            IconButton(
                                onPressed: () async {
                                  if (recorder.isRecording) {
                                    await stop();
                                  } else {
                                    await record();
                                  }
                                },
                                icon: Icon(
                                  recorder.isRecording ? Icons.stop : Icons.mic,
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

class Messagebubble extends ConsumerWidget {
  Messagebubble(
      {required this.sender,
      required this.receiver,
      required this.text,
      required this.receiverName,
      required this.senderName,
      required this.messageTime,
      required this.receiverDp,
      this.time,
      required this.isMe});
  final String text;
  final String sender;
  final messageTime;
  final bool isMe;
  final String receiverDp;
  final String receiverName;
  final String senderName;
  final time;
  final String receiver;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: isMe
          ? EdgeInsets.fromLTRB(90, 0, 10, 0)
          : EdgeInsets.fromLTRB(10, 0, 90, 0),
      child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                isMe
                    ? Text('')
                    : CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(receiverDp),
                      ),
                SizedBox(
                  width: 10,
                ),
                isMe
                    ? Text('')
                    : Text(
                        "${senderName}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
              ],
            ),
            // SizedBox(
            //   height: 10,
            // ),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
              child: Material(
                // elevation: 3.0,
                borderRadius: isMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0))
                    : BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                color: isMe
                    ? Color.fromARGB(255, 41, 175, 162)
                    : Color.fromARGB(255, 248, 245, 245),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.center,
              children: [
                Text(
                  messageTime,
                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ],
            ),
          ]),
    );
  }
}
