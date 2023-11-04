// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
List<AllUsers> allusers = [];
var profilePic;
var name;
var uid;
var currentuid;
var currentprofilePic;
List<AllUsers> users = [];
var currentUserIndex;
var currentUsername;
List storySnapshots = [];
class Users {
  final String? email;
  final String? name;
  final String? password;
  final String? uid;
  final String? token;
  final String? profilePic;
  final  phoneNumber;
  Users({
    required this.email,
    required this.name,
    required this.password,
    required this.uid,
    required this.token,
    required this.profilePic,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'password': password,
      'uid': uid,
      'token': token,
      'profilePic': profilePic,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      email: map['email'] != null ? map['email'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      uid: map['uid'] != null ? map['uid'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
      profilePic: map['profilePic'] != null ? map['profilePic'] as String : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Users.fromJson(String source) => Users.fromMap(json.decode(source) as Map<String, dynamic>);
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