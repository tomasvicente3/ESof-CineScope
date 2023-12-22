import 'package:cinescope/model/providers/profile_provider.dart';
import 'package:cinescope/model/providers/watchlist_provider.dart';
import 'package:cinescope/view/pages/main_page.dart';
import 'package:cinescope/view/pages/register_page.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'register_page_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<WatchlistProvider>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<ProfileProvider>(onMissingStub: OnMissingStub.returnDefault),
])
void main() {
  group("RegisterPage", () {
    testWidgets("Works correctly with valid input", (widgetTester) async {
      MockFirebaseAuth mockFirebaseAuth =
          MockFirebaseAuth(mockUser: MockUser(uid: "test-user"));

      FakeFirebaseFirestore fakeFirebaseFirestore = FakeFirebaseFirestore(
          authObject: mockFirebaseAuth.authForFakeFirestore);

      MockWatchlistProvider mockWatchlistProvider = MockWatchlistProvider();

      when(mockWatchlistProvider.lastLoaded).thenReturn(true);

      WatchlistProvider watchlistProvider = mockWatchlistProvider;
      
      MockProfileProvider mockProfileProvider = MockProfileProvider();

      when(mockProfileProvider.lastLoaded).thenReturn(true);

      ProfileProvider profileProvider = mockProfileProvider;

      await widgetTester.pumpWidget(MultiProvider(providers:[
        ChangeNotifierProvider(create: (context) => watchlistProvider),
        ChangeNotifierProvider(create: (context) => profileProvider),

      ], child:MaterialApp(
        home: Scaffold(
            body: RegisterPage(
          firebaseAuth: mockFirebaseAuth,
          firebaseFirestore: fakeFirebaseFirestore,
        )),
      )));

      await widgetTester.enterText(
          find.byKey(const Key("emailField")), "grelha@sirze.pt");
      await widgetTester.enterText(find.byKey(const Key("passwordField")),
          "ninguempodesaberestapassword");
      await widgetTester.enterText(
          find.byKey(const Key("confirmPasswordField")),
          "ninguempodesaberestapassword");
      await widgetTester.tap(find.byKey(const Key("registerButton")));

      await widgetTester.pumpAndSettle();

      expect(find.byType(MainPage), findsOneWidget);

      expect(mockFirebaseAuth.currentUser, isNotNull);
    });
  });
}
