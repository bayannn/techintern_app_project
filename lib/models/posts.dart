class Posts {
  String? pid;
  String? uid;
  String? companyName;
  String? city;
  String? titleOfTraining;
  String? department;
  String? deliveryMethod;
  String? salary;
  String? description;
  String? responsibilies;
  String? numOfTrainee;
  String? imagePath;
  String? pdfPath;
  String? time;
  String? sepcialization;
  String? programmingLang;
  String? sDate;
  String? eDate;

  Posts({
    this.pid,
    this.uid,
    this.companyName,
    this.titleOfTraining,
    this.department,
    this.deliveryMethod,
    this.salary,
    this.description,
    this.responsibilies,
    this.numOfTrainee,
    this.imagePath,
    this.pdfPath,
    this.time,
    this.sepcialization,
    this.programmingLang,
    this.sDate,
    this.eDate,
    this.city
  });

// receiving data from server
  factory Posts.fromMap(map) {
    return Posts(
      pid: map['pid'],
      uid: map['uid'],
      companyName: map['companyName'],
      titleOfTraining: map['titleOfTraining'],
      department: map['department'],
      deliveryMethod: map['deliveryMethod'],
      salary: map['salary'],
      description: map['description'],
      responsibilies: map['responsibilies'],
      numOfTrainee: map['numOfTrainee'],
      imagePath: map['imagePath'],
      pdfPath: map['pdfPath'],
      time: map['time'],
      sepcialization: map['sepcialization'],
      programmingLang: map['programmingLang'],
      city: map['city'],
      sDate: map['sDate'],
      eDate: map['eDate'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'pid': pid,
      'uid': uid,
      'companyName': companyName,
      'titleOfTraining': titleOfTraining,
      'department': department,
      'deliveryMethod': deliveryMethod,
      'salary': salary,
      'description': description,
      'responsibilies': responsibilies,
      'numOfTrainee': numOfTrainee,
      'imagePath': imagePath,
      'pdfPath': pdfPath,
      'time': time,
      'sepcialization': sepcialization,
      'programmingLang': programmingLang,
      'city': city,
      'sDate': sDate,
      'eDate': eDate,
    };
  }
}
