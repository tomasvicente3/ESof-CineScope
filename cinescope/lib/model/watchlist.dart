import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/film_details_scraper.dart';
import 'film.dart';

class Watchlist {
  final List<String> movieIds;
  late List<Film> movies = [];
  Watchlist(this.movieIds);

  factory Watchlist.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception("Something went wrong while building ");
    }
    List<String> ids = [];
    for (var element in data["movies"]) {
      ids.add(element);
    }
    //TODO: make parse of this ids in future to get full information
    return Watchlist(ids);
  }

  Map<String, dynamic> toFirestore() => {"movies": movieIds};

  Future<void> parseFilmsInWatchlist(FilmDetailsScraper filmDetailsScraper) async{
    movies.clear();
    for(String filmId in movieIds){
      movies.add(await filmDetailsScraper.getFilmDetails(filmId));
    }
  }
}
