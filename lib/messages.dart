import 'package:chat_application/SendDataToDB.dart';
import 'package:chat_application/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Messages extends ConsumerStatefulWidget {
  Messages({required this.uid, required this.name, required this.profilePic});
  final String uid;
  final String name;
  final String profilePic;

  @override
  ConsumerState<Messages> createState() => _MessagesState();
}

class _MessagesState extends ConsumerState<Messages> {
  bool _isTyping = false;

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
  void dispose() {
    textEditingController.dispose();
    super.dispose();
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
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {},
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
