import 'package:http/http.dart' as http;
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'dart:convert';

class ImdbScraper {
  static Future<dynamic> _getData(String imdbUrl) async {
    final response = await http.get(Uri.parse(imdbUrl));

    if (response.statusCode == 200) {
      final String htmlString = response.body;
      final Document document = parser.parse(htmlString);

      final Element? element = document.getElementById('__NEXT_DATA__');
      if (element == null) {
        throw Exception('Failed to find __NEXT_DATA__ element');
      }

      final String jsonData = element.text;
      final dynamic data = jsonDecode(jsonData);
      return data;
    } else {
      throw Exception('Failed to load movie data');
    }
  }

  static Map<String, dynamic> dataParser(dynamic data) {
    final Map<String, dynamic> base = data["props"]["pageProps"];
    final List<dynamic> castJSon = base['mainColumnData']['cast']['edges'];
    final List<dynamic> cast = [];

    for (int i = 0; i < castJSon.length; i++) {
      var current = castJSon[i];
      Map<dynamic, dynamic> result = {};

      final String id = current['node']['name']['id'];
      final String name = current['node']['name']['nameText']['text'];
      String actorImgUrl =
          castJSon[i]['node']['name']['primaryImage']?['url'] ?? '';

      final List<String> characters = [];

      final List<dynamic> charactersJSon =
          castJSon[i]['node']['characters'] ?? [];

      for (int j = 0; j < charactersJSon.length; j++) {
        characters.add(charactersJSon[j]['name']);
      }

      result['id'] = id;
      result['name'] = name;
      result['imgUrl'] = actorImgUrl;
      result['characters'] = characters;

      cast.add(result);
    }


    String title = base["aboveTheFoldData"]["titleText"]["text"];
    int year = base["aboveTheFoldData"]["releaseYear"]["year"];
    String imgUrl = base["aboveTheFoldData"]["primaryImage"]["url"] ?? '';
    String duration = base["aboveTheFoldData"]["runtime"]
            ?["displayableProperty"]["value"]["plainText"] ??
        "";
    String description =
        base["aboveTheFoldData"]["plot"]["plotText"]["plainText"];
    dynamic rating =
        base["aboveTheFoldData"]["ratingsSummary"]["aggregateRating"] ?? -1;
    String type = base["aboveTheFoldData"]["titleType"]["text"] ?? "";

    final Map<String, dynamic> filmData = {
      'title': title,
      'year': year,
      'imgUrl': imgUrl,
      'duration': duration,
      'description': description,
      'rating': rating,
      'cast': cast,
      'type': type,
    };

    return filmData;
  }

  static Future<Map<String, dynamic>> getFilmData(String imdbUrl) async {
    final dynamic data = await _getData(imdbUrl);
    return dataParser(data);
  }
}
