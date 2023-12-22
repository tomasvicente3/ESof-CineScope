import 'dart:async';

import 'package:cinescope/controller/film_details_scraper.dart';
import 'package:cinescope/model/film.dart';
import 'package:cinescope/model/providers/required_provider.dart';
import 'package:cinescope/model/watchlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WatchlistProvider extends RequiredProvider {
  late final FirebaseAuth _authInstance;
  late final FirebaseFirestore _storeInstance;
  late final FilmDetailsScraper _filmDetailsScraper;

  WatchlistProvider(
      {FirebaseAuth? auth,
      FirebaseFirestore? store,
      FilmDetailsScraper? filmDetailsScraper})
      : _authInstance = auth ?? FirebaseAuth.instance,
        _storeInstance = store ?? FirebaseFirestore.instance,
        _filmDetailsScraper = filmDetailsScraper ?? FilmDetailsScraper(),
        super() {
    _getWatchlist();
    _authInstance.authStateChanges().listen(_authChange);
  }

  Watchlist _watchlist = Watchlist([]);
  Watchlist getWatchlist() => _watchlist;

  void _authChange(User? user) async {
    if (user == null) {
      loadedController.add(false);
    } else {
      await _getWatchlist();
    }
  }

  Future<void> _getWatchlist() async {
    if (_authInstance.currentUser != null) {
      try {
        final watchlistsRef = _storeInstance
            .collection("watchlists")
            .withConverter(
                fromFirestore: (snapshot, options) =>
                    Watchlist.fromFirestore(snapshot, options),
                toFirestore: (film, _) => film.toFirestore());
        _watchlist =
            (await watchlistsRef.doc(_authInstance.currentUser!.uid).get())
                .data()!;
        await _watchlist.parseFilmsInWatchlist(_filmDetailsScraper);
      } catch (e) {
        _watchlist = Watchlist([]);
      }

      notifyListeners();
      loadedController.add(true);
    }
  }

  Future<void> addFilmToWatchlist(String filmId) async {
    if (_watchlist.movieIds.contains(filmId)) return;
    _watchlist.movieIds.add(filmId);
    final watchlistsRef = _storeInstance.collection("watchlists").withConverter(
        fromFirestore: (snapshot, options) =>
            Watchlist.fromFirestore(snapshot, options),
        toFirestore: (film, _) => film.toFirestore());
    notifyListeners();
    await watchlistsRef.doc(_authInstance.currentUser!.uid).set(_watchlist);
    _filmDetailsScraper.getFilmDetails(filmId).then((value) {
      _watchlist.movies.add(value);
      notifyListeners();
    });
  }

  Future<void> removeFilmFromWatchlist(Film film) async {
    if (!_watchlist.movieIds.contains(film.id)) return;
    _watchlist.movieIds.remove(film.id);
    _watchlist.movies.remove(film);

    notifyListeners();
    final watchlistsRef = _storeInstance.collection("watchlists").withConverter(
        fromFirestore: (snapshot, options) =>
            Watchlist.fromFirestore(snapshot, options),
        toFirestore: (film, _) => film.toFirestore());

    await watchlistsRef.doc(_authInstance.currentUser!.uid).set(_watchlist);
  }
}
