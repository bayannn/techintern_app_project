// ignore_for_file: file_names, no_logic_in_create_state

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:techintern_app_project/screens/company_screens/profile_menu_company.dart';
import 'package:techintern_app_project/widgets/pdfviewer.dart';
import 'package:techintern_app_project/widgets/profile_tapbar.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileCompanyfromTraineeScreen extends StatefulWidget {
  final String compId;
  const ProfileCompanyfromTraineeScreen({Key? key, required this.compId}) : super(key: key);

  @override
  _ProfileCompanyfromTraineeScreenState createState() => _ProfileCompanyfromTraineeScreenState(compId);
}

class _ProfileCompanyfromTraineeScreenState extends State<ProfileCompanyfromTraineeScreen> {

  //image profile
  File? imageFile;
  bool showLocalFile = false;

  final firestoreDB = FirebaseFirestore.instance;

  String traineeName = '';
  String postTitle = '';

  int _pageIndex = 0;

  String cid = '';

  String imagePath = '';
  String name = '';
  String descripe = '';
  String about = '';
  String link = '';
  String city = '';
  String phone = '';
  String email = '';

  _ProfileCompanyfromTraineeScreenState(String compId){
    cid = compId;
    searchcomp();
  }

  final Stream<QuerySnapshot> company =
      FirebaseFirestore.instance.collection('company').snapshots();

  Widget searchcomp() {
    return (StreamBuilder<QuerySnapshot>(
      stream: company,
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
                height: 0.0,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      if (data.docs[index]['uid'].toString() == cid) {
                        imagePath = data.docs[index]['imagePath'];
                        name = data.docs[index]['name'];
                        descripe = data.docs[index]['descripe'];
                        about = data.docs[index]['about'];
                        link = data.docs[index]['link'];
                        city = data.docs[index]['city'];
                        phone = data.docs[index]['phone'];
                        email = data.docs[index]['email'];

                        return const Text('');
                      }
                      return const Text('');
                    })));
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(300),
          child: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: true,
            elevation: 0,
            flexibleSpace: Container(
              width: 100,
              height: 300,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Center(
                    child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: showLocalFile
                            ? FileImage(imageFile!) as ImageProvider
                            : imagePath == ''
                                ? const NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/techintern-app-project.appspot.com/o/user.png?alt=media&token=34eda1ec-b332-4f6a-bc00-b79328e0a428')
                                : NetworkImage(
                                    imagePath)),
                  ),
                  const SizedBox(height: 20),
                  buildName(),
                  ProfileTabBar(
                    height: 50,
                    onTap: (value) {
                      setState(() {
                        _pageIndex = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  CupertinoIcons.list_dash,
                  size: 25,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const ProfileMenuCompanyScreen()));
                },
              ),
            ],
          ),
        ),
        body: Row(
          children: [
            if (_pageIndex == 0) (displayPosts()),
            if (_pageIndex == 1) (displayApout()),
          ],
        )
        );
  }

  final Stream<QuerySnapshot> posts =
      FirebaseFirestore.instance.collection('posts').snapshots();

  Widget displayApout() {
    return Expanded(
      child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          buildAbout(),
          const Divider(
              height: 80,
              thickness: 6,
              color: Color.fromARGB(255, 240, 241, 239)),
          buildInfo(),
          const Divider(
              height: 80,
              thickness: 6,
              color: Color.fromARGB(255, 240, 241, 239)),
          //searchReview(),
          const Divider(height: 80, color: Color.fromARGB(255, 240, 241, 239)),
        ],
      ),
    ));
  }

  Widget displayPosts() {
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
                  child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: data.size,
                          itemBuilder: (context, index) {
                            if (data.docs[index]['uid'].toString() ==
                                cid) {
                              return (Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15, 0, 15, 10),
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
                                        Text(
                                          data.docs[index]['titleOfTraining']
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
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
                                                  String uId = data.docs[index]['pid'].toString();
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
                              ));
                            }
                            return const Text('No post in this catogery yet');
                          }))
            ]);
      },
    );
  }

  Widget buildName() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            descripe,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildAbout() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              about,
              style: const TextStyle(fontSize: 16, height: 1.2),
            ),
          ],
        ),
      );

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

  Widget buildInfo() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Company Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            buildIconText(CupertinoIcons.envelope,
                const Color.fromARGB(255, 94, 92, 92), 20, 'Email'),
            const SizedBox(height: 6),
            buildInfoInfo(email),
            const Divider(
                height: 20,
                thickness: 2,
                indent: 10,
                endIndent: 10,
                color: Color.fromARGB(255, 240, 241, 239)),
            buildIconText(CupertinoIcons.phone,
                const Color.fromARGB(255, 94, 92, 92), 20, 'Phone'),
            const SizedBox(height: 6),
            buildInfoInfo(phone),
            const Divider(
                height: 20,
                thickness: 2,
                indent: 10,
                endIndent: 10,
                color: Color.fromARGB(255, 240, 241, 239)),
            buildIconText(
                CupertinoIcons.link,
                const Color.fromARGB(255, 94, 92, 92),
                20,
                "Company's official website"),
            const SizedBox(height: 6),
            InkWell(
              onTap: () async {
                _launchUrl(link);
              },
              child: buildInfoInfo(link),
            ),
            const Divider(
                height: 20,
                thickness: 2,
                indent: 10,
                endIndent: 10,
                color: Color.fromARGB(255, 240, 241, 239)),
            buildIconText(CupertinoIcons.location,
                const Color.fromARGB(255, 94, 92, 92), 20, 'Domicile'),
            const SizedBox(height: 6),
            buildInfoInfo('$city, Saudi Arabia'),
          ],
        ),
      );

  Widget buildInfoInfo(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(color: Color.fromARGB(255, 92, 90, 90)),
            ),
          ],
        ),
      );

  Widget buildTextTextRate(String text1, String text2) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(
          children: <Widget>[
            Text(
              text1,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const VerticalDivider(width: 5),
            Text(
              text2,
              style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ],
        ),
      );

  Widget buildIconText(IconData icon, Color color, double s, String text) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: color,
              size: s,
            ),
            const VerticalDivider(width: 20),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      );

  final Stream<QuerySnapshot> trainee =
      FirebaseFirestore.instance.collection('trainee').snapshots();

  Widget searchTrainee(String traineeid, String opinion) {
    return (StreamBuilder<QuerySnapshot>(
      stream: trainee,
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
                      if (data.docs[index]['uid'].toString() == traineeid) {
                        return buildReview(data.docs[index]['name'].toString(),
                            postTitle, opinion);
                      }
                      return const Text('');
                    })));
      },
    ));
  }

  final Stream<QuerySnapshot> review =
      FirebaseFirestore.instance.collection('review').snapshots();

  Widget searchReview() {
    return (StreamBuilder<QuerySnapshot>(
      stream: review,
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
                      if (data.docs[index]['uidC']
                          .toString()==cid ) {
                        return searchTrainee(
                            data.docs[index]['uidT'].toString(),
                            data.docs[index]['opinion'].toString());
                      }
                      return const Text('');
                    })));
      },
    ));
  }

  Widget buildReview(String nameT, titleP, comment) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reviews',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            buildTextTextRate(nameT, -titleP),
            const SizedBox(height: 6),
            Text(
              comment,
              style: const TextStyle(color: Color.fromARGB(255, 71, 69, 69)),
            ),
            const Divider(
              height: 40,
              thickness: 2,
              indent: 10,
              endIndent: 10,
              color: Color(0xff3B7753),
            ),
          ],
        ),
      );
}
