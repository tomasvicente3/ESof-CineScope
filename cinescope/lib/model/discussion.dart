import 'package:cinescope/model/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Comment {
  final String content;
  final DateTime creationTime;
  final String createdById;
  Profile? createdBy;

  Comment(this.content, this.creationTime, this.createdById);

  factory Comment.fromMap(Map<String, dynamic> map){
    return Comment(map["content"], DateTime.parse(map["creationTime"]), map["createdBy"]);
  }

  Map<String,dynamic> toMap() => {
    "content" : content,
    "creationTime": creationTime.toIso8601String(),
    "createdBy": createdById
  };

}

class Discussion {
  final String id;
  final String filmId;
  final String title;
  final String description;
  final String createdById;
  late Profile? createdBy;
  final DateTime creationDate;
  final List<Comment> comments;

  Discussion(this.id, this.filmId,this.title, this.description, this.createdById, this.creationDate,
      this.comments);

  factory Discussion.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>>snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception("Something went wrong while building ");
    }
    List<Comment> comments = []; 
    if(!data["comments"].isEmpty){
      for(final element in data["comments"]){

        comments.add(Comment.fromMap(element));
      }
    }

    return Discussion(
      snapshot.id,
      data["filmId"],
      data["title"], 
      data["description"], 
      data["createdBy"], 
      DateTime.parse(data["creationDate"]), 
      comments);
  }

  Map<String, dynamic> toFirestore() => {
    "filmId": filmId,
    "title": title,
    "description": description,
    "createdBy": createdById,
    "creationDate": creationDate.toIso8601String(),
    "comments": comments.map((e) => e.toMap()).toList()
  };

  @override
  bool operator ==(Object other){
    if (identical(this, other)) return true;
    return other is Discussion && other.id == id;
  }

}
