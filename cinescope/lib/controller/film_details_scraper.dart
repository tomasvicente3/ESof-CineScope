import 'package:cinescope/model/film.dart';
import 'package:cinescope/controller/imdb_scrapper.dart';

class FilmDetailsScraper {
  Future<Film> getFilmDetails(String filmId) async {
    final filmData =
        await ImdbScraper.getFilmData("https://www.imdb.com/title/$filmId/");
    String title = filmData['title'];
    String type = filmData['type'];
    int year = filmData['year'];
    String imgUrl = filmData['imgUrl'];
    String duration = filmData['duration'];
    String description = filmData['description'];
    double rating = filmData['rating'].toDouble();
    List<dynamic> cast = filmData['cast'];

    final film = Film(filmId, title, type, year, imgUrl,
        duration: duration,
        description: description,
        rating: rating,
        cast: cast);
    return film;
  }
}
