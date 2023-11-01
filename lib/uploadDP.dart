import 'package:chat_application/Home.dart';
import 'package:chat_application/FetchData.dart';
import 'package:chat_application/bottomNavigation.dart';
import 'package:chat_application/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final userquery = FirebaseFirestore.instance
    .collection("Users")
    .doc(FirebaseAuth.instance.currentUser?.uid)
    .snapshots();
final datainamap = userquery.map((event) => Users.fromMap(event.data() != null
    ? event.data() as Map<String, dynamic>
    : Map<String, dynamic>()));
final userstream = StreamProvider.autoDispose<Users>((ref) => datainamap);

class UploadDP extends ConsumerStatefulWidget {
  const UploadDP({super.key});

  @override
  ConsumerState<UploadDP> createState() => _UploadDPState();
}

class _UploadDPState extends ConsumerState<UploadDP> {
  @override
  Widget build(BuildContext context) {
    final userDataa = ref.watch(userstream);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Profile Picture",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Center(
            child: userDataa.when(data: (data) {
          return ListView(
            children: [
              SizedBox(
                height: 80,
              ),
              Text(
                "Upload Profile picture!!!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Press camera icon to upload\nyour picture",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                  size: 17,
                ),
              ),
              Center(
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 80,
                        left: 140,
                        child: GestureDetector(
                          onTap: () {
                            showpicker();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            child: Center(
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                                size: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.grey,
                        child: data.profilePic == null
                            ? Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(70)),
                                width: 135,
                                height: 135,
                                // child: IconButton(
                                //   icon: Icon(
                                //     Icons.camera_alt,
                                //     color: Colors.white,
                                //     size: 35,
                                //   ),
                                //   onPressed: () {
                                // showpicker();
                                //   },
                                // ),
                              )
                            : CircleAvatar(
                                radius: 75,
                                backgroundImage:
                                    NetworkImage(data.profilePic.toString()),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (data.profilePic != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottonNavigation()),
                    );
                  } else {}
                },
                child: Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          );
        }, error: (context, error) {
          return Text("");
        }, loading: () {
          return Center(
            child: CircularProgressIndicator(),
          );
        })),
      ),
    );
  }

  void showpicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(8),
            height: 101,
            child: Column(
              children: [
                Text("Choose Profile Photo",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await ref
                            .read(signup.notifier)
                            .uploadDP(ImageSource.camera);
                      },
                      icon: Icon(Icons.camera_alt),
                    ),
                    Text("Camera",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(width: 50),
                    IconButton(
                      onPressed: () async {
                        await ref
                            .read(signup.notifier)
                            .uploadDP(ImageSource.gallery);
                      },
                      icon: Icon(Icons.photo_library),
                    ),
                    Text("Gallery",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
