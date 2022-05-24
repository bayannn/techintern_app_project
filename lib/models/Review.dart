// ignore_for_file: file_names

class Review {
  String? companyId;
  String? traineeId;
  String? postId;
  String? opinion;

  Review(
      {
      this.traineeId,
      this.postId,
      this.companyId,
      this.opinion});

  // receiving data from server
  factory Review.fromMap(map) {
    return Review(
      traineeId: map['uidT'],
      postId: map['pid'],
      companyId: map['uidC'],
      opinion: map['opinion'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uidT': traineeId,
      'pid': postId,
      'uidC': companyId,
      'opinion': opinion,
    };
  }
}
