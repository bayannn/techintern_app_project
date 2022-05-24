// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:techintern_app_project/models/users.dart';
import 'package:techintern_app_project/widgets/message_textfield.dart';
import 'package:techintern_app_project/widgets/single_message.dart';

class Chatting extends StatelessWidget {
  final UserModel currentUser;
  final String friendId;
  final String friendName;
  final String friendPhoto;

  Chatting({
    Key? key,
    required this.currentUser,
    required this.friendId,
    required this.friendName,
    required this.friendPhoto,
  }) : super(key: key);

  final style = const TextStyle(color: Colors.black, fontSize: 20);

  File? imageFile;
  bool showLocalFile = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Row(children: [
          CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              backgroundImage: showLocalFile
                  ? FileImage(imageFile!) as ImageProvider
                  : friendPhoto == ''
                      ? const NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/techintern-app-project.appspot.com/o/user.png?alt=media&token=34eda1ec-b332-4f6a-bc00-b79328e0a428')
                      : NetworkImage(friendPhoto.toString())),
          const SizedBox(
            width: 15,
          ),
          Text(
            friendName,
            style: style,
          )
        ]),
      ),
      body: Column(children: [
        Expanded(
            child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(currentUser.uid)
                .collection('messages')
                .doc(friendId)
                .collection('chats')
                .orderBy("date", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length < 1) {
                  return const Center(
                    child: Text("Say Hi!"),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    reverse: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final doc = snapshot.data.docs[index];
                      bool isMe = doc['senderId'] == currentUser.uid;
                      return SingleMessage(
                        message: doc['message'],
                        isMe: isMe,
                        dateTime: (doc['date'] as Timestamp).toDate(),
                      );
                    });
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        )),
        MessageTextField(currentUser.uid.toString(), friendId)
      ]),
    );
  }
}
