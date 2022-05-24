import 'package:flutter_test/flutter_test.dart';
import 'package:techintern_app_project/models/users.dart';

void main() {

  final register = UserModel();

  group('Register test', (){

    //NAME
    test("Name feild is Fail 'Empty' ", () {
      String signedUp = register.validName("").toString();
      expect(signedUp, 'Please Enter Your Name');
    });

    test("Name feild is Fail 'Not valid' ", () {
      String signedUp = register.validName("ja").toString();
      expect(signedUp, 'Enter Valid Name(Min. 3 Character)');
    });

    test("Name feild is success ", () {
      String signedUp = register.validName("jana").toString();
      expect(signedUp.toString(), 'null');
    });
    

    //EMAIL
    test("Email feild is Fail 'Empty' ", () {
      String signedUp = register.validEmail("").toString();
      expect(signedUp, 'Please Enter Your Email');
    });

    test("Email feild is Fail 'Not valid' ", () {
      String signedUp = register.validEmail("janagmail").toString();
      expect(signedUp, 'Please Enter a valid email');
    });

    test("Email feild is success ", () {
      String signedUp = register.validEmail("jana@gmail.com").toString();
      expect(signedUp.toString(), 'null');
    });


    //PASSWORD
    test("Password feild is Fail 'Empty' ", () {
      String signedUp = register.validpass("").toString();
      expect(signedUp, 'Password is required for login');
    });

    test("Password feild is Fail 'Not valid' ", () {
      String signedUp = register.validpass("123").toString();
      expect(signedUp, "Enter Valid Password");
    });

    test("Password feild is success ", () {
      String signedUp = register.validpass("123456").toString();
      expect(signedUp.toString(), 'null');
    });


    //CONFIRM PASSWORD
    test("Confirm Password feild is Fail ", () {
      String signedUp = register.validConfirmpass("123456","456789").toString();
      expect(signedUp, "Password don't match");
    });

    test("Confirm Password feild is Success ", () {
      String signedUp = register.validConfirmpass("123456","123456").toString();
      expect(signedUp.toString(), "null");
    });


    //PHONE
    test("Phone feild is Fail 'Empty' ", () {
      String signedUp = register.validPhone("").toString();
      expect(signedUp, 'Please Enter Your Phone Number');
    });

    test("Phone feild is Fail 'Not valid' ", () {
      String signedUp = register.validPhone("0503347").toString();
      expect(signedUp, "Enter Valid Phone(10 Character)");
    });

    test("Phone feild is success ", () {
      String signedUp = register.validPhone("0555033470").toString();
      expect(signedUp.toString(), 'null');
    });


    //COMPANY DESCRIPTION
    test("Company Description feild is Fail 'Empty' ", () {
      String signedUp = register.validDescripeComp("").toString();
      expect(signedUp, 'Please Enter Your Company Description');
    });

    test("Company Description feild is Fail 'Not valid' ", () {
      String signedUp = register.validDescripeComp("co").toString();
      expect(signedUp, "Enter Valid Description(Min. 3 Character)");
    });

    test("Company Description feild is success ", () {
      String signedUp = register.validDescripeComp("Oil company").toString();
      expect(signedUp.toString(), 'null');
    });


    //COMPANY LINK
    test("Company Link feild is Fail 'Empty' ", () {
      String signedUp = register.validLinkComp("").toString();
      expect(signedUp, 'Please Enter Your Company URL website');
    });

    test("Company Link feild is Fail 'Not valid' ", () {
      String signedUp = register.validLinkComp("co").toString();
      expect(signedUp, "Enter Valid URL");
    });

    test("Company Link feild is success ", () {
      String signedUp = register.validLinkComp("www.google.com").toString();
      expect(signedUp.toString(), 'null');
    });

  });
}