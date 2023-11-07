import 'package:chat_application/FetchData.dart';
import 'package:chat_application/SendDataToDB.dart';
import 'package:chat_application/UserProfile.dart';
import 'package:chat_application/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

  @override
  void initState() {
    super.initState();

    // Listen to changes in the text field
    textEditingController.addListener(() {
      setState(() {
        _isTyping = textEditingController.text.isNotEmpty;
      });
    });
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
                final sendertext = message['SenderUid'];
                final receiverMessages = message['ReceiverUid'];
                final senderName = message['SenderName'];
                final receiverName = message['ReceiverName'];
                final receiverDp = message['SenderProfilePic'];
                final messageBubble = Messagebubble(
                  receiver: receiverMessages,
                  receiverDp: receiverDp,
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
                      onPressed: () {},
                      icon: Icon(
                        Icons.attach_file,
                        color: Colors.black,
                      )),
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
                                onPressed: () {},
                                icon: Icon(
                                  Icons.mic_outlined,
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
      required this.receiverDp,
      this.time,
      required this.isMe});
  final String text;
  final String sender;
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
                // elevation: 5.0,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("09:00 AM",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ]),
    );
  }
}
