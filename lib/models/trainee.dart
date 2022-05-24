class Trainee {
  String? uid;
  String? email;
  String? name;
  String? phone;
  String? city;
  String? imagePath;
  String? cvPath;
  String? about;
  String? dBirth;
  String? university;
  String? faculity;
  String? department;
  int? gba;
  String? studydurationStart;
  String? studydurationEnd;
  String? englishScore;
  String? skills;
  String? languages;

  Trainee(
      {this.uid,
      this.email,
      this.name,
      this.phone,
      this.city,
      this.dBirth,
      this.about,
      this.university,
      this.faculity,
      this.department,
      this.gba,
      this.studydurationStart,
      this.studydurationEnd,
      this.englishScore,
      this.skills,
      this.languages, 
      this.imagePath,
      this.cvPath});

  // receiving data from server
  factory Trainee.fromMap(map) {
    return Trainee(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      phone: map['phone'],
      city: map['city'],
      dBirth: map['dBirth'],
      about: map['about'],
      university: map['university'],
      faculity: map['faculity'],
      department: map['department'],
      gba: map['gba'],
      studydurationStart: map['studydurationStart'],
      studydurationEnd: map['studydurationEnd'],
      englishScore: map['englishScore'],
      skills: map['skills'],
      languages: map['languages'],
      imagePath: map['imagePath'],
      cvPath: map['cvPath'],
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
      'dBirth': dBirth,
      'about': about,
      'university': university,
      'faculity': faculity,
      'department': department,
      'gba': gba,
      'studydurationStart': studydurationStart,
      'studydurationEnd': studydurationEnd,
      'englishScore': englishScore,
      'skills': skills,
      'languages': languages,
      'imagePath': imagePath,
      'cvPath': cvPath,
    };
  }
}
