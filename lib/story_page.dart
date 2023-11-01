import 'package:chat_application/Home.dart';
import 'package:chat_application/SendDataToDB.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';



class CustomStoryView extends StatefulWidget {
  final String userId;
  final String? name;
  final String? profilePic;
  CustomStoryView({required this.userId, this.name, this.profilePic});

  @override
  _CustomStoryViewState createState() => _CustomStoryViewState();
}

class _CustomStoryViewState extends State<CustomStoryView>
    with TickerProviderStateMixin {
  final PageController _controller = PageController();
  double? _progressIndicators;
  int _page = 0; // Track the current page
  List<AnimationController?> _animationController = [];

  bool dragEnded = true;
  Size? _pageSize;
  Map<int, VideoPlayerController> videoControllers = {};

  int currentUserIndex = 0;
  @override
  void initState() {
    currentUserIndex =
        allusers.indexWhere((element) => element.uid == widget.userId);

    print(currentUserIndex);
    print("Story length i s: ${allusers[currentUserIndex].stories.length}");

    for (int i = 0; i < allusers[currentUserIndex].stories.length; i++) {
      _animationController.add(
          AnimationController(vsync: this, duration: Duration(seconds: 10)));

      _animationController[i]?.value = 0.0;

      _animationController[i]?.addListener(() {
        if (_animationController[i]?.value == 1.0) {
          _moveForward();
        }
      });
    }

    _animationController[_page]?.forward();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageSize = MediaQuery.of(context).size;
      _progressIndicators = (_pageSize!.width - 100) / 6;
    });

    super.initState();
  }

  @override
  void dispose() {
    for (var controller in _animationController) {
      controller?.dispose();
      super.dispose();
    }
  }

  bool isTypingReply = false; // Track whether user is typing a reply

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              // final storyUid = stories[index];
              return GestureDetector(
                onLongPressStart: _onLongPressStart,
                onLongPressEnd: _onLongPressEnd,
                onHorizontalDragEnd: _onHorizontalDragEnd,
                onHorizontalDragStart: _onHorizontalDragStart,
                onHorizontalDragUpdate: _onHorizontalDragUpdate,
                onTapUp: _onTapDown,
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 23,
                              backgroundImage: NetworkImage(
                                  allusers[currentUserIndex]
                                      .profilePic
                                      .toString()),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              allusers[currentUserIndex].name.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: allusers[currentUserIndex]
                                        .stories[index]
                                        .storyType
                                        .toString() ==
                                    "Text"
                                ? Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Center(
                                      child: Text(
                                        allusers[currentUserIndex]
                                            .stories[index]
                                            .content
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  )
                                : allusers[currentUserIndex]
                                            .stories[index]
                                            .storyType ==
                                        "Image"
                                    ? Image.network(
                                        "${allusers[currentUserIndex].stories[index].content.toString()}",
                                        fit: BoxFit.cover,
                                      )
                                    // : stories[index].storyType == "Video"
                                    //     ? AspectRatio(
                                    //         aspectRatio: 16 / 9,
                                    //         child: VideoPlayer(
                                    //             videoControllers[index]!),
                                    //       )
                                    : Container()),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
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
                                onTap: () {
                                  setState(() {
                                    isTypingReply =
                                        true; // User is typing a reply

                                    _animationController[index]
                                        ?.stop(); // Stop the animation
                                  });
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
                                      // await FirebaseFirestore.instance
                                      //     .collection('Users')
                                      //     .doc(widget.userId)
                                      //     .collection('Stories')
                                      //     .doc(storyUid?.uid)
                                      //     .collection("StoryReplies")
                                      //     .add({
                                      //   "UserDP": widget.profilePic,
                                      //   "UserName": widget.name,
                                      //   "UserReply":
                                      //       storyReplyController.text,
                                      //   "uid": widget.userId,
                                      //   "ReplyTime": DateTime.now(),
                                      //   "StoryContent": snapshot
                                      //       .data?.docs[index]["content"],
                                      // }).then(
                                      //   (value) {
                                      //     storyReplyController.clear();

                                      //     showDialog(
                                      //         context: context,
                                      //         builder: (builder) {
                                      //           return Center(
                                      //             child: Container(
                                      //               height: 40,
                                      //               width: 60,
                                      //               decoration: BoxDecoration(
                                      //                   borderRadius:
                                      //                       BorderRadius
                                      //                           .circular(
                                      //                               20),
                                      //                   color:
                                      //                       Colors.grey),
                                      //               child: Center(
                                      //                 child: Text(
                                      //                   "Reply sent",
                                      //                   style: TextStyle(
                                      //                       color: Colors
                                      //                           .white,
                                      //                       fontSize: 15),
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           );
                                      //         });

                                      //     isTypingReply = false;
                                      //     _animationController?.forward();
                                      //   },
                                      // );
                                      // print("send reply");
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    color: Color.fromRGBO(51, 51, 51, 1),
                                  )),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: allusers[currentUserIndex].stories.length == 0
                ? 1
                : allusers[currentUserIndex].stories.length,
          ),
          Positioned(
            top: 48,
            left: 3,
            right: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ([
                ...List.generate(
                    allusers[currentUserIndex].stories.length.toInt(),
                    (index) => index)
              ]
                  .map((e) => (e == _page)
                      ? Stack(
                          children: [
                            Container(
                              width: _progressIndicators,
                              height: 3,
                              color: const Color.fromARGB(255, 195, 195, 195),
                            ),
                            AnimatedBuilder(
                              animation: _animationController[e]!,
                              builder: (ctx, widget) {
                                return AnimatedContainer(
                                  width: _progressIndicators! *
                                      _animationController[e]!.value,
                                  height: 3,
                                  color: Colors.white,
                                  duration: Duration(milliseconds: 10),
                                );
                              },
                            ),
                          ],
                        )
                      : Container(
                          width: _progressIndicators,
                          height: 3,
                          color: (_page >= e)
                              //logic of upper line is here
                              // Logic is that if the story is seen then the color of the line will be white
                              ? Colors.white
                              : Color.fromARGB(255, 195, 195, 195),
                        ))
                  .toList()),
            ),
          )
        ],
      ),
    );
  }

  // animationListener() {
  //   if (_animationController == 1) {
  //     _moveForward();
  //   }
  // }

  _moveForward() {
    if (_controller.page != (allusers[currentUserIndex].stories.length - 1)) {
      setState(() {
        _page = (_controller.page! + 1).toInt();
        _controller.animateToPage(_page,
            duration: Duration(milliseconds: 100), curve: Curves.easeIn);
        _animationController[_page]?.reset();
        _animationController[_page]?.forward();
      });
    } else {
      // Check if the last story is reached for the current user
      if (currentUserIndex < (allusers[currentUserIndex].stories.length - 1)) {
        // Switch to the next user's stories
        setState(() {
          currentUserIndex++;
          _page = 0;
          _controller.jumpToPage(0);
          for (var contsoller in _animationController) {
            contsoller?.reset();
          }
          _animationController[_page]?.forward();
          print(currentUserIndex);
          // allusers[currentUserIndex]
          //     .stories
          //     .clear(); // Clear the current user's stories
          final nextUser = allusers[currentUserIndex];

          // Update user information
          name = nextUser.name;
          uid = nextUser.uid;
          profilePic = nextUser.profilePic;
          allusers[currentUserIndex].stories = nextUser.stories;

          // Initialize video controllers for the new user's stories
          // for (int i = 0; i < allusers[currentUserIndex].stories.length; i++) {
          //   if (allusers[currentUserIndex].stories[i].storyType == "Video") {
          //     try {
          //       videoControllers[i] = VideoPlayerController.network(
          //         stories[i].content,
          //       )..initialize().then((_) {
          //           setState(() {
          //             if (i == 0) {
          //               videoControllers[i]?.play();
          //             }
          //           });
          //         });
          //     } catch (e) {
          //       print("Error initializing video controller: $e");
          //     }
          //   }
          // }
        });
      } else {
        // All users' stories have ended, you can handle this case as needed
        // For example, show a message or return to the previous screen
        Navigator.of(context).pop();
      }
    }
  }

  _moveBackward() {
    if (_page != 0) {
      // If you can go back one page within the current user's stories
      final prevIndex = _page - 1;
      setState(() {
        _page = prevIndex;
        _controller.animateToPage(_page,
            duration: Duration(milliseconds: 100), curve: Curves.easeIn);

        // Reset the animation controller for the previous story
        _animationController[prevIndex]?.reset();
        _animationController[prevIndex]?.forward();
      });
    } else {
      // If you are on the first page of the current user's stories
      if (currentUserIndex > 0) {
        // If there's a previous user, switch to their stories
        final prevUserIndex = currentUserIndex - 1;
        setState(() {
          currentUserIndex = prevUserIndex;
          _page = 0;
          _controller.jumpToPage(0);
          _animationController[0]?.reset();

          // Update user information
          name = allusers[currentUserIndex].name;
          uid = allusers[currentUserIndex].uid;
          profilePic = allusers[currentUserIndex].profilePic;

          // Start the animation controller for the first story of the new user
          _animationController[0]?.forward();
        });
      }
    }
  }

  _onTapDown(TapUpDetails details) {
    var x = details.globalPosition.dx;
    (x < _pageSize!.width / 2) ? _moveBackward() : _moveForward();
  }

  switchToNextUser() {
    if (currentUserIndex < allusers.length - 1) {
      setState(() {
        currentUserIndex++;
        _page = 0;
        _animationController[_page]?.reset();
        _animationController[_page]?.forward();

        _controller.jumpToPage(0);
      });
    } else {
      // Handle when there are no more users
      // For example, show a message or return to the previous screen
      Navigator.of(context).pop();
    }
  }

  _onHorizontalDragUpdate(DragUpdateDetails d) {
    if (!dragEnded) {
      dragEnded = true;
      if (d.delta.dx < -5) {
        // User is dragging left, move forward
        setState(() {
          _moveForward();
        });
      } else if (d.delta.dx > 5) {
        // User is dragging right, move backward
        setState(() {
          _moveBackward();
        });
      }
    }
  }

  _onHorizontalDragStart(d) {
    dragEnded = false;
  }

  _onHorizontalDragEnd(d) {
    dragEnded = true;
  }

  _onLongPressEnd(_) {
    setState(() {
      if (_animationController[_page]?.status == AnimationStatus.completed) {
        _animationController[_page]?.stop();
      } else {
        _animationController[_page]?.forward();
      }
    });
  }

  _onLongPressStart(_) {
    setState(() {
      if (_animationController[_page]?.status == AnimationStatus.completed) {
        _animationController[_page]?.stop();
      } else {
        _animationController[_page]?.forward();
      }
    });
  }
}
