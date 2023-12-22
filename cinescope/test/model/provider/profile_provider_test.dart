import 'dart:typed_data';

import 'package:cinescope/model/profile.dart';
import 'package:cinescope/model/providers/profile_provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("ProfileProvider", () {
    test("adds image to profile correctly", () async {
      MockFirebaseAuth mockFirebaseAuth =
          MockFirebaseAuth(mockUser: MockUser(uid: "test-uid"), signedIn: true);

      FakeFirebaseFirestore firebaseFirestore = FakeFirebaseFirestore(
          authObject: mockFirebaseAuth.authForFakeFirestore);

      MockFirebaseStorage firebaseStorage = MockFirebaseStorage();


      TestWidgetsFlutterBinding.ensureInitialized();
      ProfileProvider profileProvider = ProfileProvider(
          firebaseAuth: mockFirebaseAuth,
          firebaseFirestore: firebaseFirestore,
          firebaseStorage: firebaseStorage,
          compressImages: false);

      Profile profile = Profile(
          "Cansado", "Sou muito cansado e só gosto de filmes ", "",
          id: "test-uid", imageData: Uint8List.fromList([0, 1, 2, 3, 4, 5, 6]));

      await profileProvider.saveProfile(profile);

      expect(firebaseStorage.storedDataMap.keys.first,
          "images/profiles/test-uid.png");
      expect(firebaseStorage.storedDataMap.values.first,
          Uint8List.fromList([0, 1, 2, 3, 4, 5, 6]));

      Profile testProfile = (await firebaseFirestore
              .collection('profiles')
              .withConverter(
                  fromFirestore: (snapshot, options) =>
                      Profile.fromFirestore(snapshot, options),
                  toFirestore: (film, _) => film.toFirestore())
              .doc("test-uid")
              .get())
          .data()!;

      expect(testProfile.name, "Cansado");
      expect(testProfile.bio, "Sou muito cansado e só gosto de filmes ");
      expect(testProfile.picPath, "images/profiles/test-uid.png");
    });

    test("gets correct profile", () async {
      MockFirebaseAuth mockFirebaseAuth =
          MockFirebaseAuth(mockUser: MockUser(uid: "test-uid"), signedIn: true);

      FakeFirebaseFirestore firebaseFirestore = FakeFirebaseFirestore(
          authObject: mockFirebaseAuth.authForFakeFirestore);

      MockFirebaseStorage firebaseStorage = MockFirebaseStorage();

      Profile profile = Profile(
          "BDMendes", "rei dos cansados ", "images/profiles/cansadissimo.png",
          id: "cansadissimo");

      await firebaseFirestore
          .collection('profiles')
          .withConverter(
              fromFirestore: (snapshot, options) =>
                  Profile.fromFirestore(snapshot, options),
              toFirestore: (film, _) => film.toFirestore())
          .doc("cansadissimo")
          .set(profile);

      firebaseStorage.storedDataMap["images/profiles/cansadissimo.png"] =
          Uint8List.fromList([6, 5, 4, 3, 2, 1, 0]);
      firebaseStorage
          .storedSettableMetadataMap["images/profiles/cansadissimo.png"] = {};

      TestWidgetsFlutterBinding.ensureInitialized();
      ProfileProvider profileProvider = ProfileProvider(
          firebaseAuth: mockFirebaseAuth,
          firebaseFirestore: firebaseFirestore,
          firebaseStorage: firebaseStorage,
          compressImages: false);

      Profile testProfile =
          await profileProvider.getProfileByUidReload(uid: "cansadissimo");

      expect(testProfile.imageData, Uint8List.fromList([6, 5, 4, 3, 2, 1, 0]));
      expect(testProfile.name, "BDMendes");
      expect(testProfile.bio, "rei dos cansados ");
    });

    test("gets profile of new auth", () async {
      MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth(
          mockUser: MockUser(uid: "cansadissimo"), signedIn: false);

      FakeFirebaseFirestore firebaseFirestore = FakeFirebaseFirestore(
          authObject: mockFirebaseAuth.authForFakeFirestore);

      MockFirebaseStorage firebaseStorage = MockFirebaseStorage();

      Profile profile = Profile(
          "BDMendes", "rei dos cansados ", "images/profiles/cansadissimo.png",
          id: "cansadissimo");

      await firebaseFirestore
          .collection('profiles')
          .withConverter(
              fromFirestore: (snapshot, options) =>
                  Profile.fromFirestore(snapshot, options),
              toFirestore: (film, _) => film.toFirestore())
          .doc("cansadissimo")
          .set(profile);

      firebaseStorage.storedDataMap["images/profiles/cansadissimo.png"] =
          Uint8List.fromList([6, 5, 4, 3, 2, 1, 0]);
      firebaseStorage
          .storedSettableMetadataMap["images/profiles/cansadissimo.png"] = {};

      TestWidgetsFlutterBinding.ensureInitialized();
      ProfileProvider profileProvider = ProfileProvider(
          firebaseAuth: mockFirebaseAuth,
          firebaseFirestore: firebaseFirestore,
          firebaseStorage: firebaseStorage,
          compressImages: false);

      await mockFirebaseAuth.signInWithEmailAndPassword(
          email: "kekw@gmail", password: "passwordsupersecreta");

      //not ideal but should no other way to ensure that profileprovider has already listened to the authchange
      await Future.delayed(const Duration(seconds: 5));

      Profile testProfile = profileProvider.getProfile();

      expect(testProfile.imageData, Uint8List.fromList([6, 5, 4, 3, 2, 1, 0]));
      expect(testProfile.name, "BDMendes");
      expect(testProfile.bio, "rei dos cansados ");
    });
  });
}
