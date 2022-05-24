import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:techintern_app_project/main.dart';
import 'package:techintern_app_project/models/track.dart';
import 'package:techintern_app_project/models/apply.dart';
import 'package:techintern_app_project/screens/trainee_screens/activity.dart';

class ApplyScreen extends StatelessWidget {
  final String postId;
  final String traineeId;
  final String traineeGpa;
  final String traineeCv;
  final String traineeSkills;

  ApplyScreen(
      {Key? key,
      required this.postId,
      required this.traineeId,
      required this.traineeGpa,
      required this.traineeCv,
      required this.traineeSkills})
      : super(key: key);

  applyToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    Applicant apply = Applicant();

    // writing all the values
    apply.pid = postId;
    apply.traineesId = traineeId;

    await firebaseFirestore
        .collection("applicant")
        .doc('${apply.traineesId}'+'${apply.traineesId}')
        .set(apply.toMap());

    Fluttertoast.showToast(msg: "applicant Added successfully :) ");
  }

  trackToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    Track track = Track();

    // writing all the values
    track.traineeId = traineeId;
    track.postId = postId;
    track.applied = true;
    track.rejected = false;
    track.accepted = false;
    track.interviwed = false;
    track.scannedCV = false;

    await firebaseFirestore
        .collection('track')
        .doc(track.traineeId)
        .set(track.toMap());

    Fluttertoast.showToast(msg: "track Added successfully :) ");
  }

  @override
  Widget build(BuildContext context) {
    if (traineeGpa.isNotEmpty &&
        traineeCv.isNotEmpty &&
        traineeSkills.isNotEmpty) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF3C7754),
                  size: 100,
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                  child: Text(
                    'Succesful Applied',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Text(
                    'We Will inform you about the next information, pleasw sit tight',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 200, 0, 0),
                  child: RaisedButton(
                    onPressed: () {
                      applyToFirestore();
                      trackToFirestore();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const ActivityScreen()));
                    },
                    color: const Color(0xFF3C7754),
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(80, 15, 80, 15),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: const Text('SEE YOUR STATUS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                  child: InkWell(
                    onTap: () async {
                      applyToFirestore();
                      trackToFirestore();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => const MainPage()));
                    },
                    child: const Text(
                      'GO TO HOME',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3C7754),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(60, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.xmark_circle_fill,
                  color: Colors.red,
                  size: 100,
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                  child: Text(
                    'Failed Applied',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Text(
                    'Please check about Resume\n You must enter it in your profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 200, 0, 0),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => const MainPage()));
                    },
                    color: Colors.red,
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(80, 15, 80, 15),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: const Text('BACK TO HOME',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ));
    }
  }
}
