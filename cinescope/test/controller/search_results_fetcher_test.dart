import 'package:flutter_test/flutter_test.dart';
import 'package:cinescope/controller/search_results_fetcher.dart';
import 'package:cinescope/model/film.dart';

void main() {
  group('SearchResultsFetcher', () {
    const dynamic data = {
      "d": [
        {
          "i": {
            "height": 2048,
            "imageUrl":
                "https://m.media-amazon.com/images/M/MV5BMjE1MDYxOTA4MF5BMl5BanBnXkFtZTcwMDE0MDUzMw@@._V1_.jpg",
            "width": 1382
          },
          "id": "tt0389790",
          "l": "Bee Movie",
          "q": "feature",
          "qid": "movie",
          "rank": 4889,
          "s": "Jerry Seinfeld, Renée Zellweger",
          "y": 2007
        },
        {
          "i": {
            "height": 2835,
            "imageUrl":
                "https://m.media-amazon.com/images/M/MV5BMjE3NTYyMjQwMV5BMl5BanBnXkFtZTgwNzk5MjQxMzE@._V1_.jpg",
            "width": 1984
          },
          "id": "tt3336368",
          "l": "Maya the Bee Movie",
          "q": "feature",
          "qid": "movie",
          "rank": 61289,
          "s": "Jacki Weaver, Miriam Margolyes",
          "y": 2014
        },
        {
          "i": {
            "height": 1800,
            "imageUrl":
                "https://m.media-amazon.com/images/M/MV5BNmRjOTY3Y2ItOGQ1Ni00MDlhLTllZjItMzA5ZGNjOTIyZTUxXkEyXkFqcGdeQXVyMTA0MTM5NjI2._V1_.jpg",
            "width": 1200
          },
          "id": "tt1152817",
          "l": "Bee Movie Game",
          "q": "video game",
          "qid": "videoGame",
          "rank": 93107,
          "s": "Animation, Action, Adventure",
          "y": 2007
        },
        {
          "id": "tt22461166",
          "l": "Bee Movie: Repollinated",
          "q": "feature",
          "qid": "movie",
          "rank": 543068,
          "s": ""
        },
        {
          "id": "tt3340430",
          "l": "Bobbee Bee the Hater the Movie",
          "q": "feature",
          "qid": "movie",
          "rank": 669676,
          "s": "William Shakur Graham",
          "y": 2013
        },
        {
          "i": {
            "height": 1500,
            "imageUrl":
                "https://m.media-amazon.com/images/M/MV5BYWYyZWU5NzctYjY4Zi00MzYyLTgxZTMtZjBmYWE2NGMwYTllXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_.jpg",
            "width": 1013
          },
          "id": "tt15486810",
          "l": "Teen Wolf: The Movie",
          "q": "feature",
          "qid": "movie",
          "rank": 1201,
          "s": "Tyler Posey, Crystal Reed",
          "y": 2023
        },
        {
          "i": {
            "height": 2048,
            "imageUrl":
                "https://m.media-amazon.com/images/M/MV5BMTkzMzM3OTM2Ml5BMl5BanBnXkFtZTgwMDM0NDU3MjI@._V1_.jpg",
            "width": 1382
          },
          "id": "tt4877122",
          "l": "The Emoji Movie",
          "q": "feature",
          "qid": "movie",
          "rank": 4908,
          "s": "T.J. Miller, James Corden",
          "y": 2017
        },
        {
          "i": {
            "height": 2560,
            "imageUrl":
                "https://m.media-amazon.com/images/M/MV5BMTE5NmEyYjctNzNhMi00YjI2LTgwZTctZWZjODgwNjA4M2E4XkEyXkFqcGdeQXVyODcxOTE0Mzc@._V1_.jpg",
            "width": 1920
          },
          "id": "tt13186528",
          "l": "Ben 10 vs. the Universe: The Movie",
          "q": "TV movie",
          "qid": "tvMovie",
          "rank": 49313,
          "s": "Tara Strong, Montse Hernandez",
          "y": 2020
        }
      ],
      "q": "bee%20movie",
      "v": 1
    };

    test('searchParser parses data correctly', () {
      List<Film> expectedFilms = [
        Film("tt0389790", "Bee Movie", "Movie", 2007, "https://m.media-amazon.com/images/M/MV5BMjE1MDYxOTA4MF5BMl5BanBnXkFtZTcwMDE0MDUzMw@@._V1_.jpg",),
        Film("tt3336368", "Maya the Bee Movie", "Movie", 2014, "https://m.media-amazon.com/images/M/MV5BMjE3NTYyMjQwMV5BMl5BanBnXkFtZTgwNzk5MjQxMzE@._V1_.jpg",),
        Film("tt22461166", "Bee Movie: Repollinated", "Movie", -1, ""),
        Film("tt3340430", "Bobbee Bee the Hater the Movie", "Movie", 2013, ""),
        Film("tt15486810", "Teen Wolf: The Movie", "Movie", 2023, "https://m.media-amazon.com/images/M/MV5BYWYyZWU5NzctYjY4Zi00MzYyLTgxZTMtZjBmYWE2NGMwYTllXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_.jpg",),
        Film("tt4877122", "The Emoji Movie", "Movie", 2017, "https://m.media-amazon.com/images/M/MV5BMTkzMzM3OTM2Ml5BMl5BanBnXkFtZTgwMDM0NDU3MjI@._V1_.jpg",),
        Film("tt13186528", "Ben 10 vs. the Universe: The Movie", "Movie", 2020, "https://m.media-amazon.com/images/M/MV5BMTE5NmEyYjctNzNhMi00YjI2LTgwZTctZWZjODgwNjA4M2E4XkEyXkFqcGdeQXVyODcxOTE0Mzc@._V1_.jpg",),
      ];
      final parsedFilms = SearchResultsFetcher.searchParser(data);
      expect(parsedFilms, expectedFilms);
    });
  });
}
