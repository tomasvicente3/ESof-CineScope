import 'package:cinescope/model/discussion.dart';
import 'package:cinescope/model/providers/discussion_provider.dart';
import 'package:cinescope/model/providers/profile_provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';


@GenerateMocks([], customMocks: [
  MockSpec<ProfileProvider>(onMissingStub: OnMissingStub.returnDefault)
])
void main() {
  group("Discussion Provider", () {
    final Discussion discussion = Discussion(
        "testId",
        "tt1234",
        "Discussion Title",
        "Discussion Description",
        "siuuuuuuu",
        DateTime(
          2022,
        ),
        [Comment("siuu", DateTime.now(), "siuuuuuuu")]);

    final Discussion discussion2 = Discussion(
        "",
        "tt1234",
        "Discussion Title 2",
        "Discussion Description 2",
        "siuuuuuuu",
        DateTime(
          2022,
        ),
        [Comment("siuu", DateTime.now(), "siuuuuuuu")]);

    final Discussion discussion3 = Discussion(
        "",
        "not pog film id",
        "Discussion Title 2",
        "Discussion Description 2",
        "siuuuuuuu",
        DateTime(
          2022,
        ),
        [Comment("siuu", DateTime.now(), "siuuuuuuu")]);

    testWidgets("generates discussions for film correctly",
        (widgetTester) async {
      final authMock = MockFirebaseAuth(
          mockUser: MockUser(uid: "1234-asd", email: "siuuu@gmail.com"),
          signedIn: true);
      final storageMock =
          FakeFirebaseFirestore(authObject: authMock.authForFakeFirestore);

      await storageMock
          .collection("discussions")
          .withConverter(
              fromFirestore: Discussion.fromFirestore,
              toFirestore: (discussion, _) => discussion.toFirestore())
          .doc("siuu")
          .set(discussion);

      await storageMock
          .collection("discussions")
          .withConverter(
              fromFirestore: Discussion.fromFirestore,
              toFirestore: (discussion, _) => discussion.toFirestore())
          .doc("poggers")
          .set(discussion2);

      await storageMock
          .collection("discussions")
          .withConverter(
              fromFirestore: Discussion.fromFirestore,
              toFirestore: (discussion, _) => discussion.toFirestore())
          .doc("sus")
          .set(discussion3);

      final discussionProvider =
          DiscussionProvider(auth: authMock, store: storageMock);
      final set = await discussionProvider.getDiscussionsByFilmId("tt1234");

      expect(set.length, 2);
      expect(set.first.id, "siuu");
      expect(set.first.title, "Discussion Title");

      expect(set.last.id, "poggers");
      expect(set.last.title, "Discussion Title 2");
    });

    testWidgets("adds a new discussion correctly", (widgetTester) async {
      final authMock = MockFirebaseAuth(
          mockUser: MockUser(uid: "1234-asd", email: "siuuu@gmail.com"),
          signedIn: true);
      final storageMock =
          FakeFirebaseFirestore(authObject: authMock.authForFakeFirestore);

      await storageMock
          .collection("discussions")
          .withConverter(
              fromFirestore: Discussion.fromFirestore,
              toFirestore: (discussion, _) => discussion.toFirestore())
          .doc("siuu")
          .set(discussion);

      final discussionProvider =
          DiscussionProvider(auth: authMock, store: storageMock);
      await discussionProvider.addNewDiscussion(discussion2);

      final count =
          (await storageMock.collection("discussions").count().get()).count;
      expect(count, 2);

      final lastAdded = await storageMock
          .collection("discussions")
          .withConverter(
              fromFirestore: Discussion.fromFirestore,
              toFirestore: (discussion, _) => discussion.toFirestore())
          .get();
      final lastAddedData = lastAdded.docs[1].data();
      expect(lastAddedData.description, discussion2.description);
    });

    testWidgets("adds new comment correctly", (widgetTester) async {
      final authMock = MockFirebaseAuth(
          mockUser: MockUser(uid: "1234-asd", email: "siuuu@gmail.com"),
          signedIn: true);
      final storageMock =
          FakeFirebaseFirestore(authObject: authMock.authForFakeFirestore);

      await storageMock
          .collection("discussions")
          .withConverter(
              fromFirestore: Discussion.fromFirestore,
              toFirestore: (discussion, _) => discussion.toFirestore())
          .doc("testId")
          .set(discussion);

      final discussionProvider =
          DiscussionProvider(auth: authMock, store: storageMock);

      final comment = Comment("test content", DateTime.now(), "1234-asd");

      await discussionProvider.addCommentToDiscussion(discussion, comment);


      final discussionAfter = (await storageMock
          .collection("discussions")
          .withConverter(
              fromFirestore: Discussion.fromFirestore,
              toFirestore: (discussion, _) => discussion.toFirestore())
          .doc("testId")
          .get()).data()!;

      
      expect(discussionAfter.comments.length, 2);
      expect(discussionAfter.comments[1].content, comment.content);
    });
  });
}
