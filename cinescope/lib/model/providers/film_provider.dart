import 'package:cinescope/controller/film_details_scraper.dart';
import 'package:cinescope/model/film.dart';
import 'package:flutter/material.dart';

class FilmProvider extends ChangeNotifier {
  final Map<String, Film> _cachedFilms = {};

  final FilmDetailsScraper _filmDetailsScraper;

  FilmProvider({FilmDetailsScraper? filmDetailsScraper})
      : _filmDetailsScraper = filmDetailsScraper ?? FilmDetailsScraper();

  Future<Film> getFilm(String filmId) async {
    if (_cachedFilms[filmId] != null) {
      return _cachedFilms[filmId]!;
    }
    final Film newFilm = await _filmDetailsScraper.getFilmDetails(filmId);
    _cachedFilms[filmId] = newFilm;
    return newFilm;
  }
}
