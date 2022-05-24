import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:techintern_app_project/main.dart';
import 'package:techintern_app_project/models/trainee.dart';
import 'package:techintern_app_project/models/users.dart';
import 'package:techintern_app_project/screens/register_type.dart';
import 'package:techintern_app_project/screens/trainee_screens/profile_trainee.dart';

class RegisterTraineeScreen extends StatefulWidget {
  const RegisterTraineeScreen({Key? key}) : super(key: key);

  @override
  _RegisterTraineeScreenState createState() => _RegisterTraineeScreenState();
}

class _RegisterTraineeScreenState extends State<RegisterTraineeScreen> {
  // firebase
  final _auth = FirebaseAuth.instance;

  // our form key
  final _formKey = GlobalKey<FormState>();

  // editing Controller
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final universityController = TextEditingController();
  final faculityController = TextEditingController();
  final gbaController = TextEditingController();

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

  // string for displaying the error Message
  String? errorMessage;

  bool dontshowPassword = true;
  bool dontshowConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    UserModel user = UserModel();
    //name field
    final nameField = TextFormField(
        autofocus: false,
        controller: nameController,
        keyboardType: TextInputType.name,
        validator: (value) {
          return user.validName(value);
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
          hintText: "Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF3C7754))),
        ));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          return user.validEmail(value);
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
          hintText: "Email",
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
          return user.validpass(value);
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
          return user.validConfirmpass(confirmPasswordController.text, passwordController.text);
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
          return user.validPhone(value);
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
          hintText: "Phone",
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
          hintText: "University Name",
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
          hintText: "Faculity Name",
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
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.grading_rounded,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "GPA",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF3C7754))),
        ));

    //signup button
    final signUpButton = Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(5),
      color: const Color(0xff3B7753),
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 200,
          onPressed: () {
            signUp(emailController.text, passwordController.text);
          },
          child: const Text(
            "Signup",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
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
                  builder: (BuildContext context) => const RegisterTypePage()));
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/images/Trainee.png",
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Welcome',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text('Enter your account here',
                        style: TextStyle(
                            color: Color.fromARGB(255, 84, 87, 85),
                            fontSize: 18)),
                    const SizedBox(height: 30),
                    nameField,
                    const SizedBox(height: 20),
                    emailField,
                    const SizedBox(height: 20),
                    passwordField,
                    const SizedBox(height: 20),
                    confirmPasswordField,
                    const SizedBox(height: 20),
                    phoneField,
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                        (value) => value == null
                                            ? 'field required'
                                            : null;
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
                        const SizedBox(height: 25),
                        Row(
                          children: const [
                            SizedBox(width: 2),
                            Icon(
                              CupertinoIcons.calendar,
                              color: Color.fromARGB(255, 117, 116, 116),
                            ),
                            SizedBox(width: 10),
                            Text('Date of Birth',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 84, 87, 85),
                                    fontSize: 18)),
                          ],
                        ),
                        const SizedBox(height: 15),
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
                                  padding:
                                      const EdgeInsets.only(left: 7, right: 4),
                                  child: DropdownButton(
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 97, 97, 98)),
                                    value: selectday,
                                    onChanged: (value) {
                                      setState(() {
                                        (value) => value == null
                                            ? 'field required'
                                            : null;
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
                                  padding:
                                      const EdgeInsets.only(left: 7, right: 4),
                                  child: DropdownButton(
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 97, 97, 98)),
                                    value: selectmonth,
                                    onChanged: (value) {
                                      setState(() {
                                        (value) => value == null
                                            ? 'field required'
                                            : null;
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
                                  padding:
                                      const EdgeInsets.only(left: 7, right: 4),
                                  child: DropdownButton(
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 97, 97, 98)),
                                    value: selectyear,
                                    onChanged: (value) {
                                      setState(() {
                                        (value) => value == null
                                            ? 'field required'
                                            : null;
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
                      ],
                    ),
                    const Divider(
                        height: 80,
                        thickness: 2,
                        color: Color.fromARGB(255, 224, 221, 221)),
                    const Text('Education Information',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                    const SizedBox(height: 20),
                    universityField,
                    const SizedBox(height: 20),
                    faculityField,
                    const SizedBox(height: 20),
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
                    gpaField,
                    const SizedBox(height: 45),
                    signUpButton,
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        if (kDebugMode) {
          print(error.code);
        }
      }
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();
    Trainee traineeModel = Trainee();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = nameController.text;
    userModel.phone = phoneController.text;
    userModel.city = selectcity;
    userModel.type = 'trainee';

    traineeModel.email = user.email;
    traineeModel.uid = user.uid;
    traineeModel.name = nameController.text;
    traineeModel.phone = phoneController.text;
    traineeModel.city = selectcity;
    traineeModel.dBirth = '$selectday/$selectmonth/$selectyear';
    traineeModel.university = universityController.text;
    traineeModel.faculity = faculityController.text;
    traineeModel.department = selectdep;
    traineeModel.studydurationStart = selectstartStudy;
    traineeModel.studydurationEnd = selectendStudy;
    traineeModel.gba = double.parse(gbaController.text) as int?;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    await firebaseFirestore
        .collection("trainee")
        .doc(user.uid)
        .set(traineeModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false);
  }
}
