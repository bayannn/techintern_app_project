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
import 'package:file_picker/file_picker.dart';
import 'package:techintern_app_project/main.dart';
import 'package:techintern_app_project/models/trainee.dart';
import 'package:techintern_app_project/models/users.dart';
import 'package:techintern_app_project/screens/trainee_screens/profile_menu_trainee.dart';

class EditProfileTraineeScreen extends StatefulWidget {
  const EditProfileTraineeScreen({Key? key}) : super(key: key);

  @override
  _EditProfileTraineeScreenState createState() =>
      _EditProfileTraineeScreenState();
}

class _EditProfileTraineeScreenState extends State<EditProfileTraineeScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  Trainee loggedInTrainee = Trainee();
  UserModel userModel = UserModel();

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
  final universityController = TextEditingController();
  final faculityController = TextEditingController();
  final gbaController = TextEditingController();
  final englishScoreController = TextEditingController();

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

  //days list
  List<String> dayList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30'
  ];
  String selectday = '1';

  //months list
  List<String> monthList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  String selectmonth = 'January';

  //years list
  List<String> yearList = [
    '1985',
    '1986',
    '1987',
    '1988',
    '1989',
    '1990',
    '1991',
    '1992',
    '1993',
    '1994',
    '1995',
    '1996',
    '1997',
    '1998',
    '1999',
    '2000',
    '2001',
    '2002',
    '2003',
    '2004',
    '2005'
  ];
  String selectyear = '1999';

  //Department list
  List<String> depList = ['IT', 'CS', 'IS'];
  String selectdep = 'IT';

  //startStudy list
  List<String> startStudyList = [
    '1985',
    '1986',
    '1987',
    '1988',
    '1989',
    '1990',
    '1991',
    '1992',
    '1993',
    '1994',
    '1995',
    '1996',
    '1997',
    '1998',
    '1999',
    '2000',
    '2001',
    '2002',
    '2003',
    '2004',
    '2005',
    '2006',
    '2007',
    '2008',
    '2009',
    '2010',
    '2011',
    '2012',
    '2013',
    '2014',
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022'
  ];
  String selectstartStudy = '2017';

  //endStudy list
  List<String> endStudyList = [
    '1985',
    '1986',
    '1987',
    '1988',
    '1989',
    '1990',
    '1991',
    '1992',
    '1993',
    '1994',
    '1995',
    '1996',
    '1997',
    '1998',
    '1999',
    '2000',
    '2001',
    '2002',
    '2003',
    '2004',
    '2005',
    '2006',
    '2007',
    '2008',
    '2009',
    '2010',
    '2011',
    '2012',
    '2013',
    '2014',
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    'Present'
  ];
  String selectendStudy = '2022';

  // chickbox lists

  //languages list
  List<String> filtersLanguages = <String>[];
  List<String> languages = <String>[
    'Arabic',
    'English',
    'Spanish',
    'Chinese',
    'French',
  ];

  //skills list
  List<String> filtersSkills = <String>[];
  List<String> skills = <String>[
    'Leadership',
    'Self-motivation',
    'Microsoft office programs',
    'Communination',
    'Decidion making',
    'Problem solving',
    'work under pressure',
    'cooperation',
    'plan management'
  ];

  //image profile
  File? imageFile;
  bool showLocalFile = false;
  String profilePhoto = '';

  pickImageFromGallery() async {

    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if( xFile == null ) return;

    final tempImage = File(xFile.path);

    imageFile = tempImage;
    showLocalFile = true;
    setState(() {

    });

    // upload to firebase storage


    ProgressDialog progressDialog = ProgressDialog(
      context,
      title: const Text('Uploading !!!'),
      message: const Text('Please wait'),
    );
    progressDialog.show();
    try{
      var fileName = userModel.email! + '.jpg';

      UploadTask uploadTask = FirebaseStorage.instance.ref().child('profile_images').child(fileName).putFile(imageFile!);

      TaskSnapshot snapshot = await uploadTask;

      String profileImageUrl = await snapshot.ref.getDownloadURL();

      profilePhoto = profileImageUrl;

      if (kDebugMode) {
        print(profileImageUrl);
      }

      progressDialog.dismiss();

    } catch( e ){
      progressDialog.dismiss();

      if (kDebugMode) {
        print(e.toString());
      }
    }


  }

  pickImageFromCamera() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if( xFile == null ) return;

    final tempImage = File(xFile.path);

    imageFile = tempImage;
    showLocalFile = true;
    setState(() {

    });
  }

  //cv profile
  File? file;
  String url = "";
  var name;
  
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

      print(url);
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
          return loggedInTrainee.name;
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
          hintText: loggedInTrainee.name,
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
          hintText: loggedInTrainee.about,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF3C7754))),
        ));

    //university field
    final universityField = TextFormField(
        autofocus: false,
        controller: universityController,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          universityController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.school,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: loggedInTrainee.university,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF3C7754))),
        ));

    //faculity field
    final faculityField = TextFormField(
        autofocus: false,
        controller: faculityController,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          faculityController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            CupertinoIcons.person_3_fill,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: loggedInTrainee.faculity,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF3C7754))),
        ));

    //gpa field
    final gpaField = TextFormField(
        autofocus: false,
        controller: gbaController,
        keyboardType: TextInputType.number,
        onSaved: (value) {
          gbaController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.grading_rounded,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: loggedInTrainee.gba.toString(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF3C7754))),
        ));

    //englishScore field
    final englishScoreField = TextFormField(
        autofocus: false,
        controller: englishScoreController,
        keyboardType: TextInputType.number,
        onSaved: (value) {
          englishScoreController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.grading_rounded,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: loggedInTrainee.englishScore,
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
                    const MainPage()));
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
                        const ProfileMenuTraineeScreen()));
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
                              backgroundImage: showLocalFile ?
                                  FileImage(imageFile!) as ImageProvider
                                  : userModel.imagePath == ''
                                  ? const NetworkImage(
                                  'https://firebasestorage.googleapis.com/v0/b/techintern-app-project.appspot.com/o/user.png?alt=media&token=34eda1ec-b332-4f6a-bc00-b79328e0a428')
                                  : NetworkImage(userModel.imagePath.toString())),
                  ),

                        Padding(
                          padding: const EdgeInsets.only(left: 200),
                          child: IconButton(icon: const Icon(Icons.camera_alt), onPressed: (){

                            showModalBottomSheet(context: context, builder: (context){
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.image),
                                      title: const Text('From Gallery'),
                                      onTap: (){
                                        pickImageFromGallery();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.camera_alt),
                                      title: const Text('From Camera'),
                                      onTap: (){

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
                  const Divider(
                      height: 80,
                      thickness: 6,
                      color: Color.fromARGB(255, 240, 241, 239)),
                  titleOfTextField('Name'),
                  nameField,
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
                  titleOfTextField('Date of Birth'),
                  Row(
                    children: [
                      const Text(
                        'Day: ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 117, 116, 116),
                            fontSize: 14),
                      ),
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
                            padding: const EdgeInsets.only(left: 7, right: 4),
                            child: DropdownButton(
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 97, 97, 98)),
                              value: selectday,
                              onChanged: (value) {
                                setState(() {
                                  (value) =>
                                      value == null ? 'field required' : null;
                                  selectday = value.toString();
                                });
                              },
                              items: dayList.map((itemone) {
                                return DropdownMenuItem(
                                    value: itemone, child: Text(itemone));
                              }).toList(),
                            ),
                          )),
                      const SizedBox(width: 17),
                      const Text(
                        'Month: ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 117, 116, 116),
                            fontSize: 14),
                      ),
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
                            padding: const EdgeInsets.only(left: 7, right: 4),
                            child: DropdownButton(
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 97, 97, 98)),
                              value: selectmonth,
                              onChanged: (value) {
                                setState(() {
                                  (value) =>
                                      value == null ? 'field required' : null;
                                  selectmonth = value.toString();
                                });
                              },
                              items: monthList.map((itemone) {
                                return DropdownMenuItem(
                                    value: itemone, child: Text(itemone));
                              }).toList(),
                            ),
                          )),
                      const SizedBox(width: 17),
                      const Text(
                        'Year: ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 117, 116, 116),
                            fontSize: 14),
                      ),
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
                            padding: const EdgeInsets.only(left: 7, right: 4),
                            child: DropdownButton(
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 97, 97, 98)),
                              value: selectyear,
                              onChanged: (value) {
                                setState(() {
                                  (value) =>
                                      value == null ? 'field required' : null;
                                  selectyear = value.toString();
                                });
                              },
                              items: yearList.map((itemone) {
                                return DropdownMenuItem(
                                    value: itemone, child: Text(itemone));
                              }).toList(),
                            ),
                          )),
                    ],
                  ),
                  const Divider(
                      height: 80,
                      thickness: 6,
                      color: Color.fromARGB(255, 240, 241, 239)),
                  const Text(
                    'Resume',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  buildCvButton(loggedInTrainee),
                  const Divider(
                      height: 80,
                      thickness: 6,
                      color: Color.fromARGB(255, 240, 241, 239)),
                  const Text(
                    'Education',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  titleOfTextField('University / School Name'),
                  universityField,
                  const SizedBox(height: 20),
                  titleOfTextField('Faculity'),
                  faculityField,
                  const SizedBox(height: 20),
                  titleOfTextField("Trainee's Major"),
                  Row(
                    children: [
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.category,
                        color: Color.fromARGB(255, 117, 116, 116),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Department',
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
                              value: selectdep,
                              onChanged: (value) {
                                setState(() {
                                  (value) =>
                                      value == null ? 'field required' : null;
                                  selectdep = value.toString();
                                });
                              },
                              items: depList.map((itemone) {
                                return DropdownMenuItem(
                                    value: itemone, child: Text(itemone));
                              }).toList(),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        'Study Duration: ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 117, 116, 116),
                            fontSize: 16),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'from: ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 117, 116, 116),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
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
                            padding: const EdgeInsets.only(left: 7, right: 4),
                            child: DropdownButton(
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 97, 97, 98)),
                              value: selectstartStudy,
                              onChanged: (value) {
                                setState(() {
                                  (value) =>
                                      value == null ? 'field required' : null;
                                  selectstartStudy = value.toString();
                                });
                              },
                              items: startStudyList.map((itemone) {
                                return DropdownMenuItem(
                                    value: itemone, child: Text(itemone));
                              }).toList(),
                            ),
                          )),
                      const SizedBox(width: 12),
                      const Text(
                        'until: ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 117, 116, 116),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
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
                            padding: const EdgeInsets.only(left: 7, right: 4),
                            child: DropdownButton(
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 97, 97, 98)),
                              value: selectendStudy,
                              onChanged: (value) {
                                setState(() {
                                  (value) =>
                                      value == null ? 'field required' : null;
                                  selectendStudy = value.toString();
                                });
                              },
                              items: endStudyList.map((itemone) {
                                return DropdownMenuItem(
                                    value: itemone, child: Text(itemone));
                              }).toList(),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  titleOfTextField('GPA'),
                  gpaField,
                  const SizedBox(height: 20),
                  titleOfTextField('English Score'),
                  englishScoreField,
                  const Divider(
                      height: 80,
                      thickness: 6,
                      color: Color.fromARGB(255, 240, 241, 239)),
                  const Text(
                    'Skills',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 27),
                  Wrap(children: checkCheipsSkills.toList()),
                  const SizedBox(height: 30),
                  Text('Selected: ${filtersSkills.join(', ')}'),
                  const Divider(
                      height: 80,
                      thickness: 6,
                      color: Color.fromARGB(255, 240, 241, 239)),
                  const Text(
                    'Languages',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 27),
                  Wrap(children: checkCheipsLanguages.toList()),
                  const SizedBox(height: 30),
                  Text('Selected: ${filtersLanguages.join(', ')}'),
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

  /*void _selectItem(String name) {
    Navigator.pop(context);
    setState(() {
      selectedPickType = name;
    });
  }
}*/

  Iterable<Widget> get checkCheipsSkills sync* {
    for (String i in skills) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          label: Text(i.toString()),
          selected: filtersSkills.contains(i.toString()),
          selectedColor: const Color(0xFF3C7754),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                filtersSkills.add(i.toString());
              } else {
                filtersSkills.removeWhere((String name) {
                  return name == i.toString();
                });
              }
            });
          },
        ),
      );
    }
  }

  Iterable<Widget> get checkCheipsLanguages sync* {
    for (String i in languages) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          label: Text(i.toString()),
          selected: filtersLanguages.contains(i.toString()),
          selectedColor: const Color(0xFF3C7754),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                filtersLanguages.add(i.toString());
              } else {
                filtersLanguages.removeWhere((String name) {
                  return name == i.toString();
                });
              }
            });
          },
        ),
      );
    }
  }

  Widget buildCvButton(Trainee user) => Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xff3B7753),
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 200,
          onPressed: () {getfile();},
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
            const VerticalDivider(width: 80),
            const Icon(
              CupertinoIcons.xmark,
              size: 20,
              color: Colors.white,
            ),
          ]),
        ),
      );

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
      loggedInTrainee.name = nameController.text;
    }
    loggedInTrainee.city = selectcity;
    loggedInTrainee.dBirth = '$selectday/$selectmonth/$selectyear';
    if (universityController.text.isNotEmpty) {
      loggedInTrainee.university = universityController.text;
    }
    if (faculityController.text.isNotEmpty) {
      loggedInTrainee.faculity = faculityController.text;
    }
    loggedInTrainee.department = selectdep;
    loggedInTrainee.studydurationStart = selectstartStudy;
    loggedInTrainee.studydurationEnd = selectendStudy;
    if (gbaController.text.isNotEmpty) {
      loggedInTrainee.gba = double.parse(gbaController.text) as int?;
    }
    if (englishScoreController.text.isNotEmpty) {
      loggedInTrainee.englishScore = englishScoreController.text;
    }
    loggedInTrainee.skills = filtersSkills.toString().replaceAll("[", "").replaceAll("]","");
    loggedInTrainee.languages = filtersLanguages.toString().replaceAll("[", "").replaceAll("]",""); 
    if (aboutController.text.isNotEmpty) {
      loggedInTrainee.about = aboutController.text;
    }
    loggedInTrainee.imagePath = profilePhoto;
    loggedInTrainee.cvPath = url;

    await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .update(userModel.toMap());

    await firebaseFirestore
        .collection("trainee")
        .doc(user!.uid)
        .update(loggedInTrainee.toMap());
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
