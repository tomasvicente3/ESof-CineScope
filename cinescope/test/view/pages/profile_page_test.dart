import 'dart:io';

import 'package:cinescope/model/profile.dart';
import 'package:cinescope/model/providers/profile_provider.dart';
import 'package:cinescope/view/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'profile_page_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<ProfileProvider>(onMissingStub: OnMissingStub.returnDefault)
])
void main() {
  group("ProfilePage", () {
    final profileImage =
        File("assets/default-movie-image.png").readAsBytesSync();

    final profile = Profile("Dobby", "Adoro o whiplash", "picPath",
        id: "dobby", imageData: profileImage);
    testWidgets("is not editable at the start and shows correctly",
        (widgetTester) async {
      MockProfileProvider mockProfileProvider = MockProfileProvider();

      when(mockProfileProvider.getProfile()).thenReturn(profile);

      ProfileProvider profileProvider = mockProfileProvider;

      await widgetTester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => profileProvider)
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: ProfilePage(),
          ),
        ),
      ));

      await widgetTester.pumpAndSettle();

      expect(find.byType(TextField), findsNothing);

      final circleAvatar = widgetTester.widget<CircleAvatar>(find.byKey(const Key("profileImage")));

      expect((circleAvatar.backgroundImage as MemoryImage).bytes, profileImage);
      expect(find.text(profile.name), findsOneWidget);
      expect(find.text(profile.bio), findsOneWidget);
    });

    testWidgets("calls provider when changes are saved", (widgetTester) async {
      MockProfileProvider mockProfileProvider = MockProfileProvider();

      when(mockProfileProvider.getProfile()).thenReturn(profile);

      ProfileProvider profileProvider = mockProfileProvider;

      await widgetTester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => profileProvider)
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: ProfilePage(),
          ),
        ),
      ));

      await widgetTester.tap(find.byKey(const Key("editProfile")));
      await widgetTester.pumpAndSettle();


    });
  });
}
