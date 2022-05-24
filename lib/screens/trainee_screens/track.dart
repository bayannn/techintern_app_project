// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:techintern_app_project/main.dart';
import 'package:techintern_app_project/models/Review.dart';
import 'package:techintern_app_project/models/trainee.dart';
import 'package:techintern_app_project/screens/trainee_screens/post_detailes.dart';
import 'package:techintern_app_project/widgets/pdfviewer.dart';

class TrackScreen extends StatelessWidget {
  final Trainee user;
  final String postId;
  final reviewController = TextEditingController();

  TrackScreen({Key? key, required this.user, required this.postId})
      : super(key: key);

  //image profile
  File? imageFile;
  bool showLocalFile = false;

  String applied = '';
  String rejected = '';
  String accepted = '';
  String scannedCV = '';
  String interviwed = '';
  String coId = '';

  final Stream<QuerySnapshot> posts =
      FirebaseFirestore.instance.collection('posts').snapshots();

  final Stream<QuerySnapshot> track =
      FirebaseFirestore.instance.collection('track').snapshots();

  final firestoreDB = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 90,
          automaticallyImplyLeading: true,
          title: const Text(
            'Track Status',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder<QuerySnapshot>(
            stream: posts,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            height: 160.0,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: data.size,
                                itemBuilder: (context, index) {
                                  if (data.docs[index]['pid']
                                      .toString()
                                      .contains(postId)) {
                                    coId = data.docs[index]['uid'].toString();
                                    return (Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 20),
                                        Center(
                                          child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: showLocalFile
                    ? FileImage(imageFile!) as ImageProvider
                    : data.docs[index]['imagePath'].toString() == ''
                        ? const NetworkImage(
                            'https://firebasestorage.googleapis.com/v0/b/techintern-app-project.appspot.com/o/user.png?alt=media&token=34eda1ec-b332-4f6a-bc00-b79328e0a428')
                        : NetworkImage(data.docs[index]['imagePath'].toString())),
                                        ),
                                        const SizedBox(height: 20),
                                        buildName(
                                            data.docs[index]['companyName']
                                                .toString(),
                                            data.docs[index]['department']
                                                .toString()),
                                        const SizedBox(height: 20),
                                        buildOfferDetail(context),
                                        if (data.docs[index]['eDate']
                                                .toString() !=
                                            '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}')
                                          (buildCvButton(user, context)),
                                        if (data.docs[index]['eDate']
                                                .toString() ==
                                            '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}')
                                          (buildTextFieldReview(context)),
                                        const Divider(
                                            height: 80,
                                            thickness: 8,
                                            color: Color.fromARGB(
                                                255, 240, 241, 239)),
                                        const Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 20, 0, 20),
                                          child: Text(
                                            'Process',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        buildStatus(),
                                      ],
                                    ));
                                  }
                                  return const Text(
                                      '');
                                })))
                  ]);
            }));
  }

  Widget buildStatus() {
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
              height: 400.0,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    if (data.docs[index]['pid'].toString().contains(postId) &&
                        data.docs[index]['uid']
                            .toString()
                            .contains(user.uid.toString())) {
                      return Column(children: [
                        Stack(children: [
                          Container(
                            margin: const EdgeInsets.only(left: 58, top: 40),
                            width: 4,
                            height: 280,
                            color: Colors.grey,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                statusWidget(
                                    'Apply to training', "Applied", true),
                                if (data.docs[index]['scannedCV'].toString() ==
                                    'true')
                                  (statusWidget('Scanning Resumes',
                                      "Scanned Resumes", true)),
                                if (data.docs[index]['scannedCV'].toString() ==
                                    'false')
                                  (statusWidget('Scanning Resumes',
                                      "Scanned Resumes", false)),
                                if (data.docs[index]['interviwed'].toString() ==
                                    'true')
                                  (statusWidget(
                                      'Interview', "Interviewed", true)),
                                if (data.docs[index]['interviwed'].toString() ==
                                    'false')
                                  (statusWidget(
                                      'Interview', "Interviewed", false)),
                                if (data.docs[index]['accepted'].toString() ==
                                    'true')
                                  (statusWidget('Accepting', "Accepted", true)),
                                if (data.docs[index]['accepted'].toString() ==
                                    'false')
                                  (statusWidget(
                                      'Accepting', "Accepted", false)),
                                if (data.docs[index]['rejected'].toString() ==
                                    'true')
                                  (statusWidget('Rejecting', "Rejected", true)),
                                if (data.docs[index]['rejected'].toString() ==
                                    'false')
                                  (statusWidget(
                                      'Rejecting', "Rejected", false)),
                              ])
                        ]),
                        const SizedBox(height: 30),
                      ]);
                    }
                    return const Text('');
                  }));
        });
  }

  Widget buildCvButton(Trainee user, BuildContext context) => Container(
        padding: const EdgeInsetsDirectional.fromSTEB(25, 30, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resume',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 40, 0),
              child: RaisedButton(
                onPressed: () async {
                  String? uId = user.uid;
                  if (uId != null) {
                    final pdfRefs =
                        await firestoreDB.collection("cvs").doc(uId).get();
                        
                        Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => PdfViewer(pdfRefs.data()!['pdf_url'])));
                  }
                },
                color: const Color.fromARGB(255, 178, 187, 182),
                padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      CupertinoIcons.doc_circle_fill,
                      size: 40,
                      color: Colors.black38,
                    ),
                    const VerticalDivider(width: 15),
                    Text('CV of ${user.name}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.black38,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildTextFieldReview(BuildContext context) => Container(
        padding: const EdgeInsetsDirectional.fromSTEB(25, 30, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 40, 0),
              child: TextFormField(
                  autofocus: false,
                  controller: reviewController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  onSaved: (value) {
                    reviewController.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: 'Write your opinion',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Color(0xFF3C7754))),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 260),
              child: RaisedButton(
                onPressed: () {
                  postRDetailsToFirestore(context);
                },
                color: const Color(0xFF3C7754),
                padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: const Text('Send',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );

  Widget buildOfferDetail(BuildContext context) => Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => PostDetailesScreen(
                    postid: postId,)));
          },
          color: const Color(0xFF3C7754),
          padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: const Text('SEE OFFER DETAIL',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
      );

  Widget buildName(String companyName, String postDepartment) => Column(
        children: [
          Text(
            companyName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            '$postDepartment department',
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Container statusWidget(String bStatus, String aStatus, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isActive)
                    ? const Color(0xFF3C7754)
                    : const Color.fromARGB(255, 181, 179, 179),
                border: Border.all(
                    color: (isActive)
                        ? const Color.fromARGB(92, 167, 199, 180)
                        : const Color.fromARGB(142, 179, 190, 184),
                    width: 3)),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            (isActive) ? aStatus : bStatus,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  postRDetailsToFirestore(BuildContext context) async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    Review review = Review();

    // writing all the values
    review.companyId = coId;
    review.postId = postId;
    review.traineeId = user.uid;
    review.opinion = reviewController.text;

    await firebaseFirestore
        .collection("review")
        .doc('${user.uid}' + '$postId')
        .set(review.toMap());

    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false);
  }
}
