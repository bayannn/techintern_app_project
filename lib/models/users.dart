class UserModel {
  String? uid;
  String? type;
  String? email;
  String? name;
  String? phone;
  String? city;
  String? imagePath;

  UserModel(
      {this.uid,
      this.type,
      this.email,
      this.name,
      this.phone,
      this.city,
      this.imagePath});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      type: map['type'],
      email: map['email'],
      name: map['name'],
      phone: map['phone'],
      city: map['city'],
      imagePath: map['imagePath'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'type': type,
      'email': email,
      'name': name,
      'phone': phone,
      'city': city,
      'imagePath': imagePath,
    };
  }

  String? validEmail(value) {
    if (value!.isEmpty) {
      return ("Please Enter Your Email");
    }
    // reg expression for email validation
    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
      return ("Please Enter a valid email");
    }
    return null;
  }

  String? validpass(value) {
    RegExp regex = RegExp(r'^.{6,}$');
    if (value!.isEmpty) {
      return ("Password is required for login");
    }
    if (!regex.hasMatch(value)) {
      return ("Enter Valid Password");
    }
    return null;
  }

  String? validConfirmpass(
      String confirmPasswordController, String passwordController) {
    if (confirmPasswordController != passwordController) {
      return "Password don't match";
    }
    return null;
  }

  String? validName(value) {
    if (value!.isEmpty) {
      return ("Please Enter Your Name");
    }
    // reg expression for email validation
    if (!RegExp(r'^.{3,}$').hasMatch(value)) {
      return ("Enter Valid Name(Min. 3 Character)");
    }
    return null;
  }

  String? validPhone(value) {
    if (value!.isEmpty) {
      return ("Please Enter Your Phone Number");
    }
    // reg expression for email validation
    if (!RegExp(r"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$")
        .hasMatch(value)) {
      return ("Enter Valid Phone(10 Character)");
    }
    return null;
  }

  String? validDescripeComp(value) {
    if (value!.isEmpty) {
      return ("Please Enter Your Company Description");
    }
    // reg expression for email validation
    if (!RegExp(r'^.{3,}$').hasMatch(value)) {
      return ("Enter Valid Description(Min. 3 Character)");
    }
    return null;
  }

  String? validLinkComp(value) {
    if (value!.isEmpty) {
      return ("Please Enter Your Company URL website");
    }
    // reg expression for email validation
    if (!RegExp(
            "((http|https)://)?[a-zA-Z0-9@:%._\\+~#?&//=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%._\\+~#?&//=]*)")
        .hasMatch(value)) {
      return ("Enter Valid URL");
    }
    return null;
  }
}
