// ignore_for_file: unused_local_variable, unused_element

import 'dart:io' as io;
import 'dart:io';
import 'dart:typed_data';
import 'package:chat_application/FetchData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiple_images_picker/multiple_images_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();
final TextEditingController storyReplyController = TextEditingController();
final TextEditingController textEditingController = TextEditingController();
final TextEditingController forgotPasswordController = TextEditingController();
File? photo;
PickedFile? imageFile;
PickedFile? videoFile;
final ImagePicker _picker = ImagePicker();
List filteredUsers = [];
String? token;
List<Users> allContactUsers = [];

class AddDataToDB extends StateNotifier {
  AddDataToDB() : super('');
  Future SignUp() async {
    UserCredential auth =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    User? userss = auth.user;
    return userss;
  }

  getUid(uid) {
    return uid;
  }

  sendMessages(receiversUid, receiversName, reciversDp) async {
    await FirebaseFirestore.instance.collection("Messages").add({
      "Message": textEditingController.text,
      "VoiceMessage": "",
      "ImageMessage": "",
      "FileMessage": "",
      "VideoMessage": "",
      "Notification": "True",
      "time": DateTime.now(),
      "status": "Unread",
      "SenderName": currentUsername,
      "SenderProfilePic": currentprofilePic,
      "ReceiverName": receiversName,
      "ReceiverProfilePic": reciversDp,
      "SenderUid": FirebaseAuth.instance.currentUser?.uid,
      "ReceiverUid": receiversUid,
    });
  }
Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      photo = File(pickedFile.path);
      // uploadFile();
    } else {
      print('No image selected.');
    }
  }

  Future<List<String>> uploadImageMessages(List<Asset> images) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final firebase_storage.FirebaseStorage _storage =
        firebase_storage.FirebaseStorage.instance;
    List<String> imageUrls = [];

    for (var image in images) {
      try {
        // Convert Asset to ByteData
        ByteData byteData = await image.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();

        // Generate a unique filename
        String filename = DateTime.now().toIso8601String();

        // Create a reference to the image in Firebase Storage
        final firebase_storage.Reference storageRef =
            _storage.ref().child('imageMessagess/$filename.jpg');

        // Upload image to Firebase Storage
        await storageRef.putData(imageData as Uint8List);

        // Get the download URL of the uploaded image
        final String downloadURL = await storageRef.getDownloadURL();

        // Save the download URL in a list
        imageUrls.add(downloadURL);
      } catch (e) {
        print('Error uploading image: $e');
        // Handle error
      }
    }

    return imageUrls;
  }

  Future saveImagesToFirestore(
      receiversUid, receiversName, reciversDp, List<String> imageUrls) async {
    try {
      // Create a reference to the Firestore collection where image URLs will be stored
      final imagesCollection =
          FirebaseFirestore.instance.collection("Messages");

      // Save the download URLs in Firestore
      for (var url in imageUrls) {
        await imagesCollection.add({
          "Message": '',
          "VoiceMessage": "",
          "ImageMessage": url,
          "FileMessage": "",
          "VideoMessage": "",
          "Notification": "True",
          "time": DateTime.now(),
          "status": "Unread",
          "SenderName": currentUsername,
          "SenderProfilePic": currentprofilePic,
          "ReceiverName": receiversName,
          "ReceiverProfilePic": reciversDp,
          "SenderUid": FirebaseAuth.instance.currentUser?.uid,
          "ReceiverUid": receiversUid,
        });
      }
    } catch (e) {
      print('Error saving images to Firestore: $e');
      // Handle error
    }
  }

  Future RegisterUserIndo() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({
      "email": emailController.text,
      "password": confirmPasswordController.text,
      "name": nameController.text,
      "profilePic": "",
      "uid": FirebaseAuth.instance.currentUser?.uid,
      "status": ""
    });
  }

  Future logIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: confirmPasswordController.text,
    );
  }

  getToken() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      "token": token,
    });
  }

  Future uploadDP(ImageSource sourse) async {
    final pickedFile = await _picker.pickImage(source: sourse);
    if (pickedFile == null) return;
    String uniquefilename = DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceroot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceroot.child('file');
    Reference referenceImagetoUpload = referenceDirImages.child(uniquefilename);
    try {
      await referenceImagetoUpload.putFile(File(pickedFile.path));
      String DPimageUrl = await referenceImagetoUpload.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        "profilePic": DPimageUrl,
      });
      imageFile = pickedFile as PickedFile;
    } catch (e) {
      print(e);
    }
  }

  Future uploadImageStory(ImageSource sourse) async {
    final pickedFile = await _picker.pickImage(source: sourse);
    if (pickedFile == null) return;
    String uniquefilename = DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceroot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceroot.child('file');
    Reference referenceImagetoUpload = referenceDirImages.child(uniquefilename);

    await referenceImagetoUpload.putFile(File(pickedFile.path));
    String storyImageUrl = await referenceImagetoUpload.getDownloadURL();
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("Stories")
          .add({
        "content": storyImageUrl,
        "storyTime": DateTime.now(),
        "status": "Online",
        "storyType": "Image"
      });
      imageFile = pickedFile as PickedFile;
    } catch (e) {
      print(e);
    }
  }

  Future uploadVideoStory(ImageSource sourse) async {
    final pickedFile = await _picker.pickVideo(source: sourse);
    if (pickedFile == null) return;
    String uniquefilename = DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceroot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceroot.child('file');
    Reference referenceImagetoUpload = referenceDirImages.child(uniquefilename);

    await referenceImagetoUpload.putFile(File(pickedFile.path));
    String videoUrl = await referenceImagetoUpload.getDownloadURL();
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("Stories")
          .add({
        "content": videoUrl,
        "storyTime": DateTime.now(),
        "status": "Online",
        "storyType": "Video "
      });
      imageFile = pickedFile as PickedFile;
    } catch (e) {
      print(e);
    }
  }

  Future<String> downloadVideoURL(String VideoFile) async {
    File? _video;

    try {
      String fileName = basename(_video!.path);
      final downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child("file/$VideoFile")
          .getDownloadURL();

      print(downloadURL);
      return downloadURL;
    } catch (e) {
      print(e);
    }
    return VideoFile;
  }
}
