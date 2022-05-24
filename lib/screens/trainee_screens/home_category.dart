// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:techintern_app_project/main.dart';
import 'package:techintern_app_project/screens/trainee_screens/post_detailes.dart';
import 'package:techintern_app_project/screens/trainee_screens/profile_company_fromTrainee.dart';
import 'package:techintern_app_project/widgets/pdfviewer.dart';

class HomeCategoryScreen extends StatelessWidget {
  final String text; final String uid;
  final String traineeId;

  HomeCategoryScreen({Key? key, required this.text, required this.uid, required this.traineeId}) : super(key: key);

  User? user = FirebaseAuth.instance.currentUser;

  final firestoreDB = FirebaseFirestore.instance;
  
  final Stream<QuerySnapshot> posts =
      FirebaseFirestore.instance.collection('posts').snapshots();

  //image profile
  File? imageFile;
  bool showLocalFile = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 90,
        automaticallyImplyLeading: true,
        leading: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
          child: IconButton(
            hoverColor: Colors.transparent,
            iconSize: 60,
            icon: const Icon(
              Icons.chevron_left,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const MainPage()));
            },
          ),
        ),
        title: Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
        actions: const [],
        centerTitle: true,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: displayPosts(context),
    );
  }

  Widget displayPosts(BuildContext context) {
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
                      height: 200.0,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: data.size,
                          itemBuilder: (context, index) {
                            if(data.docs[index]['sepcialization'].toString().contains(text)) {
                              return (
                                Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15, 0, 15, 10),
                                child: InkWell(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PostDetailesScreen(postid: data.docs[index]['pid'].toString())));
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
                              )
                            );
                            }
                            return const Text('No post in this catogery yet');
                          })))
            ]);
      },
    );
  }
}
