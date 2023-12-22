import 'package:cinescope/model/film.dart';
import 'package:cinescope/model/providers/film_provider.dart';
import 'package:cinescope/model/providers/watchlist_provider.dart';
import 'package:cinescope/model/watchlist.dart';
import 'package:cinescope/view/pages/film_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import 'film_page_test.mocks.dart';

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<WatchlistProvider>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<FilmProvider>(onMissingStub: OnMissingStub.returnDefault)
  ],
)
void main() {
  group("FilmPage", () {
    final film =
        Film("1", 'Inception', 'Movie', 2010, 'https://via.placeholder.com/150',
            description: "Very nice movie",
            cast: [],
            duration: "200 hours",
            rating: 10);
    testWidgets("renders correctly", (tester) async {
      WatchlistProvider mockProvider = MockWatchlistProvider();
      when(mockProvider.getWatchlist()).thenReturn(Watchlist([]));
      FilmProvider filmProvider = MockFilmProvider();
      when(filmProvider.getFilm(film.id)).thenAnswer((realInvocation) async {
        return film;
      });
      //This is due to the test font, not an optimal solution, but it be reverted
      //when we will have our custom font
      final prevOnError = FlutterError.onError;
      FlutterError.onError = null;
      await mockNetworkImagesFor(() => tester.pumpWidget(MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => mockProvider),
              ChangeNotifierProvider(create: (context) => filmProvider)
            ],
            child: MaterialApp(
              home: Scaffold(
                body: FilmPage(
                  film.id,
                ),
              ),
            ),
          )));
      await tester.pumpAndSettle();
      FlutterError.onError = prevOnError;

      expect(find.text(film.title), findsOneWidget);
      expect(find.text("${film.type}  •  ${film.year}"), findsOneWidget);
    });
  });
}
