import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:techintern_app_project/models/trainee.dart';
import 'package:techintern_app_project/screens/trainee_screens/home_category.dart';
import 'package:techintern_app_project/widgets/dispaly_posts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(230),
          child: AppBar(
            backgroundColor: Colors.white,
            toolbarHeight: 230,
            automaticallyImplyLeading: true,
            elevation: 0,
            flexibleSpace: Container(
              width: 100,
              height: 230,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 45, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hello,',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 30),
                      child: Text(
                        loggedInTrainee.name.toString(),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 25),
                      ),
                    ),
                    buildTracks(),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: DisplayPosts(traineeId: loggedInTrainee.uid.toString()));
  }

  Widget buildTracks() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(27, 20, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => HomeCategoryScreen(
                            text: 'Database',
                            uid: loggedInTrainee.uid.toString(),
                            traineeId: loggedInTrainee.uid.toString())));
                  },
                  child: const Image(
                    image: AssetImage('assets/images/database.png'),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const Text(
                  'Database',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFFA3A8AD),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => HomeCategoryScreen(
                            text: 'Network',
                            uid: loggedInTrainee.uid.toString(),
                            traineeId: loggedInTrainee.uid.toString())));
                  },
                  child: const Image(
                    image: AssetImage('assets/images/network.png'),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const Text(
                  'Network',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFFA3A8AD),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => HomeCategoryScreen(
                            text: 'Develop',
                            uid: loggedInTrainee.uid.toString(),
                            traineeId: loggedInTrainee.uid.toString())));
                  },
                  child: const Image(
                    image: AssetImage('assets/images/coding.png'),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const Text(
                  'Develop',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFFA3A8AD),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => HomeCategoryScreen(
                            text: 'More',
                            uid: loggedInTrainee.uid.toString(),
                            traineeId: loggedInTrainee.uid.toString())));
                  },
                  child: const Image(
                    image: AssetImage('assets/images/more.png'),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const Text(
                  'More',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFFA3A8AD),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
