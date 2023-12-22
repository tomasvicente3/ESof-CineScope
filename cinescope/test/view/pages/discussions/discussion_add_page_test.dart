import 'package:cinescope/model/discussion.dart';
import 'package:cinescope/model/providers/discussion_provider.dart';
import 'package:cinescope/view/simple_dialog.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:cinescope/view/pages/discussions/add_discussion_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'discussion_add_page_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<DiscussionProvider>(onMissingStub: OnMissingStub.returnDefault)
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
      [Comment("siuu", DateTime.now(), "siuuuuu")]);
  group('Discussion Add Page', () {
    testWidgets(
        "see if provider is called when submitting with both fields filled",
        (widgetTester) async {
      final mockDiscussionProvider = MockDiscussionProvider();
      final firebaseAuth = MockFirebaseAuth(mockUser: MockUser(uid: "siuuuu"));
      await firebaseAuth.signInWithEmailAndPassword(
          email: "test@gmail.com", password: "kekw");
      await widgetTester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<DiscussionProvider>(
              create: ((context) => mockDiscussionProvider))
        ],
        child: MaterialApp(
            home: Scaffold(
          body: DiscussionAddPage(
            "tt12345",
            const Text("titanic"),
            authInstance: firebaseAuth,
          ),
        )),
      ));

      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(
          find.byKey(const Key("title-field")), "Test title");
      await widgetTester.enterText(
          find.byKey(const Key("body-field")), "Test body");
      await widgetTester.tap(find.byType(TextButton));

      final verified = verify(mockDiscussionProvider.addNewDiscussion(captureAny));
      verified.called(1);
      for (Discussion discussion in verified.captured) {
        expect(discussion.createdById, "siuuuu");
        expect(discussion.title, "Test title");
        expect(discussion.description, "Test body");
        expect(discussion.filmId, "tt12345");
      }
    });

    testWidgets("see if dialog appears when body is empty",
        (widgetTester) async {
      final mockDiscussionProvider = MockDiscussionProvider();
      final firebaseAuth = MockFirebaseAuth(mockUser: MockUser(uid: "siuuuu"));
      await firebaseAuth.signInWithEmailAndPassword(
          email: "test@gmail.com", password: "kekw");
      await widgetTester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<DiscussionProvider>(
              create: ((context) => mockDiscussionProvider))
        ],
        child: MaterialApp(
            home: Scaffold(
          body: DiscussionAddPage(
            "tt12345",
            const Text("titanic"),
            authInstance: firebaseAuth,
          ),
        )),
      ));

      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(
          find.byKey(const Key("title-field")), "Test title");
      await widgetTester.tap(find.byType(TextButton));

      await widgetTester.pumpAndSettle();

      verifyNever(mockDiscussionProvider.addNewDiscussion(any));

      expect(find.byType(GenericDialog), findsOneWidget);
    });

    testWidgets("see if dialog appears when title is empty",
        (widgetTester) async {
      final mockDiscussionProvider = MockDiscussionProvider();
      final firebaseAuth = MockFirebaseAuth(mockUser: MockUser(uid: "siuuuu"));
      await firebaseAuth.signInWithEmailAndPassword(
          email: "test@gmail.com", password: "kekw");
      await widgetTester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<DiscussionProvider>(
              create: ((context) => mockDiscussionProvider))
        ],
        child: MaterialApp(
            home: Scaffold(
          body: DiscussionAddPage(
            "tt12345",
            const Text("titanic"),
            authInstance: firebaseAuth,
          ),
        )),
      ));

      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(
          find.byKey(const Key("body-field")), "Test body");
      await widgetTester.tap(find.byType(TextButton));

      await widgetTester.pumpAndSettle();

      verifyNever(mockDiscussionProvider.addNewDiscussion(any));

      expect(find.byType(GenericDialog), findsOneWidget);
    });
  });
}
