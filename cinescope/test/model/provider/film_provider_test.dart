import 'package:cinescope/controller/film_details_scraper.dart';
import 'package:cinescope/model/film.dart';
import 'package:cinescope/model/providers/film_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'film_provider_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<FilmDetailsScraper>(onMissingStub: OnMissingStub.returnDefault)
])
void main() {
  group("FilmProvider", () {

    final film =
        Film("1", 'Inception', 'Movie', 2010, 'https://via.placeholder.com/150',
            description: "Very nice movie",
            cast: [],
            duration: "200 hours",
            rating: 10);
    test("caches film correctly", () async {
      MockFilmDetailsScraper filmDetailsScraper = MockFilmDetailsScraper();

      when(filmDetailsScraper.getFilmDetails(any)).thenAnswer((realInvocation) async {
        return film;
      });

      FilmProvider filmProvider = FilmProvider(filmDetailsScraper: filmDetailsScraper);

      Film receivedFilm = await filmProvider.getFilm("1");
      expect(receivedFilm.title, film.title);

      receivedFilm = await filmProvider.getFilm("1");
      expect(receivedFilm.title, film.title);

      verify(filmDetailsScraper.getFilmDetails(any)).called(1);


    });
  });
}
