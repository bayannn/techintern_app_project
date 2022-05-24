import 'package:flutter/material.dart';
import 'package:techintern_app_project/screens/register_type.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
        child: Center(
          child: Column(
            children: <Widget>[
              const Image(
                image: AssetImage('assets/images/logo.png'),
                width: 400,
                height: 400,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 150,
              ),
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xff3B7753),
                child: MaterialButton(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    minWidth: 200,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const RegisterTypePage()));
                    },
                    child: const Text(
                      "Get Started",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
