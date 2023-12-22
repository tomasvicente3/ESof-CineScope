import 'package:cinescope/view/general_page.dart';
import 'package:cinescope/view/search_bar/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:cinescope/model/film.dart';
import 'package:cinescope/view/cards/generic_film_card.dart';
import 'package:cinescope/view/cards/page_message.dart';

class SearchPage extends GeneralPage {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() => SearchPageState();
}

class SearchPageState extends GeneralPageState<SearchPage> {
  List<Film> films = [];
  int searchTimes = 0;

  void setFilms(List<Film> results) {
    setState(() {
      films = results;
    });
  }

  @override
  List<Widget> getBody(BuildContext context) {
    if (films.isEmpty && searchTimes != 0) {
      return [const PageMessage("No results found", key: Key("errorNotFound"),)];
    }
    searchTimes++;

    List<Widget> cards = [];
    for (var i = 0; i < films.length; i++) {
      cards.add(const SizedBox(height: 7));
      cards.add(GenericFilmCard(films[i], key: Key("genericFilmCard-$i")));
    }
    return cards;
  }

  @override
  Widget getTitle(BuildContext context) {
    return AppSearchBar(
      pageState: this,
    );
  }
}
