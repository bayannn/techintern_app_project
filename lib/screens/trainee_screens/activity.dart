import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:techintern_app_project/models/trainee.dart';
import 'package:techintern_app_project/screens/trainee_screens/track.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  Trainee loggedInTrainee = Trainee();

  //image profile
  File? imageFile;
  bool showLocalFile = false;

  final Stream<QuerySnapshot> posts =
      FirebaseFirestore.instance.collection('posts').snapshots();

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("trainee")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInTrainee = Trainee.fromMap(value.data());
      setState(() {});
    });
    }

  final Stream<QuerySnapshot> applicant =
      FirebaseFirestore.instance.collection('applicant').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 90,
        elevation: 0,
        title: const Text(
          'Activity',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      backgroundColor: Colors.white,
      body: searchPost()
    );
  }

  Widget searchPost() {
    return StreamBuilder<QuerySnapshot>(
        stream: applicant,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          final data = snapshot.requireData;
          return SizedBox(
              height: 800.0,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    if (data.docs[index]['uid'].toString().contains(loggedInTrainee.uid.toString())) {
                      return displayOffers(data.docs[index]['pid'].toString());
                    }
                    return const Text('');
                  }));
        });
  }

  Widget displayOffers(String pots) {
    return StreamBuilder<QuerySnapshot>(
      stream: posts,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        final data = snapshot.requireData;
        return Expanded(
                  child: SizedBox(
                      height: 200.0,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: data.size,
                          itemBuilder: (context, index) {
                            if (data.docs[index]['pid']
                                .toString().contains(pots)) {
                              return (Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 0, 5, 0),
                                child: ListTile(
                                  leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                backgroundImage: showLocalFile
                    ? FileImage(imageFile!) as ImageProvider
                    : data.docs[index]['imagePath'].toString() == ''
                        ? const NetworkImage(
                            'https://firebasestorage.googleapis.com/v0/b/techintern-app-project.appspot.com/o/user.png?alt=media&token=34eda1ec-b332-4f6a-bc00-b79328e0a428')
                        : NetworkImage(data.docs[index]['imagePath'].toString())),
                                  title: Text(data.docs[index]['companyName'].toString()),
                                  subtitle: Text(
                                      data.docs[index]['titleOfTraining'].toString()),
                                  trailing: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) => TrackScreen(postId: data.docs[index]['pid'].toString(), user: loggedInTrainee,)));
                                      },
                                      icon: const Icon(
                                        Icons.chevron_right,
                                      )),
                                ),
                              ));
                            }
                            return const Text('');
                          })));
      },
    );
  }
}
