// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:techintern_app_project/screens/trainee_screens/post_detailes.dart';
import 'package:techintern_app_project/screens/trainee_screens/profile_company_fromTrainee.dart';
import 'package:techintern_app_project/widgets/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayPosts extends StatelessWidget {
  final String traineeId;

  DisplayPosts({
    Key? key,
    required this.traineeId,
  }) : super(key: key);

  //image profile
  File? imageFile;
  bool showLocalFile = false;

  User? user = FirebaseAuth.instance.currentUser;

  final firestoreDB = FirebaseFirestore.instance;

  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('posts').snapshots();

  Future<void> _launchUrl(String urlString) async {
    if (await canLaunch(urlString)) {
      await launch(
        urlString,
        forceWebView: true,
      );
    } else {
      print("Can\'t Launch Url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: users,
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
                      height: 200.0,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: data.size,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 0, 15, 10),
                              child: InkWell(
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PostDetailesScreen(
                                                  postid: data.docs[index]
                                                      ['pid'])));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                      color: const Color(0xFF3C7754),
                                      width: 2,
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            15, 15, 10, 5),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfileCompanyfromTraineeScreen(
                                                                compId: data.docs[
                                                                        index]
                                                                    ['uid'])));
                                              },
                                              child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: showLocalFile
                                                      ? FileImage(imageFile!)
                                                          as ImageProvider
                                                      : data.docs[index][
                                                                      'imagePath']
                                                                  .toString() ==
                                                              ''
                                                          ? const NetworkImage(
                                                              'https://firebasestorage.googleapis.com/v0/b/techintern-app-project.appspot.com/o/user.png?alt=media&token=34eda1ec-b332-4f6a-bc00-b79328e0a428')
                                                          : NetworkImage(data
                                                              .docs[index]
                                                                  ['imagePath']
                                                              .toString())),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(15, 0, 0, 0),
                                              child: Text(
                                                data.docs[index]['companyName']
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 10, 0, 0),
                                          child: Text(
                                            data.docs[index]['titleOfTraining']
                                                .toString(),
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(5, 8, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                data.docs[index]['department']
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(5, 0, 0, 0),
                                                child: Icon(
                                                  Icons.circle,
                                                  color: Color(0xFF3C7754),
                                                  size: 5,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(5, 0, 0, 0),
                                                child: Text(
                                                  data.docs[index]
                                                          ['deliveryMethod']
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Color(0xFF3C7754),
                                                  ),
                                                ),
                                              ),
                                              if (data.docs[index]['salary'].toString().isNotEmpty)
                                                (const Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(5, 0, 0, 0),
                                                  child: Icon(
                                                    Icons.circle,
                                                    color: Color(0xFF3C7754),
                                                    size: 5,
                                                  ),
                                                )),
                                              if (data.docs[index]['salary'].toString().isNotEmpty)
                                                (const Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(5, 0, 0, 0),
                                                  child: Text(
                                                    'Salary',
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Color(0xFF3C7754),
                                                    ),
                                                  ),
                                                )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 10, 0, 0),
                                          child: Text(
                                            data.docs[index]['description']
                                                .toString(),
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.people,
                                              color: Color(0xFFA3A8AD),
                                              size: 20,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(5, 0, 0, 0),
                                              child: Text(
                                                data.docs[index]['numOfTrainee']
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                              child: IconButton(
                                                iconSize: 40,
                                                icon: const Icon(
                                                  Icons.attach_file,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                                onPressed: () async {
                                                  String? uId = user!.uid;
                                                  if (uId != null) {
                                                    final pdfRefs =
                                                        await firestoreDB
                                                            .collection("cvs")
                                                            .doc(uId)
                                                            .get();

                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                PdfViewer(pdfRefs
                                                                        .data()![
                                                                    'pdf_url'])));
                                                  }
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                data.docs[index]['time']
                                                    .toString(),
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })))
            ]);
      },
    );
  }
}
