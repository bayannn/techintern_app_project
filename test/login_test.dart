import 'package:flutter_test/flutter_test.dart';
import 'package:techintern_app_project/models/users.dart';

Future<void> main() async {

  final login = UserModel();

  group('Login test', (){

    //EMAIL
    test("Email feild is Fail 'Empty' ", () {
      String signedIn = login.validEmail("").toString();
      expect(signedIn, 'Please Enter Your Email');
    });

    test("Email feild is Fail 'Not valid' ", () {
      String signedIn = login.validEmail("janagmail").toString();
      expect(signedIn, 'Please Enter a valid email');
    });

    test("Email feild is success ", () {
      String signedIn = login.validEmail("jana@gmail.com").toString();
      expect(signedIn.toString(), 'null');
    });


    //PASSWORD
    test("Password feild is Fail 'Empty' ", () {
      String signedIn = login.validpass("").toString();
      expect(signedIn, 'Password is required for login');
    });

    test("Password feild is Fail 'Not valid' ", () {
      String signedIn = login.validpass("123").toString();
      expect(signedIn, "Enter Valid Password");
    });

    test("Password feild is success ", () {
      String signedIn = login.validpass("123456").toString();
      expect(signedIn.toString(), 'null');
    });

  });
}