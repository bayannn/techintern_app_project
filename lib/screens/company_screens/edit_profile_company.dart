import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:techintern_app_project/main.dart';
import 'package:techintern_app_project/models/company.dart';
import 'package:techintern_app_project/models/users.dart';
import 'package:techintern_app_project/screens/company_screens/profile_company.dart';
import 'package:techintern_app_project/screens/company_screens/profile_menu_company.dart';

class EditProfileCompanyScreen extends StatefulWidget {
  const EditProfileCompanyScreen({Key? key}) : super(key: key);

  @override
  _EditProfileCompanyScreenState createState() =>
      _EditProfileCompanyScreenState();
}

class _EditProfileCompanyScreenState extends State<EditProfileCompanyScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  Company loggedInCompany = Company();
  UserModel userModel = UserModel();

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

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      userModel = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  // our form key
  final _formKey = GlobalKey<FormState>();

  // editing Controller
  final nameController = TextEditingController();
  final aboutController = TextEditingController();
  final descripeController = TextEditingController();
  final linkController = TextEditingController();
  final branchController = TextEditingController();

  // drop down lists

  //city list
  List<String> cityList = [
    'Abha',
    'Buraydah',
    'Al Bahah',
    'Dammam',
    'Dhahran',
    'Diriyah',
    'Al Jawf',
    'Jeddah',
    'Jizan',
    'Khobar',
    'Mecca',
    'Medina',
    'Najran',
    'Ar Rass',
    'Riyadh',
    'Taif',
    'Tabuk',
    'Yanbu'
  ];
  String selectcity = 'Jeddah';

  //image profile
  File? imageFile;
  bool showLocalFile = false;
  String profilePhoto = '';

  pickImageFromGallery() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (xFile == null) return;

    final tempImage = File(xFile.path);

    imageFile = tempImage;
    showLocalFile = true;
    setState(() {});

    // upload to firebase storage

    ProgressDialog progressDialog = ProgressDialog(
      context,
      title: const Text('Uploading !!!'),
      message: const Text('Please wait'),
    );
    progressDialog.show();
    try {
      var fileName = userModel.email! + '.jpg';

      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(fileName)
          .putFile(imageFile!);

      TaskSnapshot snapshot = await uploadTask;

      String profileImageUrl = await snapshot.ref.getDownloadURL();

      profilePhoto = profileImageUrl;

      if (kDebugMode) {
        print(profileImageUrl);
      }

      progressDialog.dismiss();
    } catch (e) {
      progressDialog.dismiss();

      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  pickImageFromCamera() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (xFile == null) return;

    final tempImage = File(xFile.path);

    imageFile = tempImage;
    showLocalFile = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //name field
    final nameField = TextFormField(
        autofocus: false,
        controller: nameController,
        keyboardType: TextInputType.name,
        validator: (value) {
          // reg expression for email validation
          if (!RegExp(r'^.{3,}$').hasMatch(value!)) {
            return ("Enter Valid Name(Min. 3 Character)");
          }
          return loggedInCompany.name;
        },
        onSaved: (value) {
          nameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.contact_page,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: loggedInCompany.name,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF3C7754))),
        ));

    //about field
    final aboutField = TextFormField(
        autofocus: false,
        controller: aboutController,
        keyboardType: TextInputType.multiline,
        onSaved: (value) {
          aboutController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.text_fields,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: loggedInCompany.about,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF3C7754))),
        ));

    //descripe field
    final descripeField = TextFormField(
        autofocus: false,
        controller: descripeController,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          descripeController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.text_fields,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: loggedInCompany.descripe,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF3C7754))),
        ));

    //link field
    final linkField = TextFormField(
        autofocus: false,
        controller: linkController,
        keyboardType: TextInputType.number,
        onSaved: (value) {
          linkController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.link,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: loggedInCompany.link,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF3C7754))),
        ));

    //branch field
    final branchField = TextFormField(
        autofocus: false,
        controller: branchController,
        keyboardType: TextInputType.number,
        onSaved: (value) {
          branchController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            CupertinoIcons.building_2_fill,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: loggedInCompany.branch,
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
                builder: (BuildContext context) =>
                    const ProfileCompanyScreen()));
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
                        const ProfileMenuCompanyScreen()));
              },
            ),
          ),
          elevation: 0,
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        backgroundImage: showLocalFile
                            ? FileImage(imageFile!) as ImageProvider
                            : userModel.imagePath == ''
                                ? const NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/techintern-app-project.appspot.com/o/user.png?alt=media&token=34eda1ec-b332-4f6a-bc00-b79328e0a428')
                                : NetworkImage(userModel.imagePath.toString())),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 200),
                    child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.image),
                                        title: const Text('From Gallery'),
                                        onTap: () {
                                          pickImageFromGallery();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.camera_alt),
                                        title: const Text('From Camera'),
                                        onTap: () {
                                          pickImageFromCamera();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }),
                  ),
                  /*Center(
                    child: Stack(
                      children: [
                        Center(
                          child: Material(
                              color: Colors.transparent,
                              child: image != null
                                  ? Image.file(
                                      image!,
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                    )
                                  : Image.asset(
                                      "assets/images/user.png",
                                      fit: BoxFit.cover,
                                      color: Colors.black,
                                      width: 100,
                                      height: 100,
                                    )),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 130,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: const Color(0xFF3C7754),
                              ),
                              child: IconButton(
                                iconSize: 20,
                                icon:
                                    const Icon(Icons.edit, color: Colors.white),
                                onPressed: () {
                                  buildButtonSheet();
                                },
                              ),
                            )),
                      ],
                    ),
                  ),*/
                  const Divider(
                      height: 80,
                      thickness: 6,
                      color: Color.fromARGB(255, 240, 241, 239)),
                  titleOfTextField('Name'),
                  nameField,
                  const SizedBox(height: 20),
                  titleOfTextField('Company Description in one sentence'),
                  descripeField,
                  const SizedBox(height: 20),
                  titleOfTextField("About"),
                  aboutField,
                  const Divider(
                      height: 80,
                      thickness: 6,
                      color: Color.fromARGB(255, 240, 241, 239)),
                  const Text(
                    'Personal Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.location_city,
                        color: Color.fromARGB(255, 117, 116, 116),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'City',
                        style: TextStyle(
                            color: Color.fromARGB(255, 117, 116, 116),
                            fontSize: 16),
                      ),
                      const SizedBox(width: 20),
                      DecoratedBox(
                          decoration: const ShapeDecoration(
                            color: Colors.white30,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Color(0xFFB4B7BA),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 0.0),
                            child: DropdownButton(
                              value: selectcity,
                              onChanged: (value) {
                                setState(() {
                                  (value) =>
                                      value == null ? 'field required' : null;
                                  selectcity = value.toString();
                                });
                              },
                              items: cityList.map((itemone) {
                                return DropdownMenuItem(
                                    value: itemone, child: Text(itemone));
                              }).toList(),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  titleOfTextField("Company URL official website"),
                  linkField,
                  const SizedBox(height: 20),
                  titleOfTextField("Company branch"),
                  branchField,
                  const Divider(
                      height: 80,
                      thickness: 6,
                      color: Color.fromARGB(255, 240, 241, 239)),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 60, 0, 20),
                    child: Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                          child: cancelButton,
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                          child: saveButton,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ))));
  }

  updateDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    // writing all the values
    if (nameController.text.isNotEmpty) {
      userModel.name = nameController.text;
    }
    userModel.city = selectcity;
    userModel.imagePath = profilePhoto;

    if (nameController.text.isNotEmpty) {
      loggedInCompany.name = nameController.text;
    }
    loggedInCompany.city = selectcity;
    if (aboutController.text.isNotEmpty) {
      loggedInCompany.about = aboutController.text;
    }
    if (descripeController.text.isNotEmpty) {
      loggedInCompany.descripe = descripeController.text;
    }
    if (linkController.text.isNotEmpty) {
      loggedInCompany.link = linkController.text;
    }
    if (branchController.text.isNotEmpty) {
      loggedInCompany.branch = branchController.text;
    }
    loggedInCompany.imagePath = profilePhoto;

    await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .update(userModel.toMap());

    await firebaseFirestore
        .collection("company")
        .doc(user!.uid)
        .update(loggedInCompany.toMap());
    Fluttertoast.showToast(msg: "Account update successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false);
  }

  Widget titleOfTextField(String text) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
        child: Text(
          text,
          style: const TextStyle(
              color: Color.fromARGB(255, 84, 87, 85), fontSize: 16),
        ),
      );
}
