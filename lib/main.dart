import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:techintern_app_project/models/users.dart';
import 'package:techintern_app_project/screens/chat.dart';
import 'package:techintern_app_project/screens/company_screens/add_post.dart';
import 'package:techintern_app_project/screens/company_screens/applicant.dart';
import 'package:techintern_app_project/screens/company_screens/profile_company.dart';
import 'package:techintern_app_project/screens/get_started.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:techintern_app_project/screens/trainee_screens/activity.dart';
import 'package:techintern_app_project/screens/trainee_screens/home.dart';
import 'package:techintern_app_project/screens/trainee_screens/profile_trainee.dart';
import 'package:techintern_app_project/screens/trainee_screens/search.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF3C7754),
          dividerColor: Colors.grey,
        ),
        title: 'TechIntern App',
        home: const GetStartedPage(),
      );
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  User? user = FirebaseAuth.instance.currentUser;

  static UserModel userModel = UserModel();

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      userModel = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  int _currentIndex = 0;

  final widgetOptionsTrainee = [
    const HomeScreen(),
    const SearchScreen(),
    const ActivityScreen(),
    ChatScreen(user: userModel),
    const ProfileTraineeScreen(),
  ];

  final widgetOptionsCompany = [
    const ApplicantScreen(),
    const AddPostScreen(),
    ChatScreen(user: userModel),
    const ProfileCompanyScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      if (kDebugMode) {
        print(userModel.uid);
      }
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool type;
    if (userModel.type == 'trainee') {type= true;}
    else {type= false;}
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: getPage(type),
      body: Container(
          color: Colors.white,
          child: Center(
            child: type ? widgetOptionsTrainee.elementAt(_currentIndex) : widgetOptionsCompany.elementAt(_currentIndex),
          )),
    );
  }

  Widget getPage(bool type) {
    List<Widget> itemsT = [
      const Icon(Icons.home, size: 30, color: Colors.white),
      const Icon(Icons.search, size: 30, color: Colors.white),
      const Icon(Icons.text_snippet_outlined, size: 30, color: Colors.white),
      const Icon(Icons.textsms_outlined, size: 30, color: Colors.white),
      const Icon(Icons.person, size: 30, color: Colors.white),
    ];
    List<Widget> itemsC = [
      const Icon(Icons.people_alt, size: 30, color: Colors.white),
      const Icon(Icons.add, size: 30, color: Colors.white),
      const Icon(Icons.textsms_outlined, size: 30, color: Colors.white),
      const Icon(Icons.person, size: 30, color: Colors.white),
    ];
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      color: const Color(0xff3B7753),
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 900),
      onTap: onItemTapped,
      items: type ? itemsT : itemsC,
    );
  }
}
