import 'package:cinescope/model/film.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchResultsFetcher {
  static Future<dynamic> _getSearchData(String text) async {
    final String searchUrl =
        "https://v3.sg.media-imdb.com/suggestion/x/$text.json";
    final response = await http.get(Uri.parse(searchUrl));
    if (response.statusCode == 200) {
      String jsonData = response.body;
      final dynamic data = jsonDecode(utf8.decode(jsonData.codeUnits));
      return data;
    } else {
      throw Exception('Failed to load movie data');
    }
  }

  static List<Film> searchParser(dynamic data) {
    List<Film> films = [];

    for (int i = 0; i < data["d"].length; i++) {
      var current = data["d"][i];
      String id = current["id"];
      if (!id.contains("tt")) continue;

      String title = current["l"];
      int year = current["y"]?.toInt() ?? -1;
      String imgUrl = current["i"]?["imageUrl"] ?? '';
      String type = current["qid"];
      if (type.contains("movie") || type.contains("Movie")) {
        type = "Movie";
      } else if (type == "tvSeries") {
        type = "TV Series";
      } else {
        continue;
      }
      final film = Film(id, title, type, year, imgUrl);
      films.add(film);
    }
    return films;
  }

  static Future<List<Film>> getSearchResults(String text) async {
    dynamic data = await _getSearchData(text);
    return searchParser(data);
  }
}
