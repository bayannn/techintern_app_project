import 'package:flutter/material.dart';
import 'package:techintern_app_project/screens/company_screens/register_company.dart';
import 'package:techintern_app_project/screens/get_started.dart';
import 'package:techintern_app_project/screens/login.dart';
import 'package:techintern_app_project/screens/trainee_screens/register_trainee.dart';

class RegisterTypePage extends StatelessWidget {
  const RegisterTypePage({Key? key}) : super(key: key);

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
                    builder: (BuildContext context) => const GetStartedPage()));
              },
            ),
          ),
          elevation: 0,
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
          const SizedBox(),
          const Image(
            image: AssetImage('assets/images/logo.png'),
            width: 400,
            height: 400,
            fit: BoxFit.cover,
          ),
          const Text(
            ' Register as',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(30, 30, 60, 105),
                child: IconButton(
                  iconSize: 80,
                  icon: const Icon(
                    Icons.person,
                    color: Color(0xFF3C7754),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const RegisterTraineeScreen()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 30, 105),
                child: IconButton(
                  iconSize: 80,
                  icon: const Icon(
                    Icons.location_city_rounded,
                    color: Color(0xFF3C7754),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => const RegisterCompanyScreen()));
                  },
                ),
              ),
            ],
          ),
          const Divider(
              height: 25,
              thickness: 2,
              color: Color.fromARGB(255, 224, 221, 221)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Already have account?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF3C7754), fontSize: 15),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const LoginScreen()));
                },
                child: const Text(
                  " Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF3C7754), fontSize: 15, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ]))));
  }
}
