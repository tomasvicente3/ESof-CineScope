import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String name, bio;
  String picPath;
  String? id;
  Uint8List? imageData;

  Profile(this.name, this.bio, this.picPath, {this.id, this.imageData});

  Profile.empty()
      : //userId = '',
        name = '',
        bio = '',
        picPath = '';

  factory Profile.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception("Something went wrong while building ");
    }
    return Profile(data["name"], data["bio"], data["image"], id: snapshot.id);
  }

  Map<String, dynamic> toFirestore() =>
      {"name": name, "bio": bio, "image": picPath};
}
