// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:techintern_app_project/main.dart';
import 'package:techintern_app_project/models/Track.dart';
import 'package:techintern_app_project/models/company.dart';
import 'package:techintern_app_project/widgets/pdfviewer.dart';

class ApplicantScreen extends StatefulWidget {
  const ApplicantScreen({Key? key}) : super(key: key);

  @override
  _ApplicantScreenState createState() => _ApplicantScreenState();
}

class _ApplicantScreenState extends State<ApplicantScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  final firestoreDB = FirebaseFirestore.instance;

  Company loggedInCompany = Company();

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("company")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInCompany = Company.fromMap(value.data());
      setState(() {});
    });
  }

  final Stream<QuerySnapshot> posts =
      FirebaseFirestore.instance.collection('posts').snapshots();

  final Stream<QuerySnapshot> applicant =
      FirebaseFirestore.instance.collection('applicant').snapshots();

  String postid = '';

  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('trainee').snapshots();

  String traineeid = '';

  String stage = 'Scan CV';

  final Stream<QuerySnapshot> track =
      FirebaseFirestore.instance.collection('track').snapshots();

  String applied = '';
  String scannedCV = '';
  String interviwed = '';
  String accepted = '';
  String rejected = '';

  bool sorting = false;

  final Stream<QuerySnapshot> gba = FirebaseFirestore.instance
      .collection("trainee")
      .orderBy("gba", descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            toolbarHeight: 90,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              'Applicant',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            actions: [
              Row(
                children: [
                  const Text(
                    'GPA',
                    style: TextStyle(color: Colors.black),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          sorting = true;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_downward,
                        color: Colors.black,
                      ))
                ],
              )
            ]),
        body: searchPost());
  }

  Widget building(String traineeid) {
    if (sorting) {
      return sort(traineeid);
    } else {
      return searchTrainee(traineeid);
    }
  }

  Widget searchPost() {
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
        return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(height: 10.0),
              Expanded(
                  child: SizedBox(
                      height: 300.0,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: data.size,
                          itemBuilder: (context, index) {
                            if (data.docs[index]['uid']
                                .toString()
                                .contains(loggedInCompany.uid.toString())) {
                              postid = data.docs[index]['pid'];
                              return (searchApply(postid));
                            }
                            return const Text('');
                          })))
            ]);
      },
    );
  }

  Widget searchApply(String postid) {
    return (StreamBuilder<QuerySnapshot>(
      stream: applicant,
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
                height: 5000.0,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      if (data.docs[index]['pid'].toString().contains(postid)) {
                        traineeid = data.docs[index]['uid'];
                        return building(traineeid);
                      }
                      return const Text('No applicant yet');
                    })));
      },
    ));
  }

  Widget searchTrainee(String traineeid) {
    return (StreamBuilder<QuerySnapshot>(
      stream: users,
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
                height: 1000.0,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          buildList(
                              data.docs[index]['uid'].toString(),
                              data.docs[index]['imagePath'].toString(),
                              data.docs[index]['name'].toString(),
                              data.docs[index]['department'].toString()),
                        ],
                      );
                    })));
      },
    ));
  }

  Widget buildList(
      String traineeId, String img, String nameTrainee, String dep) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: const Color(0xFF3C7754),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
          child: ListTile(
            leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: img == ''
                    ? const NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/techintern-app-project.appspot.com/o/user.png?alt=media&token=34eda1ec-b332-4f6a-bc00-b79328e0a428')
                    : NetworkImage(img)),
            title: Text(
              nameTrainee,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('$dep student'),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Column(
                      children: [
                        searchTrack(traineeId),
                        RaisedButton(
                          onPressed: () async {
                            final pdfRefs = await firestoreDB
                                .collection("cvs")
                                .doc(traineeId)
                                .get();

                            final pdfUrl = pdfRefs.data()!['pdf_url'];
                            if (pdfUrl != null) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => PdfViewer(pdfUrl)));
                            }
                          },
                          color: const Color(0xFF3C7754),
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              70, 5, 70, 5),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text('View Resume',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        RaisedButton(
                          onPressed: () {
                            UpdatetrackToFirestore(traineeId);
                          },
                          color: const Color(0xFF3C7754),
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              49, 5, 49, 5),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Text('Next Stage $stage',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        RaisedButton(
                          onPressed: () {
                            UpdateRejecttrackToFirestore(traineeId);
                          },
                          color: Colors.red,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              90, 5, 90, 5),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text('REJECT',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchTrack(String uid) {
    return StreamBuilder<QuerySnapshot>(
        stream: track,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          final data = snapshot.requireData;
          return SizedBox(
              height: 1.0,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    if (data.docs[index]['pid'].toString().contains(postid) &&
                        data.docs[index]['uid'].toString().contains(uid)) {
                      applied = data.docs[index]['applied'].toString();
                      scannedCV = data.docs[index]['scannedCV'].toString();
                      interviwed = data.docs[index]['interviwed'].toString();
                      accepted = data.docs[index]['accepted'].toString();
                      rejected = data.docs[index]['rejected'].toString();

                      return const Text('');
                    }
                    return const Text('');
                  }));
        });
  }

  Widget sort(String traineeid) {
    return (StreamBuilder<QuerySnapshot>(
      stream: gba,
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
                height: 1000.0,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          buildList(
                              data.docs[index]['uid'].toString(),
                              data.docs[index]['imagePath'].toString(),
                              data.docs[index]['name'].toString(),
                              data.docs[index]['department'].toString()),
                        ],
                      );
                    })));
      },
    ));
  }

  UpdatetrackToFirestore(String uid) async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    Track track = Track();

    // writing all the values
    track.traineeId = uid;
    track.postId = postid;

    if (applied.toString() == 'true' &&
        scannedCV.toString() == 'false' &&
        interviwed.toString() == 'false' &&
        accepted.toString() == 'false' &&
        rejected.toString() == 'false') {
      track.scannedCV = true;
      track.applied = true;
      track.interviwed = false;
      track.accepted = false;
      track.rejected = false;

      setState(() {
        stage = 'Interviwe';
      });
    }

    if (applied.toString() == 'true' &&
        scannedCV.toString() == 'true' &&
        interviwed.toString() == 'false' &&
        accepted.toString() == 'false' &&
        rejected.toString() == 'false') {
      track.interviwed = true;
      track.scannedCV = true;
      track.applied = true;
      track.accepted = false;
      track.rejected = false;
      setState(() {
        stage = 'Accept';
      });
    }
    if (applied.toString() == 'true' &&
        scannedCV.toString() == 'true' &&
        interviwed.toString() == 'true' &&
        track.accepted.toString() == 'false' &&
        track.rejected.toString() == 'false') {
      track.accepted = true;
      track.scannedCV = true;
      track.applied = true;
      track.interviwed = true;
      track.rejected = false;
      setState(() {
        stage = 'DONE';
      });
    }

    await firebaseFirestore
        .collection('track')
        .doc(track.traineeId)
        .update(track.toMap());

    Fluttertoast.showToast(msg: "track update successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false);
  }

  UpdateRejecttrackToFirestore(String uid) async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    Track track = Track();

    // writing all the values
    track.traineeId = uid;
    track.postId = postid;

    track.rejected = true;
    track.applied = true;

    if (scannedCV.toString() == 'true') {
      track.scannedCV = true;
    }
    if (scannedCV.toString() == 'false') {
      track.scannedCV = false;
    }

    if (interviwed.toString() == 'true') {
      track.interviwed = true;
    }
    if (interviwed.toString() == 'false') {
      track.interviwed = false;
    }

    track.accepted = false;

    await firebaseFirestore
        .collection('track')
        .doc(track.traineeId)
        .update(track.toMap());

    Fluttertoast.showToast(msg: "track update successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false);
  }
}
