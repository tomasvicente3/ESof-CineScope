import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinescope/model/providers/film_provider.dart';
import 'package:cinescope/model/providers/watchlist_provider.dart';
import 'package:cinescope/model/watchlist.dart';
import 'package:cinescope/view/cards/generic_film_card.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:cinescope/model/film.dart';
import 'package:cinescope/view/pages/film_page.dart';
import 'package:mockito/annotations.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'generic_film_card_test.mocks.dart';

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<NavigatorObserver>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<WatchlistProvider>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<FilmProvider>(onMissingStub: OnMissingStub.returnDefault)
  ],
)
void main() {
  group('GenericFilmCard', () {
    final film = Film(
        "1", 'Inception', 'Movie', 2010, 'https://via.placeholder.com/150');

    testWidgets('renders film title', (tester) async {
      await mockNetworkImagesFor(() => tester.pumpWidget(MultiProvider(
            providers: [
              //list of providers to add
              ChangeNotifierProvider(
                  create: (context) => WatchlistProvider(
                      auth: MockFirebaseAuth(),
                      store: FakeFirebaseFirestore())),
              
            ],
            child: MaterialApp(
              home: Scaffold(
                body: GenericFilmCard(film),
              ),
            ),
          )));

      expect(find.text('Inception'), findsOneWidget);
    });

    testWidgets('navigates to film page on tap', (tester) async {
      await mockNetworkImagesFor(() => tester.pumpWidget(MultiProvider(
            providers: [
              //list of providers to add
              ChangeNotifierProvider(
                  create: (context) => WatchlistProvider(
                      auth: MockFirebaseAuth(),
                      store: FakeFirebaseFirestore())),
              ChangeNotifierProvider(create: (context) => FilmProvider())
            ],
            child: MaterialApp(
              home: Scaffold(
                body: GenericFilmCard(film),
              ),
            ),
          )));

      await tester.tap(find.byKey(const Key("genericFilmCard")));
      await tester.pumpAndSettle();

      expect(find.byType(FilmPage), findsOneWidget);
    });

    testWidgets('renders film type and year', (tester) async {
      await mockNetworkImagesFor(() => tester.pumpWidget(MultiProvider(
            providers: [
              //list of providers to add
              ChangeNotifierProvider(
                  create: (context) => WatchlistProvider(
                      auth: MockFirebaseAuth(),
                      store: FakeFirebaseFirestore())),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: GenericFilmCard(film),
              ),
            ),
          )));

      expect(find.text('Movie  •  2010'), findsOneWidget);
    });

    testWidgets('renders film image', (tester) async {
      await mockNetworkImagesFor(() => tester.pumpWidget(MultiProvider(
            providers: [
              //list of providers to add
              ChangeNotifierProvider(
                  create: (context) => WatchlistProvider(
                      auth: MockFirebaseAuth(),
                      store: FakeFirebaseFirestore())),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: GenericFilmCard(film),
              ),
            ),
          )));

      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('displays film title with correct font style', (tester) async {
      await mockNetworkImagesFor(() => tester.pumpWidget(MultiProvider(
            providers: [
              //list of providers to add
              ChangeNotifierProvider(
                  create: (context) => WatchlistProvider(
                      auth: MockFirebaseAuth(),
                      store: FakeFirebaseFirestore())),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: GenericFilmCard(film),
              ),
            ),
          )));

      final titleFinder = find.text('Inception');
      final titleWidget = tester.widget<Text>(titleFinder);

      expect(titleWidget.style!.fontWeight, FontWeight.bold);
      expect(titleWidget.style!.fontSize, 22);
    });

    testWidgets('displays film type and year with correct font style',
        (tester) async {
      await mockNetworkImagesFor(() => tester.pumpWidget(MultiProvider(
            providers: [
              //list of providers to add
              ChangeNotifierProvider(
                  create: (context) => WatchlistProvider(
                      auth: MockFirebaseAuth(),
                      store: FakeFirebaseFirestore())),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: GenericFilmCard(film),
              ),
            ),
          )));

      final typeYearFinder = find.text('Movie  •  2010');
      final typeYearWidget = tester.widget<Text>(typeYearFinder);

      expect(typeYearWidget.style!.fontSize, 18);
    });

    testWidgets('tries to add film to watchlist', (tester) async {
      WatchlistProvider mockProvider = MockWatchlistProvider();
      when(mockProvider.getWatchlist()).thenReturn(Watchlist([]));
      when(mockProvider.addFilmToWatchlist(film.id)).thenAnswer((realInvocation) async {
        when(mockProvider.getWatchlist()).thenReturn(Watchlist([film.id]));
      });
      await mockNetworkImagesFor(() => tester.pumpWidget(MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => mockProvider)
            ],
            child: MaterialApp(
              home: Scaffold(
                body: GenericFilmCard(film),
              ),
            ),
          )));
      final widgetButton = find.byType(IconButton);
      expect(widgetButton, findsOneWidget);

      await tester.tap(widgetButton);
      await tester.pumpAndSettle();
      verify(mockProvider.addFilmToWatchlist(film.id)).called(1);
      verifyNever(mockProvider.removeFilmFromWatchlist(film));

    });

    testWidgets('tries to remove film to watchlist', (tester) async {
      WatchlistProvider mockProvider = MockWatchlistProvider();
      when(mockProvider.getWatchlist()).thenReturn(Watchlist([film.id]));
      when(mockProvider.removeFilmFromWatchlist(film)).thenAnswer((realInvocation) async {
        when(mockProvider.getWatchlist()).thenReturn(Watchlist([]));
      });
      await mockNetworkImagesFor(() => tester.pumpWidget(MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => mockProvider)
            ],
            child: MaterialApp(
              home: Scaffold(
                body: GenericFilmCard(film),
              ),
            ),
          )));
      final widgetButton = find.byType(IconButton);
      expect(widgetButton, findsOneWidget);
      await tester.tap(widgetButton);
      await tester.pumpAndSettle();
      verify(mockProvider.removeFilmFromWatchlist(film)).called(1);
      verifyNever(mockProvider.addFilmToWatchlist(film.id));
    });

    });
}
