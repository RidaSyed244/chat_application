import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
          ? EdgeInsets.fromLTRB(50, 0, 10, 0)
          : EdgeInsets.fromLTRB(10, 0, 50, 0),
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
