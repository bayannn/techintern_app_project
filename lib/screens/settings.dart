import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:techintern_app_project/main.dart';
import 'package:techintern_app_project/models/company.dart';
import 'package:techintern_app_project/models/trainee.dart';
import 'package:techintern_app_project/models/users.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  Trainee loggedInTrainee = Trainee();
  Company loggedInCompany = Company();
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  // string for displaying the error Message
  String? errorMessage;

  bool dontshowPassword = true;
  bool dontshowConfirmPassword = true;

  bool push = true;
  bool newOffer = true;
  bool status = false;
  bool message = true;
  bool sound = true;
  bool vibrate = false;

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value!)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.mail,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: loggedInUser.email,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF3C7754))),
        ));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: dontshowPassword,
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if (!regex.hasMatch(value!)) {
            return ("Enter Valid Password");
          }
          return null;
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.vpn_key,
            color: Colors.grey,
          ),
          suffixIcon: InkWell(
            onTap: () => setState(
              () => dontshowPassword = !dontshowPassword,
            ),
            child: Icon(
              dontshowPassword ? Icons.visibility_off : Icons.visibility,
              color: dontshowPassword ? Colors.grey : const Color(0xff3B7753),
              size: 22,
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF3C7754))),
        ));

    //confirm password field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: dontshowConfirmPassword,
        validator: (value) {
          if (confirmPasswordController.text != passwordController.text) {
            return "Password don't match";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.vpn_key,
            color: Colors.grey,
          ),
          suffixIcon: InkWell(
            onTap: () => setState(
              () => dontshowConfirmPassword = !dontshowConfirmPassword,
            ),
            child: Icon(
              dontshowConfirmPassword ? Icons.visibility_off : Icons.visibility,
              color: dontshowConfirmPassword
                  ? Colors.grey
                  : const Color(0xff3B7753),
              size: 22,
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF3C7754))),
        ));

    //phone field
    final phoneField = TextFormField(
        autofocus: false,
        controller: phoneController,
        keyboardType: TextInputType.phone,
        validator: (value) {
          // reg expression for email validation
          if (!RegExp(
                  r"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$")
              .hasMatch(value!)) {
            return ("Enter Valid Phone(10 Character)");
          }
          return null;
        },
        onSaved: (value) {
          phoneController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.phone,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: loggedInUser.phone,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF3C7754))),
        ));

    //save button
    final saveButton = Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(5),
      color: const Color(0xff3B7753),
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 160,
          onPressed: () {
            updateDetailsToFirestore();
          },
          child: const Text(
            "SAVE",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, color: Colors.white),
          )),
    );

    //cancel button
    final cancelButton = Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 160,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const MainPage()));
          },
          child: const Text(
            "CANCEL",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              color: Color(0xff3B7753),
            ),
          )),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 90,
        automaticallyImplyLeading: true,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Row(
              children: const [
                Icon(
                  Icons.person,
                  color: Color(0xff3B7753),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Account Settings",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(height: 20),
            emailField,
            const SizedBox(height: 15),
            phoneField,
            /*const SizedBox(height: 15),
            passwordField,
            const SizedBox(height: 10),
            confirmPasswordField,*/

            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
              child: Row(
                children: const [
                  Icon(
                    Icons.notifications,
                    color: Color(0xff3B7753),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Notifications Settings",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(height: 20),
            const Text(
              'General Notitfication',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SwitchListTile(
              value: push,
              onChanged: (newValue) => setState(() => push = newValue),
              title: const Text(
                'Push Notification',
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              activeColor: const Color(0xFF3C7754),
              tileColor: Colors.white,
              dense: false,
              controlAffinity: ListTileControlAffinity.trailing,
            ),
            SwitchListTile(
              value: newOffer,
              onChanged: (newValue) => setState(() => newOffer = newValue),
              title: const Text(
                'New Offer Notification',
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              activeColor: const Color(0xFF3C7754),
              tileColor: Colors.white,
              dense: false,
              controlAffinity: ListTileControlAffinity.trailing,
            ),
            SwitchListTile(
              value: status,
              onChanged: (newValue) => setState(() => status = newValue),
              title: const Text(
                'Applied Statues Notification',
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              activeColor: const Color(0xFF3C7754),
              tileColor: Colors.white,
              dense: false,
              controlAffinity: ListTileControlAffinity.trailing,
            ),
            const SizedBox(height: 20),
            const Text(
              'Message Notitfication',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SwitchListTile(
              value: message,
              onChanged: (newValue) => setState(() => message = newValue),
              title: const Text(
                'Message',
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              activeColor: const Color(0xFF3C7754),
              tileColor: Colors.white,
              dense: false,
              controlAffinity: ListTileControlAffinity.trailing,
            ),
            const SizedBox(height: 20),
            const Text(
              'App Notitfication',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SwitchListTile(
              value: sound,
              onChanged: (newValue) => setState(() => sound = newValue),
              title: const Text(
                'Sound',
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              activeColor: const Color(0xFF3C7754),
              tileColor: Colors.white,
              dense: false,
              controlAffinity: ListTileControlAffinity.trailing,
            ),
            SwitchListTile(
              value: vibrate,
              onChanged: (newValue) => setState(() => vibrate = newValue),
              title: const Text(
                'Vibrate',
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              activeColor: const Color(0xFF3C7754),
              tileColor: Colors.white,
              dense: false,
              controlAffinity: ListTileControlAffinity.trailing,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 60, 0, 20),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                    child: cancelButton,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                    child: saveButton,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  updateDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    // writing all the values
    if (emailController.text.isNotEmpty) {
      loggedInUser.email = emailController.text;
    }

    if (phoneController.text.isNotEmpty) {
      loggedInUser.phone = phoneController.text;
    }

    await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .update(loggedInUser.toMap());

    if (loggedInUser.type == 'trainee') {
      // writing all the values
      if (emailController.text.isNotEmpty) {
        loggedInTrainee.email = emailController.text;
      }

      if (phoneController.text.isNotEmpty) {
        loggedInTrainee.phone = phoneController.text;
      }

      await firebaseFirestore
          .collection("trainee")
          .doc(user!.uid)
          .update(loggedInTrainee.toMap());
    }

    if (loggedInUser.type == 'company') {
      // writing all the values
      if (emailController.text.isNotEmpty) {
        loggedInCompany.email = emailController.text;
      }

      if (phoneController.text.isNotEmpty) {
        loggedInCompany.phone = phoneController.text;
      }

      await firebaseFirestore
          .collection("company")
          .doc(user!.uid)
          .update(loggedInCompany.toMap());
    }

    Fluttertoast.showToast(msg: "Account update successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false);
  }
}
