// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:techintern_app_project/models/trainee.dart';
import 'package:techintern_app_project/screens/trainee_screens/profile_menu_trainee.dart';
import 'package:techintern_app_project/widgets/pdfviewer.dart';

class ProfileTraineeScreen extends StatefulWidget {
  const ProfileTraineeScreen({Key? key}) : super(key: key);

  @override
  _ProfileTraineeScreenState createState() => _ProfileTraineeScreenState();
}

class _ProfileTraineeScreenState extends State<ProfileTraineeScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  final firestoreDB = FirebaseFirestore.instance;

  Trainee loggedInTrainee = Trainee();

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

  //image profile
  File? imageFile;
  bool showLocalFile = false;

  @override
  Widget build(BuildContext context) {
    final List<String> skill = loggedInTrainee.skills.toString().split(',');
    final List<String> Language =
        loggedInTrainee.languages.toString().split(',');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 90,
        automaticallyImplyLeading: true,
        elevation: 0,
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
                      const ProfileMenuTraineeScreen()));
            },
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Center(
            child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
                backgroundImage: showLocalFile
                    ? FileImage(imageFile!) as ImageProvider
                    : loggedInTrainee.imagePath == ''
                        ? const NetworkImage(
                            'https://firebasestorage.googleapis.com/v0/b/techintern-app-project.appspot.com/o/user.png?alt=media&token=34eda1ec-b332-4f6a-bc00-b79328e0a428')
                        : NetworkImage(loggedInTrainee.imagePath.toString())),
          ),
          const SizedBox(height: 15),
          buildName(loggedInTrainee),
          const SizedBox(height: 50),
          buildAbout(loggedInTrainee),
          const Divider(
              height: 80,
              thickness: 6,
              color: Color.fromARGB(255, 240, 241, 239)),
          buildInfo(loggedInTrainee),
          const Divider(
              height: 80,
              thickness: 6,
              color: Color.fromARGB(255, 240, 241, 239)),
          buildCvButton(loggedInTrainee),
          const Divider(
              height: 80,
              thickness: 6,
              color: Color.fromARGB(255, 240, 241, 239)),
          buildEdu(loggedInTrainee),
          const Divider(
              height: 80,
              thickness: 6,
              color: Color.fromARGB(255, 240, 241, 239)),
          buildSkills(loggedInTrainee, skill),
          const Divider(
              height: 80,
              thickness: 6,
              color: Color.fromARGB(255, 240, 241, 239)),
          buildLanguage(loggedInTrainee, Language),
          const Divider(height: 80, color: Color.fromARGB(255, 240, 241, 239)),
        ],
      ),
    );
  }

  Widget buildName(Trainee user) => Column(
        children: [
          Text(
            '${user.name}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            '${user.department} Student',
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildAbout(Trainee user) => Container(
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
              user.about.toString(),
              style: const TextStyle(fontSize: 16, height: 1.2),
            ),
          ],
        ),
      );

  Widget buildInfo(Trainee user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            buildIconText(CupertinoIcons.envelope,
                const Color.fromARGB(255, 94, 92, 92), 20, 'Email'),
            const SizedBox(height: 6),
            buildInfoInfo('${user.email}'),
            const Divider(
                height: 20,
                thickness: 2,
                indent: 10,
                endIndent: 10,
                color: Color.fromARGB(255, 240, 241, 239)),
            buildIconText(CupertinoIcons.phone,
                const Color.fromARGB(255, 94, 92, 92), 20, 'Phone'),
            const SizedBox(height: 6),
            buildInfoInfo(user.phone.toString()),
            const Divider(
                height: 20,
                thickness: 2,
                indent: 10,
                endIndent: 10,
                color: Color.fromARGB(255, 240, 241, 239)),
            buildIconText(CupertinoIcons.calendar,
                const Color.fromARGB(255, 94, 92, 92), 20, 'Date of Birth'),
            const SizedBox(height: 6),
            buildInfoInfo(user.dBirth.toString()),
            const Divider(
                height: 20,
                thickness: 2,
                indent: 10,
                endIndent: 10,
                color: Color.fromARGB(255, 240, 241, 239)),
            buildIconText(CupertinoIcons.location,
                const Color.fromARGB(255, 94, 92, 92), 20, 'Domicile'),
            const SizedBox(height: 6),
            buildInfoInfo('${user.city}, Saudi Arabia'),
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

  Widget buildCvButton(Trainee user) => Container(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resume',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 40, 0),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xff3B7753),
                child: MaterialButton(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  minWidth: 200,
                  onPressed: () async {
                    String? uId = user.uid;
                    if (uId != null) {
                      final pdfRefs =
                          await firestoreDB.collection("cvs").doc(uId).get();

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              PdfViewer(pdfRefs.data()!['pdf_url'])));
                    }
                  },
                  child: Row(children: <Widget>[
                    const Icon(
                      CupertinoIcons.doc_circle_fill,
                      size: 30,
                      color: Colors.white,
                    ),
                    const VerticalDivider(width: 15),
                    Text(
                      'CV of ${user.name}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildEdu(Trainee user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Education',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            buildIconText(Icons.school, const Color(0xFF3C7754), 40,
                user.university.toString()),
            const SizedBox(height: 6),
            buildTextText(user.faculity.toString(), 'GPA: ${user.gba}'),
            const SizedBox(height: 6),
            buildTextText(
                '${user.studydurationStart} - ${user.studydurationEnd}',
                'English Score: ${user.englishScore}'),
          ],
        ),
      );

  Widget buildSkills(Trainee user, List<String> skill) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Skills',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  for (var i in skill) chipForRow(i.toString()),
                ],
              ),
            ),
          ],
        ),
      );

  Widget buildLanguage(Trainee user, List<String> Language) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Languages',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  for (var i in Language) chipForRow(i.toString()),
                ],
              ),
            ),
          ],
        ),
      );

  Widget buildTextText(String text1, String text2) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: <Widget>[
            Text(
              text1,
              style: const TextStyle(color: Color.fromARGB(255, 92, 90, 90)),
            ),
            const VerticalDivider(width: 20),
            Expanded(
              child: Text(
                text2,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color.fromARGB(255, 92, 90, 90)),
              ),
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

  Widget chipForRow(String label) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      child: Chip(
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff3B7753),
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: const EdgeInsets.all(6.0),
      ),
    );
  }
}
