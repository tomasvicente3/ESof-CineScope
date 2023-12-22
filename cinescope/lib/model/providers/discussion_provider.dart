
import 'dart:collection';

import 'package:cinescope/model/discussion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


//NOTE (luisd):this might be a proxy provider if we make a provider for profiles
class DiscussionProvider extends ChangeNotifier{
  late final FirebaseAuth _authInstance;
  late final FirebaseFirestore _storeInstance;


  //if a user comments or creates a new discussion, it should be stored here
  //TODO: make firebase fetching to get discussions that user interacted with
  final Set<Discussion> _userDiscussions = {};

  UnmodifiableSetView<Discussion> get userDiscussions => UnmodifiableSetView(_userDiscussions);
  
  DiscussionProvider({FirebaseAuth? auth, FirebaseFirestore? store}) 
    : _authInstance = auth ?? FirebaseAuth.instance, 
      _storeInstance = store ?? FirebaseFirestore.instance;

  Future<UnmodifiableSetView<Discussion>> getDiscussionsByFilmId(String filmId) async{
    final queryData = await _storeInstance.collection("discussions")
      .withConverter(fromFirestore: Discussion.fromFirestore, toFirestore: (discussion, _) => discussion.toFirestore())
      .where("filmId", isEqualTo: filmId).get();
    return UnmodifiableSetView(queryData.docs.map((e) => e.data()).toSet());
  }

  Future<void> addNewDiscussion(Discussion newDiscussion) async{
    await _storeInstance.collection("discussions")
      .withConverter(fromFirestore: Discussion.fromFirestore, toFirestore: (discussion, _) => discussion.toFirestore())
      .add(newDiscussion);
    _userDiscussions.add(newDiscussion);
    notifyListeners();
  }

  Future<void> addCommentToDiscussion(Discussion discussion, Comment newComment) async{
    discussion.comments.add(newComment);
    _userDiscussions.add(discussion);
    notifyListeners();
    await _storeInstance.collection("discussions")
      .withConverter(fromFirestore: Discussion.fromFirestore, toFirestore: (discussion, _) => discussion.toFirestore())
      .doc(discussion.id).set(discussion);
  }

  void rerender() {
    notifyListeners();
  }
}