class Applicant {
  String? pid;
  String? traineesId;

  Applicant({
    this.pid,
    this.traineesId,
  });

  // receiving data from server
  factory Applicant.fromMap(map) {
    return Applicant(
      pid: map['pid'],
      traineesId: map['uid'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'pid': pid,
      'uid': traineesId,
    };
  }
}