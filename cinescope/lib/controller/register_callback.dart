

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> registerCallback(FirebaseAuth instance, FirebaseFirestore firebaseFirestore) async{
  final userUid = instance.currentUser!.uid;
  final CollectionReference watchlists = firebaseFirestore.collection("watchlists");
  
  await watchlists.doc(userUid).set({"movies":[]});
  await watchlists.doc(userUid).set({"discussions":[]});
}