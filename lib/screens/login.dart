import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:techintern_app_project/main.dart';
import 'package:techintern_app_project/models/users.dart';
import 'package:techintern_app_project/screens/company_screens/register_company.dart';
import 'package:techintern_app_project/screens/register_type.dart';
import 'package:techintern_app_project/screens/trainee_screens/register_trainee.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool dontshowPassword = true;

  @override
  Widget build(BuildContext context) {
    UserModel user = UserModel();
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
        textInputAction: TextInputAction.done,
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

    //login button
    final loginButton = Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(5),
      color: const Color(0xff3B7753),
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 200,
          onPressed: () {
            signIn(emailController.text, passwordController.text);
          },
          child: const Text(
            "Login",
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
                    builder: (BuildContext context) =>
                        const RegisterTypePage()));
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
                          "assets/images/logo2.png",
                          width: 200,
                          height: 140,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Welcome Again',
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
                        emailField,
                        const SizedBox(height: 25),
                        passwordField,
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              250, 0, 0, 0),
                          child: TextButton(
                              onPressed: () {
                                /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ResetPassword()));*/
                              },
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: Color(0xFF3C7754),
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 1,
                                ),
                              )),
                        ),
                        const SizedBox(height: 25),
                        loginButton,
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("Don't have an account? ",
                                style: TextStyle(color: Colors.black)),
                            Text("Register as",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 84, 87, 85))),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      top: 10, bottom: 20),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.person,
                                      color: Color(0xFF3C7754),
                                      size: 40,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const RegisterTraineeScreen()));
                                    },
                                  )),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    20, 10, 0, 20),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.location_city_rounded,
                                    color: Color(0xFF3C7754),
                                    size: 40,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const RegisterCompanyScreen()));
                                  },
                                ),
                              ),
                            ]),
                      ]),
                ),
              ),
            ),
          ),
        ));
  }

  // login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Login Successful"),
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const MainPage()))
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
}
