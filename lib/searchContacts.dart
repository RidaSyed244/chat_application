import 'package:chat_application/FetchData.dart';
import 'package:chat_application/SendDataToDB.dart';
import 'package:chat_application/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getAllUsers =
    FirebaseFirestore.instance.collection("Users").get().then((value) {
  value.docs.forEach((element) {
    allContactUsers.add(Users.fromMap(element.data()));
  });
});
final userStream = FutureProvider((ref) => getAllUsers);

class SearchContacts extends ConsumerStatefulWidget {
  const SearchContacts({super.key});

  @override
  ConsumerState<SearchContacts> createState() => _SearchContactsState();
}

class _SearchContactsState extends ConsumerState<SearchContacts> {
  String searchContact = '';

  searchContacts(String searchQuery) {
    setState(() {
      searchContact = searchQuery;
      filteredUsers = allContactUsers
          .where((users) =>
              users.name!.toLowerCase().startsWith(searchContact.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final allcontacts = ref.watch(userStream);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                onChanged: searchContacts,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Search",
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  suffixIcon: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text("People",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            if (searchContact.isEmpty)
              Expanded(
                  child: allcontacts.when(data: (data) {
                return ListView.builder(
                    itemCount: allContactUsers.length,
                    itemBuilder: (context, index) {
                      final singleUser = allContactUsers[index];
                      return Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              radius: 45,
                              backgroundImage:
                                  NetworkImage(singleUser.profilePic!),
                            ),
                            subtitle: Text(singleUser.phoneNumber!),
                            title: Text(singleUser.name!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey[300],
                          )
                        ],
                      );
                    });
              }, error: (error, stackTrace) {
                return Text(error.toString());
              }, loading: () {
                return CircularProgressIndicator();
              })),
            if (searchContact.isNotEmpty)
              Expanded(
                  child: allcontacts.when(data: (data) {
                return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final singleUser = filteredUsers[index];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    NetworkImage(singleUser.profilePic!),
                              ),
                              title: Text(singleUser.name!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      );
                    });
              }, error: (error, stackTrace) {
                return Text(error.toString());
              }, loading: () {
                return CircularProgressIndicator();
              })),
          ],
        ),
      ),
    );
  }
}
