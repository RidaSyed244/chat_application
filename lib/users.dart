import 'package:chat_application/FetchData.dart';
import 'package:chat_application/SendDataToDB.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final signup = StateNotifierProvider((ref) => AddDataToDB());

final getusersForMessage =
    FirebaseFirestore.instance.collection("Users").snapshots();
final alluserMessageStream = StreamProvider((ref) => getusersForMessage);