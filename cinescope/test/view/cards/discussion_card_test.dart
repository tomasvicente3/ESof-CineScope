import 'package:cinescope/model/discussion.dart';
import 'package:cinescope/model/profile.dart';
import 'package:cinescope/model/providers/discussion_provider.dart';
import 'package:cinescope/model/providers/profile_provider.dart';
import 'package:cinescope/view/cards/discussion_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'discussion_card_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<NavigatorObserver>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DiscussionProvider>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<ProfileProvider>(onMissingStub: OnMissingStub.returnDefault)
])
void main() {
  final Discussion discussion = Discussion(
      "1",
      "tt1234",
      "Discussion Title",
      "Discussion Description",
      "siuuuuuuu",
      DateTime(
        2022,
      ),
      [Comment("siuu", DateTime.now(), "siuuuuuuu")]);

  final Profile profile = Profile("Test User", "testing", "/", id: "siuuuuuuu");

  group('Discussion card', () {
    testWidgets("renders correctly", (widgetTester) async {
      //TODO: make datetime clock tests
      await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: DiscussionCard(
          discussion: discussion,
        )),
      ));
      expect(find.text("Discussion Title"), findsOneWidget);
      expect(find.text("Discussion Description"), findsOneWidget);
      expect(find.text("1"), findsNothing);
      expect(find.text("tt1234"), findsNothing);

      expect(find.text("1 comments"), findsOneWidget);
    });

    testWidgets("Changes to discussion page when clicked",
        (widgetTester) async {
      final mockObserver = MockNavigatorObserver();
      DiscussionProvider discussionProvider = MockDiscussionProvider();
      ProfileProvider profileProvider = MockProfileProvider();
      when(profileProvider.getProfileByUid(uid: "siuuuuuuu")).thenAnswer((realInvocation) async{
        return profile;
      });
      await widgetTester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => discussionProvider),
          ChangeNotifierProvider(create: (context) => profileProvider)

        ],
        child: MaterialApp(
            navigatorObservers: [mockObserver],
            home: Scaffold(
                body: DiscussionCard(
              discussion: discussion,
            ))),
      ));
      final clickableWidget = find.byType(GestureDetector);
      expect(clickableWidget, findsOneWidget);
      await widgetTester.tap(clickableWidget);
      await widgetTester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
    });
  });
}
