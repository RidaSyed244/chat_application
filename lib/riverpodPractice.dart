// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';


// class Users {
//   final String? email;
//   final String? name;
//   final String? password;
//   final String? uid;
//   final String? token;
//   final String? profilePic;
//   final phoneNumber;
//   Users({
//     required this.email,
//     required this.name,
//     required this.password,
//     required this.uid,
//     required this.token,
//     required this.profilePic,
//     required this.phoneNumber,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'email': email,
//       'name': name,
//       'password': password,
//       'uid': uid,
//       'token': token,
//       'profilePic': profilePic,
//     };
//   }

//   factory Users.fromMap(Map<String, dynamic> map) {
//     return Users(
//       email: map['email'] != null ? map['email'] as String : null,
//       name: map['name'] != null ? map['name'] as String : null,
//       password: map['password'] != null ? map['password'] as String : null,
//       uid: map['uid'] != null ? map['uid'] as String : null,
//       token: map['token'] != null ? map['token'] as String : null,
//       profilePic:
//           map['profilePic'] != null ? map['profilePic'] as String : null,
//       phoneNumber:
//           map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Users.fromJson(String source) =>
//       Users.fromMap(json.decode(source) as Map<String, dynamic>);
// }

// final usersQuery = FirebaseFirestore.instance.collection("Users").snapshots();
// final userStream = StreamProvider((ref) {
//   return usersQuery ;
//   // .map((event) {
//   //   return event.docs.map((e) => Users.fromMap(e.data())).toList();
//   // });
// });

// class UidNotifier extends StateNotifier {
//   UidNotifier() : super("");
//   getUid(String uid) {
//     state= uid;
//   }
// }

// final uidNotifier = StateNotifierProvider((ref) => UidNotifier());

// class MyWidget extends ConsumerStatefulWidget {
//   const MyWidget({super.key});

//   @override
//   ConsumerState<MyWidget> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends ConsumerState<MyWidget> {
//   @override
//   Widget build(BuildContext context) {
//     final users = ref.watch(userStream);
//     return Scaffold(
//       body: users.when(data: (data) {
//         return ListView.builder(
//           itemCount: data.docs.length,
//           itemBuilder: (context, index) {
//             final uid = data.docs[index];
//             final user = data.docs[index];
//             return ListTile(
//               title: Text(user.data()["name"]),
//               subtitle: Text(user.data()["email"]),
//               onTap: () async {
//                 await ref.read(uidNotifier.notifier).getUid(uid.id);
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => NewScreen(uid: uid.id)));
//               },
//             );
//           },
//         );
//       }, error: (error, stackTrace) {
//         return Text(error.toString());
//       }, loading: () {
//         return CircularProgressIndicator();
//       }),
//     );
//   }
// }

// class SubColl {
//   final String texts;
//   SubColl({
//     required this.texts,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'texts': texts,
//     };
//   }

//   factory SubColl.fromMap(Map<String, dynamic> map) {
//     return SubColl(
//       texts: map['texts'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory SubColl.fromJson(String source) =>
//       SubColl.fromMap(json.decode(source) as Map<String, dynamic>);
// }

// /////////////////////// New Screen ////////////////////////////

// final stream = StreamProvider<List<SubColl>>((ref) {
//     final uid = ref.watch(uidNotifier); // Watch the UID from uidNotifierProvider

//   return FirebaseFirestore.instance
//     .collection("Users")
//     .doc( uid.toString()) // Use the UID from uidNotifierProvider
//     .collection("Riverpod")
//     .snapshots().map((event) {
//     return event.docs.map((e) => SubColl.fromMap(e.data())).toList();
//   });
// });

// class NewScreen extends ConsumerStatefulWidget {
//   const NewScreen({super.key, required this.uid});
//   final String uid;
//   @override
//   ConsumerState<NewScreen> createState() => _NewScreenState();
// }

// class _NewScreenState extends ConsumerState<NewScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final riverpod = ref.watch(stream);
//     return Scaffold(
//       body: riverpod.when(data: (data) {
//         return ListView.builder(
//           itemCount: data.length,
//           itemBuilder: (context, index) {
//             final river = data[index];
//             return ListTile(
//               title: Text(river.texts),
//             );
//           },
//         );
//       }, error: (error, stackTrace) {
//         return Text(error.toString());
//       }, loading: () {
//         return CircularProgressIndicator();
//       }),
//     );
//   }
// }
