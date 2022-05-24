import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:techintern_app_project/main.dart';
import 'package:techintern_app_project/models/company.dart';
import 'package:techintern_app_project/screens/company_screens/edit_profile_company.dart';
import 'package:techintern_app_project/screens/company_screens/profile_company.dart';
import 'package:techintern_app_project/screens/help.dart';
import 'package:techintern_app_project/screens/login.dart';
import 'package:techintern_app_project/screens/settings.dart';

class ProfileMenuCompanyScreen extends StatefulWidget {
  const ProfileMenuCompanyScreen({Key? key}) : super(key: key);

  @override
  _ProfileMenuCompanyScreenState createState() => _ProfileMenuCompanyScreenState();
}

class _ProfileMenuCompanyScreenState extends State<ProfileMenuCompanyScreen> {
  User? user = FirebaseAuth.instance.currentUser;

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

  //image profile
  File? imageFile;
  bool showLocalFile = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  builder: (BuildContext context) =>
                      const MainPage()));
            }
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          buildImageName(loggedInCompany),
          buildEditButton(),
          const Divider(
              height: 80,
              thickness: 8,
              color: Color.fromARGB(255, 240, 241, 239)),
          buildMenu(),
        ],
      ),
    );
  }

  Widget buildImageName(Company user) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
                backgroundImage: showLocalFile
                    ? FileImage(imageFile!) as ImageProvider
                    : loggedInCompany.imagePath == ''
                        ? const NetworkImage(
                            'https://firebasestorage.googleapis.com/v0/b/techintern-app-project.appspot.com/o/user.png?alt=media&token=34eda1ec-b332-4f6a-bc00-b79328e0a428')
                        : NetworkImage(loggedInCompany.imagePath.toString())),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                    child: Text(
                      user.name.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(2, 3, 0, 10),
                    child: Text(
                      user.email.toString(),
                      style: const TextStyle(color: Color(0xFFA3A8AD)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget buildEditButton() => Center(
          child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xff3B7753),
        child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            minWidth: 170,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const EditProfileCompanyScreen()));
            },
            child: const Text(
              "EDIT PROFILE",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.white),
            )),
      ));

  Widget buildMenu() => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 5, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const SettingsScreen()));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Icon(
                        Icons.settings_outlined,
                        color: Color(0xFF534F4F),
                        size: 24,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          'Setting',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF534F4F),
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(35, 10, 0, 0),
                    child: Text(
                      'Account information, Notifications',
                      style: TextStyle(
                          color: Color.fromARGB(255, 133, 132, 132),
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
                height: 30,
                thickness: 2,
                indent: 10,
                endIndent: 10,
                color: Color.fromARGB(255, 240, 241, 239)),
            InkWell(
              onTap: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const HelpScreen()));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Icon(
                        Icons.help_outline_outlined,
                        color: Color(0xFF534F4F),
                        size: 24,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          'Help',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF534F4F),
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(35, 10, 0, 0),
                    child: Text(
                      'Contact Us',
                      style: TextStyle(
                          color: Color.fromARGB(255, 133, 132, 132),
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
                height: 30,
                thickness: 2,
                indent: 10,
                endIndent: 10,
                color: Color.fromARGB(255, 240, 241, 239)),
            InkWell(
              onTap: () async {
                logout(context);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 24,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(35, 10, 0, 0),
                    child: Text(
                      'Exit from your account',
                      style: TextStyle(
                          color: Color.fromARGB(255, 133, 132, 132),
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
