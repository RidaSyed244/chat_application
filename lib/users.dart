import 'package:chat_application/FetchData.dart';
import 'package:chat_application/SendDataToDB.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final signup = StateNotifierProvider((ref) => AddDataToDB());

final getusersForMessage = FirebaseFirestore.instance
    .collection("Users")
    .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
    .snapshots();
final alluserMessageStream = StreamProvider((ref) => getusersForMessage);
final getAllMessages = FirebaseFirestore.instance
    .collection("Messages")
    .orderBy("time", descending:  false)
    .snapshots()
    .map((event) => event.docs.map((e) => Messages.fromMap(e.data())).toList());
final getAllMessagesStream = StreamProvider((ref) => getAllMessages);
