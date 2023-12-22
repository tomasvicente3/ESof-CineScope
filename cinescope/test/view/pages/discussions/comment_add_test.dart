import 'package:cinescope/model/discussion.dart';
import 'package:cinescope/model/providers/discussion_provider.dart';
import 'package:cinescope/view/pages/discussions/add_comment_page.dart';
import 'package:cinescope/view/simple_dialog.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'comment_add_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<DiscussionProvider>(onMissingStub: OnMissingStub.returnDefault),
])
void main() {
  final Discussion discussion = Discussion(
      "",
      "tt1234",
      "Discussion Title",
      "Discussion Description",
      "siuuuuu",
      DateTime(
        2022,
      ),
      [Comment("siuu", DateTime.now(), "teste")]);
  group("CommentAddTest", () {
    testWidgets(" calls discussion provider to send a valid comment",
        (widgetTester) async {
      final mockDiscussionProvider = MockDiscussionProvider();
      final firebaseAuth = MockFirebaseAuth(mockUser: MockUser(uid: "lmao"));
      await firebaseAuth.signInWithEmailAndPassword(
          email: "test@gmail.com", password: "kekw");
      await widgetTester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<DiscussionProvider>(
              create: ((context) => mockDiscussionProvider))
        ],
        child: MaterialApp(
            home: Scaffold(
          body: CommentAddPage(
            discussion,
            const Text("titanic"),
            authInstance: firebaseAuth,
          ),
        )),
      ));

      await widgetTester.enterText(
          find.byKey(const Key("comment-field")), "Comment content");

      await widgetTester.tap(find.byType(TextButton));

      await widgetTester.pumpAndSettle();

      final verified = verify(mockDiscussionProvider.addCommentToDiscussion(
          captureAny, captureAny));
      verified.called(1);

      final capturedDiscussion = verified.captured[0] as Discussion;
      expect(capturedDiscussion.filmId, discussion.filmId);
      final capturedComment = verified.captured[1] as Comment;
      expect(capturedComment.content, "Comment content");
      expect(capturedComment.createdById, "lmao");
    });

    testWidgets(" shows dialog and doesnt call provider", (widgetTester) async {
      final mockDiscussionProvider = MockDiscussionProvider();
      final firebaseAuth = MockFirebaseAuth(mockUser: MockUser(uid: "lmao"));
      await firebaseAuth.signInWithEmailAndPassword(
          email: "test@gmail.com", password: "kekw");
      await widgetTester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<DiscussionProvider>(
              create: ((context) => mockDiscussionProvider))
        ],
        child: MaterialApp(
            home: Scaffold(
          body: CommentAddPage(
            discussion,
            const Text("titanic"),
            authInstance: firebaseAuth,
          ),
        )),
      ));

      await widgetTester.tap(find.byType(TextButton));

      await widgetTester.pumpAndSettle();

      expect(find.byType(GenericDialog), findsOneWidget);

      verifyNever(mockDiscussionProvider.addCommentToDiscussion(any, any));
    });
  });
}
