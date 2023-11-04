import 'dart:math';
import 'package:chat_application/FetchData.dart';
import 'package:chat_application/searchContacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class Contacts extends ConsumerStatefulWidget {
  const Contacts({super.key});

  @override
  ConsumerState<Contacts> createState() => _ContactsState();
}

class _ContactsState extends ConsumerState<Contacts> {
  List<Contact> contacts = [];
  bool isLoading = true;
  List<Users> registeredUsers = [];

  getContactPermission() async {
    if (await Permission.contacts.isGranted) {
      fetchContacts();
    } else {
      Permission.contacts.request();
    }
  }

  fetchContacts() async {
    contacts = await ContactsService.getContacts();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getContactPermission();
    FirebaseFirestore.instance.collection("Users").get().then((value) {
      value.docs.forEach((element) {
        registeredUsers.add(Users.fromMap(element.data()));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Text(
            "Contacts",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
          child: IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SearchContacts();
              }));
            },
            icon: Icon(
              Icons.search,
              size: 30,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
            child: IconButton(
              color: Colors.white,
              onPressed: () {},
              icon: Icon(
                Icons.person_add_alt,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      List<Widget> contactWidgets = [];
                      bool contactMatched = false;

                      for (var phone in contacts[index].phones ?? []) {
                        String contactPhoneNumber = phone.value;
                        String last7DigitsContact = contactPhoneNumber
                            .substring(
                              max(0, contactPhoneNumber.length - 7),
                            )
                            .toLowerCase();

                        for (var user in registeredUsers) {
                          String userPhoneNumber = user.phoneNumber;
                          String last7DigitsUser = userPhoneNumber
                              .substring(
                                max(0, userPhoneNumber.length - 7),
                              )
                              .toLowerCase();

                          if (last7DigitsContact == last7DigitsUser) {
                            contactWidgets.add(
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 33,
                                  backgroundImage:
                                      NetworkImage(user.profilePic!),
                                ),
                                title: Text(
                                  user.name!,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(user.phoneNumber),
                              ),
                            );
                            contactMatched = true;
                            break;
                          }
                        }
                      }

                      if (!contactMatched) {
                        // This contact did not match any registered user, so display it.
                        contactWidgets.add(
                          ListTile(
                            trailing: CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 25,
                              child: Center(
                                child: Text("Invite",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 33,
                              child: Center(
                                child:
                                    Text("${contacts[index].displayName![0]}"),
                              ),
                            ),
                            title: Text(
                              contacts[index].displayName ?? 'Unknown Contact',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              contacts[index].phones?.isNotEmpty == true
                                  ? contacts[index]
                                          .phones!
                                          .elementAt(0)
                                          .value ??
                                      "Not Found Phone Number"
                                  : "Not Found",
                            ),
                          ),
                        );
                      }

                      return Stack(
                        children: contactWidgets,
                      );
                    },
                  )),
            ),
    );
  }
}
