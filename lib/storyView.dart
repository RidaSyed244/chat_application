// ignore_for_file: unused_element
import 'package:chat_application/Home.dart';
import 'package:chat_application/SendDataToDB.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class MoreStories extends StatefulWidget {
  final List<AllUsers> users;
  final String userId; // Index of the user whose story to start with

  MoreStories({required this.users, required this.userId});

  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final storyController = StoryController();
  int currentUserIndex = 0;
  bool isTypingReply = false; // Track whether user is typing a reply
  @override
  void initState() {
    super.initState();
    currentUserIndex =
        allusers.indexWhere((element) => element.uid == widget.userId);
    getStoryDocIds();
  }

  Future getStoryDocIds() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userId)
        .collection('Stories')
        .get();
    storySnapshots = querySnapshot.docs.map((doc) => doc).toList();
    setState(() {
      storySnapshots = querySnapshot.docs.map((doc) => doc).toList();
      print(storySnapshots);
    });
  }

  int? storySnapshot;
  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: PageView.builder(
        itemCount: widget.users.length,
        controller: PageController(
          initialPage: currentUserIndex,
        ),
        onPageChanged: (index) {
          setState(() {
            currentUserIndex = index;
          });
        },
        itemBuilder: (context, indexx) {
          return Stack(
            children: [
              StoryView(
                storyItems: widget.users[currentUserIndex].stories.map((story) {
                  if (story.storyType == "Text") {
                    return StoryItem.text(
                      textStyle: TextStyle(color: Colors.white, fontSize: 35),
                      title: story.content,
                      backgroundColor: Colors.black,
                    );
                  } else if (story.storyType == "Image") {
                    return StoryItem.pageImage(
                      url: story.content,
                      controller: storyController,
                    );
                  } else if (story.storyType == "Video") {
                    return StoryItem.pageVideo(
                      story.content,
                      controller: storyController,
                    );
                  }
                  return StoryItem.pageVideo(
                    story.content,
                    controller: storyController,
                  );
                }).toList(),
                onStoryShow: (s) {},
                onComplete: () {
                  if (widget.userId == currentuid) {
                    Navigator.pop(context);
                  } else if (currentUserIndex < widget.users.length - 1) {
                    setState(() {
                      currentUserIndex++;
                      storyController.previous();
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                progressPosition: ProgressPosition.top,
                repeat: false,
                controller: storyController,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(3),
                      height: 60,
                      color: Color.fromRGBO(51, 51, 51, 1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: storyReplyController,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  if (!isTypingReply) {
                                    isTypingReply = true;
                                    storyController.pause();
                                  }
                                } else {
                                  if (isTypingReply) {
                                    isTypingReply = false;
                                    storyController.play();
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 22.0,
                                  ),
                                  hintText: 'Send a reply...',
                                  hintStyle: TextStyle(color: Colors.white)),
                            ),
                          ),
                          CircleAvatar(
                            radius: 23,
                            backgroundColor: Colors.white,
                            child: IconButton(
                                onPressed: () async {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(widget.userId)
                                        .collection('Stories')
                                        .doc(storySnapshots[indexx].id)
                                        .collection("StoryReplies")
                                        .add({
                                      "UserDP": currentprofilePic,
                                      "UserName": currentUsername,
                                      "UserReply": storyReplyController.text,
                                      "uid": widget.userId,
                                      "ReplyTime": DateTime.now(),
                                      "StoryContent": widget
                                          .users[currentUserIndex]
                                          .stories[indexx]
                                          .content,
                                    });
                                    print(storyReplyController.text);
                                    // storyReplyController.clear();
                                    // isTypingReply = false;
                                    print("sending reply");

                                    storyController.play();
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: Color.fromRGBO(51, 51, 51, 1),
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                              onPressed: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(widget.userId)
                                      .collection('Stories')
                                      .doc(storySnapshots[indexx].id)
                                      .collection("StoryLikes")
                                      .add({
                                    "UserDP": currentprofilePic,
                                    "UserName": currentUsername,
                                    "UserLike": "Liked",
                                    "uid": widget.userId,
                                    "LikeTime": DateTime.now(),
                                    "StoryContent": widget
                                        .users[currentUserIndex]
                                        .stories[indexx]
                                        .content,
                                  });
                                  print("LIKED");
                                  print(storySnapshot);
                                } catch (e) {
                                  print(e);
                                }
                              },
                              icon: Icon(
                                Icons.heart_broken_outlined,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 50,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                            radius: 23,
                            backgroundImage: NetworkImage(
                                widget.users[currentUserIndex].profilePic)),
                        SizedBox(
                          width: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${widget.users[currentUserIndex].name}",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
