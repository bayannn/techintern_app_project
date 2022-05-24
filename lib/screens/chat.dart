import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:techintern_app_project/models/users.dart';
import 'package:techintern_app_project/screens/chat_search.dart';
import 'package:techintern_app_project/screens/chatting.dart';

class ChatScreen extends StatefulWidget {
  final UserModel user;

  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final styleT = const TextStyle(color: Colors.black);

  //image profile
  File? imageFile;
  bool showLocalFile = false;

  final style = const TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages', style: style),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 25),
              child: GestureDetector(
                onTap: () async {
                  final user = widget.user;
                  if (user != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChatSearchScreen(user: user)));
                  }
                },
                child: const Icon(
                  Icons.search,
                  size: 26.0,
                ),
              ))
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.user.uid)
              .collection('messages')
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length < 1) {
                return const Center(
                  child: Text("No chats Available"),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    var friendId = snapshot.data.docs[index].id;
                    var lastMsg = snapshot.data.docs[index]['last_msg'];
                    var lastDate =
                        (snapshot.data.docs[index]['last_date'] as Timestamp)
                            .toDate();
                    return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(friendId)
                            .get(),
                        builder: (context, AsyncSnapshot asyncSnapshot) {
                          if (asyncSnapshot.hasData) {
                            var friend = asyncSnapshot.data;
                            return ListTile(
                              leading: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  backgroundImage: showLocalFile
                                      ? FileImage(imageFile!) as ImageProvider
                                      : friend['imagePath'] == ''
                                          ? const NetworkImage(
                                              'https://firebasestorage.googleapis.com/v0/b/techintern-app-project.appspot.com/o/user.png?alt=media&token=34eda1ec-b332-4f6a-bc00-b79328e0a428')
                                          : NetworkImage(
                                              friend['imagePath'])),
                              title: Text(friend['name']),
                              subtitle: Text(
                                "$lastMsg",
                                style: const TextStyle(color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                DateFormat("dd/MM/yy HH:mm").format(lastDate),
                                style: const TextStyle(color: Colors.grey),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Chatting(
                                            currentUser: widget.user,
                                            friendId: friend['uid'],
                                            friendName: friend['name'],
                                            friendPhoto: friend['imagePath'])));
                              },
                            );
                          }
                          return const Text('');
                        });
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3C7754),
        child: const Icon(Icons.chat_rounded),
        onPressed: () async {
          final user = widget.user;
          if (user != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatSearchScreen(user: user)));
          }
        },
      ),
    );
  }
}
