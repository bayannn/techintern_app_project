class Track {
  String? traineeId;
  String? postId;
  bool? applied;
  bool? rejected;
  bool? accepted;
  bool? scannedCV;
  bool? interviwed;
  
  Track(
      {
      this.traineeId,
      this.postId,
      this.applied,
      this.rejected,
      this.accepted,
      this.scannedCV,
      this.interviwed});

  // receiving data from server
  factory Track.fromMap(map) {
    return Track(
      traineeId: map['uid'],
      postId: map['pid'],
      applied: map['applied'],
      rejected: map['rejected'],
      accepted: map['accepted'],
      scannedCV: map['scannedCV'],
      interviwed: map['interviwed'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': traineeId,
      'pid': postId,
      'applied': applied,
      'rejected': rejected,
      'accepted': accepted,
      'scannedCV': scannedCV,
      'interviwed': interviwed,
    };
  }
}
