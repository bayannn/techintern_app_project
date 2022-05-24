// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:techintern_app_project/main.dart';
import 'package:techintern_app_project/models/company.dart';
import 'package:techintern_app_project/models/posts.dart';
import 'package:techintern_app_project/screens/trainee_screens/profile_trainee.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
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

  // our form key
  final _formKey = GlobalKey<FormState>();

  // editing Controller
  final descriptionController = TextEditingController();
  final responsibiliesController = TextEditingController();
  final titleOfTrainingController = TextEditingController();
  final numOfTraineeController = TextEditingController();
  final locationController = TextEditingController();
  DateTime startDate = DateTime(2022);
  DateTime endDate = DateTime(2022);
  String deliveryMethod = '';
  int id_Radio = 1;

  // drop down lists

  //Department list
  List<String> depList = ['IT', 'CS', 'IS'];
  String selectdep = 'IT';

  //Salary list
  List<String> salaryList = ['0-500SR',
    '500-1000SR',
    '1000-1500SR',
    '1500-2000SR',
    '2000-2500SR',
    '2500-3000SR',
    '3000-3500SR',
    '3500-4000SR'];
  String selectsalary = '0-500SR';


  // chickbox lists

  //languages list
  List<String> filtersProgrammingLanguage = <String>[];
  List<String> programmingLanguage = <String>[
    'HTML',
    'Java',
    'Python',
    'Flutter',
    'CSS',
    'JavaScript',
    'MySQL'
  ];

  //skills list
  List<String> filtersSepcialization = <String>[];
  List<String> sepcialization = <String>[
    'IT',
    'Developer',
    'Computer',
    'Python',
    'Network',
    'Database',
    'Cyber Security',
    'CS',
    'IS'
  ];

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

      if (kDebugMode) {
        print(url);
      }
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
    //description field
    final descriptionField = TextFormField(
        autofocus: false,
        controller: descriptionController,
        keyboardType: TextInputType.multiline,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Description");
          }
          // reg expression for email validation
          if (!RegExp(r'^.{20,}$').hasMatch(value)) {
            return ("Enter Valid Description");
          }
          return null;
        },
        onSaved: (value) {
          descriptionController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.description,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Description",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF3C7754))),
        ));

    //responsibilies field
    final responsibiliesField = TextFormField(
        autofocus: false,
        controller: responsibiliesController,
        keyboardType: TextInputType.multiline,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Responsibilies");
          }
          // reg expression for email validation
          if (!RegExp(r'^.{25,}$').hasMatch(value)) {
            return ("Enter Valid Responsibilies");
          }
          return null;
        },
        onSaved: (value) {
          responsibiliesController.text = value!;
        },
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.task,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Responsibilies",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF3C7754))),
        ));

    //location field
    final locationField = TextFormField(
        autofocus: false,
        controller: locationController,
        keyboardType: TextInputType.streetAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Location");
          }
          // reg expression for email validation
          if (!RegExp(
                  r'/^https?\:\/\/(www\.|maps\.)?google(\.[a-z]+){1,2}\/maps\/?\?([^&]+&)*(ll=-?[0-9]{1,2}\.[0-9]+,-?[0-9]{1,2}\.[0-9]+|q=[^&]+)+($|&)/')
              .hasMatch(value)) {
            return ("Enter Valid Location");
          }
          return null;
        },
        onSaved: (value) {
          locationController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            CupertinoIcons.location,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Company Location",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF3C7754))),
        ));

    //titleOfTraining field
    final titleOfTrainingField = TextFormField(
        autofocus: false,
        controller: titleOfTrainingController,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Title Of Training");
          }
          // reg expression for email validation
          if (!RegExp(r'^.{3,}$').hasMatch(value)) {
            return ("Enter Valid Title Of Training");
          }
          return null;
        },
        onSaved: (value) {
          titleOfTrainingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.title,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Title Of Training",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF3C7754))),
        ));

    //numOfTrainee field
    final numOfTraineeField = TextFormField(
        autofocus: false,
        controller: numOfTraineeController,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Number Of Trainee");
          }
          // reg expression for email validation
          if (!RegExp(r'\d || (unlimit)').hasMatch(value)) {
            return ("Enter Valid Number Of Trainee");
          }
          return null;
        },
        onSaved: (value) {
          numOfTraineeController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.people,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Number Of Trainee",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF3C7754))),
        ));

    //post button
    final postButton = Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(5),
      color: const Color(0xff3B7753),
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 160,
          onPressed: () {
            postDetailsToFirestore();
          },
          child: const Text(
            "POST",
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
                    const ProfileTraineeScreen()));
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
        elevation: 0,
        title: const Text(
          'New Post',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/post.png",
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 25),
                  const Text('Enter your Training Information here',
                      style: TextStyle(
                          color: Color.fromARGB(255, 84, 87, 85),
                          fontSize: 18)),
                  const SizedBox(height: 30),
                  titleOfTrainingField,
                  const SizedBox(height: 20),
                  descriptionField,
                  const SizedBox(height: 20),
                  responsibiliesField,
                  const SizedBox(height: 30),
                  const Text(
                    'Programming Language',
                    style: TextStyle(
                        color: Color.fromARGB(255, 117, 116, 116),
                        fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Wrap(children: checkCheipsProgrammingLanguage.toList()),
                  const SizedBox(height: 10),
                  Text('Selected: ${filtersProgrammingLanguage.join(', ')}'),
                  const SizedBox(height: 30),
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
                  const Text(
                    'Period of Training',
                    style: TextStyle(
                        color: Color.fromARGB(255, 117, 116, 116),
                        fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.44,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFCFD4DB),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                12, 5, 12, 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Start Date',
                                  style: TextStyle(
                                    color: Color(0xFF57636C),
                                    fontSize: 16,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.date_range_outlined,
                                      color: Color(0xFF57636C), size: 24),
                                  onPressed: () async {
                                    DateTime? newDate = await showDatePicker(
                                      context: context, 
                                      initialDate: startDate, 
                                      firstDate: DateTime(1900), 
                                      lastDate: DateTime(2300)
                                    );
                                    if (newDate != null){
                                      setState(() {
                                        startDate = newDate;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.44,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFCFD4DB),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              12, 5, 12, 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'End Date',
                                style: TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Color(0xFF57636C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.date_range_outlined,
                                    color: Color(0xFF57636C), size: 24),
                                onPressed: () async {
                                    DateTime? newDate = await showDatePicker(
                                      context: context, 
                                      initialDate: endDate, 
                                      firstDate: DateTime(1900), 
                                      lastDate: DateTime(2300)
                                    );
                                    if (newDate != null){
                                      setState(() {
                                        endDate = newDate;
                                      });
                                    }}
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  locationField,
                  const SizedBox(height: 20),
                  buildRadio(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.money,
                        color: Color.fromARGB(255, 117, 116, 116),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Salary',
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
                              value: selectsalary,
                              onChanged: (value) {
                                setState(() {
                                  (value) =>
                                      value == null ? 'field required' : null;
                                  selectsalary = value.toString();
                                });
                              },
                              items: salaryList.map((itemone) {
                                return DropdownMenuItem(
                                    value: itemone, child: Text(itemone));
                              }).toList(),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  numOfTraineeField,
                  const SizedBox(height: 30),
                  const Text(
                    'Sepcialization',
                    style: TextStyle(
                        color: Color.fromARGB(255, 117, 116, 116),
                        fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Wrap(children: checkCheipsSepcialization.toList()),
                  const SizedBox(height: 10),
                  Text('Selected: ${filtersSepcialization.join(', ')}'),
                  const SizedBox(height: 35),
                  buildPfButton(),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 60, 0, 80),
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
                          child: postButton,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  Iterable<Widget> get checkCheipsProgrammingLanguage sync* {
    for (String i in programmingLanguage) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          label: Text(i.toString()),
          selected: filtersProgrammingLanguage.contains(i.toString()),
          selectedColor: const Color(0xFF3C7754),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                filtersProgrammingLanguage.add(i.toString());
              } else {
                filtersProgrammingLanguage.removeWhere((String name) {
                  return name == i.toString();
                });
              }
            });
          },
        ),
      );
    }
  }

  Iterable<Widget> get checkCheipsSepcialization sync* {
    for (String i in sepcialization) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          label: Text(i.toString()),
          selected: filtersSepcialization.contains(i.toString()),
          selectedColor: const Color(0xFF3C7754),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                filtersSepcialization.add(i.toString());
              } else {
                filtersSepcialization.removeWhere((String name) {
                  return name == i.toString();
                });
              }
            });
          },
        ),
      );
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    Posts newPost = Posts();

    if (id_Radio == 1) {
      deliveryMethod = 'Online';
    } else if (id_Radio == 2) {
      deliveryMethod = 'Attendence';
    }

    // writing all the values
    newPost.pid = user!.uid;
    newPost.uid = loggedInCompany.uid;
    newPost.companyName = loggedInCompany.name;
    newPost.city = loggedInCompany.city;
    newPost.titleOfTraining = titleOfTrainingController.text;
    newPost.description = descriptionController.text;
    newPost.responsibilies = responsibiliesController.text;
    newPost.programmingLang = filtersProgrammingLanguage
        .toString()
        .replaceAll("[", "")
        .replaceAll("]", "");
    newPost.department = selectdep;
    newPost.city = locationController.text;
    newPost.deliveryMethod = deliveryMethod;
    newPost.salary = selectsalary;
    newPost.numOfTrainee = numOfTraineeController.text;
    newPost.sepcialization = filtersSepcialization
        .toString()
        .replaceAll("[", "")
        .replaceAll("]", "");
    newPost.imagePath = loggedInCompany.imagePath;
    newPost.time = '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
    newPost.sDate = '${startDate.day}/${startDate.month}/${startDate.year}';
    newPost.eDate = '${endDate.day}/${endDate.month}/${endDate.year}';
    newPost.pdfPath = url;

    await firebaseFirestore
        .collection("posts")
        .doc(newPost.pid)
        .set(newPost.toMap());

    Fluttertoast.showToast(msg: "Post Added successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false);
  }

  Widget buildRadio() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(width: 2),
            const Icon(
              Icons.online_prediction,
              color: Color.fromARGB(255, 117, 116, 116),
            ),
            const SizedBox(width: 10),
            const Text(
              'Delivery Method:',
              style: TextStyle(
                  color: Color.fromARGB(255, 117, 116, 116), fontSize: 16),
            ),
            const SizedBox(width: 7),
            Radio(
              value: 1,
              activeColor: const Color(0xFF3C7754),
              groupValue: id_Radio,
              onChanged: (val) {
                setState(() {
                  id_Radio = 1;
                });
              },
            ),
            const Text(
              'Online',
              style: TextStyle(fontSize: 14.0),
            ),
            Radio(
              value: 2,
              activeColor: const Color(0xFF3C7754),
              groupValue: id_Radio,
              onChanged: (val) {
                setState(() {
                  id_Radio = 2;
                });
              },
            ),
            const Text(
              'Attendence',
              style: TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildPfButton() => Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xff3B7753),
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 200,
          onPressed: () {getfile();},
          child: Row(children: const <Widget>[
            Icon(
              CupertinoIcons.doc_circle_fill,
              size: 30,
              color: Colors.white,
            ),
            VerticalDivider(width: 15),
            Text(
              'Training Plan',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            VerticalDivider(width: 160),
            Icon(
              CupertinoIcons.xmark,
              size: 20,
              color: Colors.white,
            ),
          ]),
        ),
      );
}
