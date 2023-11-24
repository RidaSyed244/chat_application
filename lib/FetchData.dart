// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<AllUsers> allusers = [];
var profilePic;
var name;
var uid;
var currentuid;
var currentprofilePic;
var currentUsername;

List<AllUsers> users = [];
var currentUserIndex;
List storySnapshots = [];

class Users {
  final String? email;
  final String? name;
  final String? password;
  final String? uid;
  final String? token;
  final String? profilePic;
  final phoneNumber;
  final String status;
  Users({
    required this.email,
    required this.name,
    required this.password,
    required this.uid,
    required this.token,
    required this.profilePic,
    required this.phoneNumber,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'password': password,
      'uid': uid,
      'token': token,
      'profilePic': profilePic,
      'status': status,
      'phoneNumber': phoneNumber,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      email: map['email'] != null ? map['email'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      uid: map['uid'] != null ? map['uid'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
      profilePic:
          map['profilePic'] != null ? map['profilePic'] as String : null,
      status: map['status'] as String,
      phoneNumber: map['phoneNumber'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Users.fromJson(String source) =>
      Users.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AllUsers {
  final String name;
  final String profilePic;
  List<Story> stories;
  final String uid;

  AllUsers({
    required this.name,
    required this.profilePic,
    required this.stories,
    required this.uid,
  });
}

class Story {
  final String storyType;
  final String content;

  Story({required this.storyType, required this.content});
}

////////////// Messages Fetching /////////////////////
class Messages {
  final time;
  final String status;
  final String Message;
  final String ReceiverName;
  final String ReceiverProfilePic;
  final String ReceiverUid;
  final String SenderName;
  final String SenderProfilePic;
  final String SenderUid;

  Messages({
    required this.status,
    required this.time,
    required this.Message,
    required this.ReceiverName,
    required this.ReceiverProfilePic,
    required this.ReceiverUid,
    required this.SenderName,
    required this.SenderProfilePic,
    required this.SenderUid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'Message': Message,
      'ReceiverName': ReceiverName,
      'ReceiverProfilePic': ReceiverProfilePic,
      'ReceiverUid': ReceiverUid,
      'SenderName': SenderName,
      'SenderProfilePic': SenderProfilePic,
      'SenderUid': SenderUid,
      'time': time,
    };
  }

  factory Messages.fromMap(Map<String, dynamic> map) {
    return Messages(
      status: map['status'] as String,
      Message: map['Message'] as String,
      ReceiverName: map['ReceiverName'] as String,
      ReceiverProfilePic: map['ReceiverProfilePic'] as String,
      ReceiverUid: map['ReceiverUid'] as String,
      SenderName: map['SenderName'] as String,
      SenderProfilePic: map['SenderProfilePic'] as String,
      SenderUid: map['SenderUid'] as String,
      time: map['time'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory Messages.fromJson(String source) => Messages.fromMap(json.decode(source) as Map<String, dynamic>);
}
