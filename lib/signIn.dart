import 'package:chat_application/Home.dart';
import 'package:chat_application/OnBoarding.dart';
import 'package:chat_application/SendDataToDB.dart';
import 'package:chat_application/uploadDP.dart';
import 'package:chat_application/users.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  final List<String> imagePaths = [
    'assets/images/fb.png',
    'assets/images/google.png',
    'assets/images/black Apple.png',
  ];
  void generateAndSaveToken() async {
    // Request permission for notifications
    await messaging.requestPermission();

    // Get the FCM token
    token = await messaging.getToken();
    print('FCM Token: $token');
  }

  void initState() {
    super.initState();
    generateAndSaveToken();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => OnBoarding()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(22),
        child: ListView(
          children: [
            SizedBox(
              height: 25,
            ),
            Column(
              children: [
                Container(
                  height: 50,
                  width: 163,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/line.png",
                      ),
                      alignment: Alignment.bottomLeft,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 23, 0, 0),
                        child: Text(
                          "Log in to Chatbox",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            // backgroundColor: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                      "Welcome back! Sign in using your social\naccount or email to continue us",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imagePaths
                      .map((imagePath) => buildImageCircle(imagePath))
                      .toList(),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("OR",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Divider(
                          color: Colors.grey,
                          thickness: 2,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Your email",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.green,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                TextFormField(
                  controller: emailController,
                  onChanged: (value) async {},
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Password",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.green,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  onChanged: (value) async {},
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () async {
                final login = await ref.read(signup.notifier).logIn();
                if (login != false) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('email', emailController.text);
                }
                await ref.read(signup.notifier).getToken();

                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => UploadDP()));
              },
              child: Text(
                "Log in",
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
            SizedBox(
              height: 9,
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Text("Forgot password?",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageCircle(String imagePath) {
    return Container(
      width: 65, // Adjust as needed
      height: 65, // Adjust as needed
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 2.0,
        ),
      ),
      child: Center(
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          width: 85, // Adjust image size as needed
          height: 40, // Adjust image size as needed
        ),
      ),
    );
  }
}
