import 'package:chat_application/messageBubbles.dart';
import 'package:chat_application/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class AllMessages extends ConsumerStatefulWidget {
  const AllMessages({super.key, required this.uid});
final String uid;
  @override
  ConsumerState<AllMessages> createState() => _AllMessagesState();
}

class _AllMessagesState extends ConsumerState<AllMessages> {
    final _auth = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(getAllMessagesStream);

    return messages.when(data: (data) {
      final messages = data.map((e) => e.toMap()).toList();

      Map<String, List<Messagebubble>> groupedMessages = {};

      for (var message in messages) {
        final messageText = message['Message'];
        final messageTime = (message["time"] as Timestamp).toDate();

        final convertTime = DateFormat("h:mm a").format(messageTime);
        final today = DateTime.now();
        final yesterday = today.subtract(Duration(days: 1));

        final isToday = messageTime.year == today.year &&
            messageTime.month == today.month &&
            messageTime.day == today.day;
        final isYesterday = messageTime.year == yesterday.year &&
            messageTime.month == yesterday.month &&
            messageTime.day == yesterday.day;

        final dateOfMsg = DateFormat("d MMMM").format(messageTime);

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

        if (widget.uid == message["SenderUid"] &&
                _auth == message["ReceiverUid"] ||
            widget.uid == message["ReceiverUid"] &&
                _auth == message["SenderUid"]) {
          // Group messages by date
          final groupKey = isToday
              ? 'Today'
              : isYesterday
                  ? 'Yesterday'
                  : dateOfMsg;

          groupedMessages.putIfAbsent(groupKey, () => []);
          groupedMessages[groupKey]!.add(messageBubble);
        }
      }

      // Generate widgets for each group
      List<Widget> messageGroups = [];
      groupedMessages.forEach((date, messages) {
        messageGroups.add(
          Column(
            children: [
              Text(
                date,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              ...messages,
            ],
          ),
        );
      });

      return Expanded(
        child: ListView(
          children: messageGroups,
          // reverse: true,
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
    });
  }
}
