import 'dart:async';

import 'package:cinescope/model/profile.dart';
import 'package:cinescope/model/providers/required_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:logger/logger.dart';

class ProfileProvider extends RequiredProvider {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;
  final bool compressImages;

  final Map<String, Profile> _profileCache = {};

  ProfileProvider(
      {FirebaseAuth? firebaseAuth,
      FirebaseFirestore? firebaseFirestore,
      FirebaseStorage? firebaseStorage, this.compressImages = true})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance {
    if (_firebaseAuth.currentUser != null) {
      getProfileByUid();
    }
    _firebaseAuth.authStateChanges().listen(_authChange);
  }

  Profile _profile = Profile.empty();
  Profile getProfile() => _profile;

  void _authChange(User? user) async {
    if (user != null) {
      _profile = await getProfileByUid();
    } else {
      loadedController.add(false);
    }
  }

  Future<Profile> getProfileByUid({String? uid}) async {
    final ownProfile = uid == null;
    uid ??= _firebaseAuth.currentUser!.uid;
    if (_profileCache.containsKey(uid)) {
      return _profileCache[uid]!;
    }
    final watchlistsRef = _firebaseFirestore
        .collection("profiles")
        .withConverter(
            fromFirestore: (snapshot, options) =>
                Profile.fromFirestore(snapshot, options),
            toFirestore: (film, _) => film.toFirestore());
    Profile? profile = (await watchlistsRef.doc(uid).get()).data();
    if (profile == null && ownProfile) {
      profile = Profile.empty();
      profile.id ??= ownProfile ? uid : null;
      Uint8List defaultImage =
          (await rootBundle.load("assets/profile-placeholder.png"))
              .buffer
              .asUint8List();
      profile.imageData = defaultImage;
    } else if (profile != null) {
      try {
        profile.imageData =
            await _firebaseStorage.ref(profile.picPath).getData();
      } catch (e) {
        Logger().e("exception...", e);
        Uint8List defaultImage =
            (await rootBundle.load("assets/profile-placeholder.png"))
                .buffer
                .asUint8List();
        profile.imageData = defaultImage;
      }
    } else if (profile == null) {
      profile = Profile.empty();
      Uint8List defaultImage =
          (await rootBundle.load("assets/profile-placeholder.png"))
              .buffer
              .asUint8List();
      profile.imageData = defaultImage;
    }

    _profileCache[uid] = profile;
    if (ownProfile) {
      _profile = profile;
      loadedController.add(true);
    }
    return profile;
  }

  Future<Profile> getProfileByUidReload({String? uid}) async {
    final profile = await getProfileByUid(uid: uid);
    notifyListeners();
    return profile;
  }

  Future<void> saveProfile(Profile profile) async {
    FirebaseFirestore firestore = _firebaseFirestore;

    profile.picPath = "images/profiles/${profile.id!}.png";
    await firestore
        .collection('profiles')
        .withConverter(
            fromFirestore: (snapshot, options) =>
                Profile.fromFirestore(snapshot, options),
            toFirestore: (film, _) => film.toFirestore())
        .doc(profile.id)
        .set(profile);
    if (profile.id == _firebaseAuth.currentUser!.uid) {
      _profile = profile;
    }
    notifyListeners();
    Uint8List originalImage = profile.imageData ??
        (await rootBundle.load("assets/profile-placeholder.png"))
            .buffer
            .asUint8List();
    Uint8List compressedImage;
    if(compressImages){
       compressedImage = await FlutterImageCompress.compressWithList(originalImage);
    } else {
      compressedImage = originalImage;
    }
    await _firebaseStorage.ref(profile.picPath).putData(compressedImage);
    notifyListeners();
  }

  void rerender() {
    notifyListeners();
  }
}
