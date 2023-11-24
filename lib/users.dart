import 'package:chat_application/FetchData.dart';
import 'package:chat_application/SendDataToDB.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final signup = StateNotifierProvider((ref) => AddDataToDB());

final getusersForMessage = FirebaseFirestore.instance
    .collection("Users")
    .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser?.uid)
    .snapshots();
final alluserMessageStream = StreamProvider((ref) => getusersForMessage);
final getAllMessages = FirebaseFirestore.instance
    .collection("Messages")
    .orderBy("time", descending: false)
    .snapshots()
    .map((event) => event.docs.map((e) => Messages.fromMap(e.data())).toList());
final getAllMessagesStream = StreamProvider((ref) => getAllMessages);
final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

final getLastMessages = FirebaseFirestore.instance
    .collection("Messages")
    .where("SenderUid", isEqualTo: currentUserId)
    .where("ReceiverUid", isNotEqualTo: currentUserId)
    .orderBy("ReceiverUid")
    .orderBy("time", descending: true)
    .snapshots()
    .map((event) =>
        event.docs.map((doc) => Messages.fromMap(doc.data())).toList());

final getLastMessagesStream = StreamProvider((ref) => getLastMessages);

final allUsersData = FirebaseFirestore.instance
    .collection("Users")
    .snapshots()
    .map((event) => event.docs.map((e) => Users.fromMap(e.data())).toList());
final allUsersStream = StreamProvider((ref) => allUsersData);
//Get length of unread messages
final getUnreadMessages = FirebaseFirestore.instance
    .collection("Messages")
    .where("SenderUid", isEqualTo: currentUserId)
    .where("ReceiverUid", isNotEqualTo: currentUserId)
    .where("status", isEqualTo: "Unread")
    .snapshots()
    .map((event) {
  // Get the list of unread messages
  List<Messages> unreadMessagesList =
      event.docs.map((doc) => Messages.fromMap(doc.data())).toList();

  // Calculate the total number of unread messages
  int totalUnreadMessages = unreadMessagesList.length;

  // Log the total unread messages (you can replace this with your preferred way of displaying the length)
  print("Total Unread Messages: $totalUnreadMessages");

  // Return the list of unread messages
  return unreadMessagesList;
});

final getUnreadMessagesStream = StreamProvider((ref) => getUnreadMessages);
