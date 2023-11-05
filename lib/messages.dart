import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
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
                        backgroundImage: NetworkImage("url"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Rida Syed",
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
                  // CircleAvatar(
                  //   radius: 23,
                  //   backgroundColor: Colors.green,
                  //   child: IconButton(
                  //       onPressed: () async {},
                  //       icon: Icon(
                  //         Icons.send,
                  //         color: Colors.white,
                  //       )),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
