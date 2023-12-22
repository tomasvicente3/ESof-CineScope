import 'package:cinescope/controller/film_details_scraper.dart';
import 'package:cinescope/model/film.dart';
import 'package:cinescope/model/providers/watchlist_provider.dart';
import 'package:cinescope/model/watchlist.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'film_provider_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<FilmDetailsScraper>(onMissingStub: OnMissingStub.returnDefault),
])
void main() {
  group("WatchlistProvider", () {
    final film = Film(
        "1", 'Inception', 'Movie', 2010, 'https://via.placeholder.com/150',
        description: "Very nice movie",
        cast: [],
        duration: "200 hours",
        rating: 10);
    final film2 = Film(
        "2", 'Interstellar', 'Movie', 2010, 'https://via.placeholder.com/150',
        description: "Very nice movie",
        cast: [],
        duration: "200 hours",
        rating: 10);
    final film3 = Film(
        "3", 'Tenet', 'Movie', 2010, 'https://via.placeholder.com/150',
        description: "Very nice movie",
        cast: [],
        duration: "200 hours",
        rating: 10);
    test("Gets all films correctly", () async {
      MockFirebaseAuth mockFirebaseAuth =
          MockFirebaseAuth(mockUser: MockUser(uid: "test-uid"), signedIn: true);

      FakeFirebaseFirestore firebaseFirestore = FakeFirebaseFirestore(
          authObject: mockFirebaseAuth.authForFakeFirestore);

      MockFilmDetailsScraper mockFilmDetailsScraper = MockFilmDetailsScraper();
      when(mockFilmDetailsScraper.getFilmDetails("1"))
          .thenAnswer((realInvocation) async {
        return film;
      });
      when(mockFilmDetailsScraper.getFilmDetails("2"))
          .thenAnswer((realInvocation) async {
        return film2;
      });
      when(mockFilmDetailsScraper.getFilmDetails("3"))
          .thenAnswer((realInvocation) async {
        return film3;
      });

      Watchlist watchlist = Watchlist(["1", "2", "3"]);

      await firebaseFirestore
          .collection("watchlists")
          .withConverter(
              fromFirestore: (snapshot, options) =>
                  Watchlist.fromFirestore(snapshot, options),
              toFirestore: (film, _) => film.toFirestore())
          .doc("test-uid")
          .set(watchlist);

      WatchlistProvider watchlistProvider = WatchlistProvider(
          auth: mockFirebaseAuth,
          store: firebaseFirestore,
          filmDetailsScraper: mockFilmDetailsScraper);

      await Future.delayed(const Duration(seconds: 5));

      Watchlist testWatchlist = watchlistProvider.getWatchlist();

      expect(testWatchlist.movieIds, ["1", "2", "3"]);
      expect(testWatchlist.movies[0], film);
      expect(testWatchlist.movies[1], film2);
      expect(testWatchlist.movies[2], film3);
    });

    test("Adds film to watchlist correctly", () async {
      MockFirebaseAuth mockFirebaseAuth =
          MockFirebaseAuth(mockUser: MockUser(uid: "test-uid"), signedIn: true);

      FakeFirebaseFirestore firebaseFirestore = FakeFirebaseFirestore(
          authObject: mockFirebaseAuth.authForFakeFirestore);

      MockFilmDetailsScraper mockFilmDetailsScraper = MockFilmDetailsScraper();
      when(mockFilmDetailsScraper.getFilmDetails("1"))
          .thenAnswer((realInvocation) async {
        return film;
      });
      when(mockFilmDetailsScraper.getFilmDetails("2"))
          .thenAnswer((realInvocation) async {
        return film2;
      });
      when(mockFilmDetailsScraper.getFilmDetails("3"))
          .thenAnswer((realInvocation) async {
        return film3;
      });

      Watchlist watchlist = Watchlist(["1", "2"]);

      await firebaseFirestore
          .collection("watchlists")
          .withConverter(
              fromFirestore: (snapshot, options) =>
                  Watchlist.fromFirestore(snapshot, options),
              toFirestore: (film, _) => film.toFirestore())
          .doc("test-uid")
          .set(watchlist);

      WatchlistProvider watchlistProvider = WatchlistProvider(
          auth: mockFirebaseAuth,
          store: firebaseFirestore,
          filmDetailsScraper: mockFilmDetailsScraper);

      await Future.delayed(const Duration(seconds: 5));

      await watchlistProvider.addFilmToWatchlist("3");

      Watchlist testWatchlist = (await firebaseFirestore
              .collection("watchlists")
              .withConverter(
                  fromFirestore: (snapshot, options) =>
                      Watchlist.fromFirestore(snapshot, options),
                  toFirestore: (film, _) => film.toFirestore())
              .doc("test-uid")
              .get())
          .data()!;
      expect(testWatchlist.movieIds, ["1", "2", "3"]);
      expect(watchlistProvider.getWatchlist().movies.length, 3);
    });

    test("Removes film from watchlist correctly", () async {
      MockFirebaseAuth mockFirebaseAuth =
          MockFirebaseAuth(mockUser: MockUser(uid: "test-uid"), signedIn: true);

      FakeFirebaseFirestore firebaseFirestore = FakeFirebaseFirestore(
          authObject: mockFirebaseAuth.authForFakeFirestore);

      MockFilmDetailsScraper mockFilmDetailsScraper = MockFilmDetailsScraper();
      when(mockFilmDetailsScraper.getFilmDetails("1"))
          .thenAnswer((realInvocation) async {
        return film;
      });
      when(mockFilmDetailsScraper.getFilmDetails("2"))
          .thenAnswer((realInvocation) async {
        return film2;
      });
      when(mockFilmDetailsScraper.getFilmDetails("3"))
          .thenAnswer((realInvocation) async {
        return film3;
      });

      Watchlist watchlist = Watchlist(["1", "2", "3"]);

      await firebaseFirestore
          .collection("watchlists")
          .withConverter(
              fromFirestore: (snapshot, options) =>
                  Watchlist.fromFirestore(snapshot, options),
              toFirestore: (film, _) => film.toFirestore())
          .doc("test-uid")
          .set(watchlist);

      WatchlistProvider watchlistProvider = WatchlistProvider(
          auth: mockFirebaseAuth,
          store: firebaseFirestore,
          filmDetailsScraper: mockFilmDetailsScraper);

      await Future.delayed(const Duration(seconds: 5));

      await watchlistProvider.removeFilmFromWatchlist(film3);

      Watchlist testWatchlist = (await firebaseFirestore
              .collection("watchlists")
              .withConverter(
                  fromFirestore: (snapshot, options) =>
                      Watchlist.fromFirestore(snapshot, options),
                  toFirestore: (film, _) => film.toFirestore())
              .doc("test-uid")
              .get())
          .data()!;
      expect(testWatchlist.movieIds, ["1", "2"]);

      expect(watchlistProvider.getWatchlist().movies.length, 2);
    });

    test("listens to auth changes and loads new watchlist", () async {
      MockFirebaseAuth mockFirebaseAuth =
          MockFirebaseAuth(mockUser: MockUser(uid: "test-uid"));

      FakeFirebaseFirestore firebaseFirestore = FakeFirebaseFirestore(
          authObject: mockFirebaseAuth.authForFakeFirestore);

      MockFilmDetailsScraper mockFilmDetailsScraper = MockFilmDetailsScraper();
      when(mockFilmDetailsScraper.getFilmDetails("1"))
          .thenAnswer((realInvocation) async {
        return film;
      });
      when(mockFilmDetailsScraper.getFilmDetails("2"))
          .thenAnswer((realInvocation) async {
        return film2;
      });
      when(mockFilmDetailsScraper.getFilmDetails("3"))
          .thenAnswer((realInvocation) async {
        return film3;
      });

      Watchlist watchlist = Watchlist(["1", "2", "3"]);

      await firebaseFirestore
          .collection("watchlists")
          .withConverter(
              fromFirestore: (snapshot, options) =>
                  Watchlist.fromFirestore(snapshot, options),
              toFirestore: (film, _) => film.toFirestore())
          .doc("test-uid")
          .set(watchlist);

      WatchlistProvider watchlistProvider = WatchlistProvider(
          auth: mockFirebaseAuth,
          store: firebaseFirestore,
          filmDetailsScraper: mockFilmDetailsScraper);

      await mockFirebaseAuth.signInWithEmailAndPassword(email: "email@email.com", password: "password");


      await Future.delayed(const Duration(seconds: 5));


      Watchlist testWatchlist = (await firebaseFirestore
              .collection("watchlists")
              .withConverter(
                  fromFirestore: (snapshot, options) =>
                      Watchlist.fromFirestore(snapshot, options),
                  toFirestore: (film, _) => film.toFirestore())
              .doc("test-uid")
              .get())
          .data()!;
      expect(testWatchlist.movieIds, ["1", "2", "3"]); 
      expect(watchlistProvider.getWatchlist().movies.length, 3);
    });
  });
}
