// ignore_for_file: must_be_immutable, no_logic_in_create_state, deprecated_member_use

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:techintern_app_project/models/trainee.dart';
import 'package:techintern_app_project/screens/trainee_screens/apply.dart';
import 'package:techintern_app_project/widgets/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetailesScreen extends StatefulWidget {
  String postid;

  PostDetailesScreen(
      {Key? key,
      required this.postid, pid})
      : super(key: key);

  @override
  _PostDetailesScreenState createState() => _PostDetailesScreenState(postid);
}

class _PostDetailesScreenState extends State<PostDetailesScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  final firestoreDB = FirebaseFirestore.instance;

  Trainee loggedInTrainee = Trainee();

  String pid = '';

  _PostDetailesScreenState(String postid){
    pid = postid;
  }

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

  final Stream<QuerySnapshot> posts =
      FirebaseFirestore.instance.collection('posts').snapshots();

  Future<void> _launchUrl(String urlString) async {
    if (await canLaunch(urlString)) {
      await launch(
        urlString,
        forceWebView: true,
      );
    } else {
      if (kDebugMode) {
        print("Can't Launch Url");
      }
    }
  }

  //cv profile
  File? file;
  String url = "";
  String name = '';

  getfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );

    if (result != null) {
      File c = File(result.files.single.path.toString());
      setState(() {
        file = c;
        name = result.names.toString();
      });
      uploadFile();
    }
  }

  uploadFile() async {
    try {
      var imagefile =
          FirebaseStorage.instance.ref().child("Users").child("/$name");
      UploadTask task = imagefile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      if (url != null && file != null) {
        Fluttertoast.showToast(
          msg: "Done Uploaded",
          textColor: Colors.red,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Something went wrong",
          textColor: Colors.red,
        );
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        textColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 90,
        automaticallyImplyLeading: true,
        elevation: 0,
        title: const Text(
          'Post Detailes',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
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
                          height: 200.0,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: data.size,
                              itemBuilder: (context, index) {
                                if (data.docs[index]['pid'].toString() == pid) {
                                  List<String> proLang = data.docs[index]
                                          ['programmingLang']
                                      .toString()
                                      .split(',');
                                  List<String> spec = data.docs[index]
                                          ['sepcialization']
                                      .toString()
                                      .split(',');
                                  return (Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            10, 25, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              buildInfo(
                                                  'Title of training',
                                                  data.docs[index]
                                                          ['titleOfTraining']
                                                      .toString()),
                                              const Divider(
                                                  height: 80,
                                                  thickness: 8,
                                                  color: Color.fromARGB(
                                                      255, 240, 241, 239)),
                                              buildInfo(
                                                  'Description',
                                                  data.docs[index]
                                                          ['description']
                                                      .toString()),
                                              const Divider(
                                                  height: 80,
                                                  thickness: 8,
                                                  color: Color.fromARGB(
                                                      255, 240, 241, 239)),
                                              buildInfo(
                                                  'Responsiblities',
                                                  data.docs[index]
                                                          ['responsibilies']
                                                      .toString()),
                                              const Divider(
                                                  height: 80,
                                                  thickness: 8,
                                                  color: Color.fromARGB(
                                                      255, 240, 241, 239)),
                                              buildInfo(
                                                  'Programming Languages', ''),
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: <Widget>[
                                                    for (var i in proLang)
                                                      chipForRow(i.toString()),
                                                  ],
                                                ),
                                              ),
                                              const Divider(
                                                  height: 80,
                                                  thickness: 8,
                                                  color: Color.fromARGB(
                                                      255, 240, 241, 239)),
                                              const Text(
                                                'Additional Information',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 30),
                                              buildInfo(
                                                  'Department',
                                                  data.docs[index]['department']
                                                      .toString()),
                                              const Divider(
                                                  height: 20,
                                                  thickness: 2,
                                                  indent: 20,
                                                  endIndent: 60,
                                                  color: Color.fromARGB(
                                                      255, 240, 241, 239)),
                                              buildInfo(
                                                      'City',
                                                      data.docs[index]
                                                              ['city']
                                                          .toString()),
                                              const Divider(
                                                  height: 20,
                                                  thickness: 2,
                                                  indent: 20,
                                                  endIndent: 60,
                                                  color: Color.fromARGB(
                                                      255, 240, 241, 239)),
                                              buildInfo(
                                                  'Delivery Method',
                                                  data.docs[index]
                                                          ['deliveryMethod']
                                                      .toString()),
                                              const Divider(
                                                  height: 20,
                                                  thickness: 2,
                                                  indent: 20,
                                                  endIndent: 60,
                                                  color: Color.fromARGB(
                                                      255, 240, 241, 239)),
                                              buildInfo(
                                                      'Salary',
                                                      data.docs[index]
                                                              ['salary']
                                                          .toString()),
                                              const Divider(
                                                  height: 20,
                                                  thickness: 2,
                                                  indent: 20,
                                                  endIndent: 60,
                                                  color: Color.fromARGB(
                                                      255, 240, 241, 239)),
                                              buildInfo('Period of training',
                                                  'Start Date ${data.docs[index]['sDate'].toString()} - End Date ${data.docs[index]['eDate'].toString()}'),
                                              const Divider(
                                                  height: 20,
                                                  thickness: 2,
                                                  indent: 20,
                                                  endIndent: 60,
                                                  color: Color.fromARGB(
                                                      255, 240, 241, 239)),
                                              buildInfo('Seplization', ''),
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: <Widget>[
                                                    for (var i in spec)
                                                      chipForRow(i.toString()),
                                                  ],
                                                ),
                                              ),
                                              const Divider(
                                                  height: 50,
                                                  thickness: 8,
                                                  color: Color.fromARGB(
                                                      255, 240, 241, 239)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 15, 10, 15),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              IconButton(
                                                iconSize: 50,
                                                icon: const Icon(
                                                  Icons.file_present,
                                                  color: Color(0xFFA3A8AD),
                                                  size: 30,
                                                ),
                                                onPressed: () async {
                                                  String uId = pid;
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
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(20, 0, 0, 0),
                                                child: RaisedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                ApplyScreen(
                                                                  postId: pid,
                                                                  traineeCv:
                                                                      loggedInTrainee.cvPath.toString(),
                                                                  traineeGpa:
                                                                      loggedInTrainee.gba.toString(),
                                                                  traineeId:
                                                                      loggedInTrainee.uid.toString(),
                                                                  traineeSkills:
                                                                      loggedInTrainee.skills.toString(),
                                                                )));
                                                    if (kDebugMode) {
                                                      print(pid);
                                                    }
                                                  },
                                                  color:
                                                      const Color(0xFF3C7754),
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          80, 15, 80, 15),
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: const Text('APPLY NOW',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                                }
                                return const Text('Error');
                              })))
                ]);
          }),
    );
  }

  Widget buildInfo(String title, String describtion) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text(
              describtion,
              style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 74, 73, 73)),
            ),
          ],
        ),
      );

  Widget chipForRow(String label) {
    return Container(
      margin: const EdgeInsets.only(left: 6, right: 6),
      child: Chip(
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff3B7753),
        elevation: 2,
        shadowColor: Colors.grey[60],
        padding: const EdgeInsets.all(6),
      ),
    );
  }
}
