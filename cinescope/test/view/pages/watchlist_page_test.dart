import 'package:cinescope/model/film.dart';
import 'package:cinescope/model/providers/watchlist_provider.dart';
import 'package:cinescope/model/watchlist.dart';
import 'package:cinescope/view/cards/generic_film_card.dart';
import 'package:cinescope/view/pages/watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import 'watchlist_page_test.mocks.dart';


@GenerateMocks(
  [],
  customMocks: [
    MockSpec<WatchlistProvider>(onMissingStub: OnMissingStub.returnDefault)
  ],
)
void main() {
  group("WatchlistPage", () {
    final film = Film(
        "1", 'Inception', 'Movie', 2010, 'https://via.placeholder.com/150');
    final filmteste = Film(
        "teste", 'Test film', 'Movie', 2069, 'https://via.placeholder.com/150');
    final filmteste2 = Film(
        "teste2", 'Bee Movie', 'Movie', 2010, 'https://via.placeholder.com/150');
    testWidgets("renders correctly all films on watchlist", (tester) async {
      Watchlist watchlist = Watchlist(["1", "teste", "teste2"]);
      watchlist.movies.add(film);
      watchlist.movies.add(filmteste);
      watchlist.movies.add(filmteste2);
      WatchlistProvider watchlistProvider = MockWatchlistProvider();
      when(watchlistProvider.getWatchlist()).thenReturn(watchlist);

      await mockNetworkImagesFor(() => tester.pumpWidget(MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => watchlistProvider)
            ],
            child: const MaterialApp(
              home: Scaffold(
                body: WatchlistPage(),
              ),
            ),
          )));
      expect(find.byType(GenericFilmCard), findsNWidgets(3));
      expect(find.text("Inception"), findsOneWidget);
      expect(find.text("Test film"), findsOneWidget);
      expect(find.text("Bee Movie"), findsOneWidget);

    });
  });
}
