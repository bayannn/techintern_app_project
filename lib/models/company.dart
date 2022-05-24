class Company {
  String? uid;
  String? email;
  String? name;
  String? phone;
  String? city;
  String? imagePath;
  String? about;
  String? descripe;
  String? link;
  String? branch;


  Company(
      {this.uid,
      this.email,
      this.name,
      this.phone,
      this.city,
      this.about,
      this.descripe,
      this.link,
      this.branch,
      this.imagePath});

  // receiving data from server
  factory Company.fromMap(map) {
    return Company(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      phone: map['phone'],
      city: map['city'],
      about: map['about'],
      descripe: map['descripe'],
      link: map['link'],
      branch: map['branch'],
      imagePath: map['imagePath'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'city': city,
      'about': about,
      'descripe': descripe,
      'link': link,
      'branch': branch,
      'imagePath': imagePath,
    };
  }
}
