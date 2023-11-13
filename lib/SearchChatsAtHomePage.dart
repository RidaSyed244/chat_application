import 'package:chat_application/FetchData.dart';
import 'package:chat_application/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

List<Users> allchatUsers = [];
final getChatUsers =
    FirebaseFirestore.instance.collection("Users").get().then((value) {
  value.docs.forEach((element) {
    allchatUsers.add(Users.fromMap(element.data()));
  });
});
final chatStream = FutureProvider((ref) => getChatUsers);

class SearchChats extends ConsumerStatefulWidget {
  const SearchChats({super.key});

  @override
  ConsumerState<SearchChats> createState() => _SearchChatsState();
}

class _SearchChatsState extends ConsumerState<SearchChats> {
  String searchUserForChat = '';
  List searchedChatUsers = [];
  searchChatUserss(String searchQuery) {
    setState(() {
      searchUserForChat = searchQuery;
      searchedChatUsers = allchatUsers
          .where((users) => users.name!
              .toLowerCase()
              .startsWith(searchUserForChat.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchChats = ref.watch(chatStream);
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
                onChanged: searchChatUserss,
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
            if (searchUserForChat.isNotEmpty)
              Expanded(
                child: searchChats.when(
                  data: (data) {
                    return ListView.builder(
                        itemCount: allchatUsers.length,
                        itemBuilder: (context, index) {
                          final chats = allchatUsers[index];
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 8),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MessageScreen(
                                                  name: chats.name.toString(),
                                                  profilePic: chats.profilePic
                                                      .toString(),
                                                  email: chats.email.toString(),
                                                  uid: chats.uid.toString(),
                                                  phoneNumber:
                                                      chats.phoneNumber.toString(),
                                                )));
                                  },
                                  leading: CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        NetworkImage(chats.profilePic!),
                                  ),
                                  title: Text(chats.name!,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  error: (error, stackTrace) => Text('Error: $error'),
                  loading: () => Center(child: CircularProgressIndicator()),
                ),
              )
          ],
        ),
      ),
    );
  }
}
