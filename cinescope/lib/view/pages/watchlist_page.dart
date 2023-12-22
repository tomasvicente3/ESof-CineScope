import 'package:cinescope/model/providers/watchlist_provider.dart';
import 'package:cinescope/view/cards/generic_film_card.dart';
import 'package:flutter/material.dart';

import 'package:cinescope/view/general_page.dart';
import 'package:provider/provider.dart';
import 'package:cinescope/view/cards/page_message.dart';

class WatchlistPage extends GeneralPage {
  const WatchlistPage({super.key});

  @override
  State<StatefulWidget> createState() => WatchlistPageState();
}

class WatchlistPageState extends GeneralPageState<WatchlistPage> {
  @override
  List<Widget> getBody(BuildContext context) {
    return [
      Consumer<WatchlistProvider>(
        builder: (context, value, _) {
          final List<Widget> cards = [];
          final Set<String> ids = {};
          if (value.getWatchlist().movies.isEmpty) {
            return const PageMessage("Your watchlist is empty");
          }
          int i = 0;
          for (final film in value.getWatchlist().movies) {
            if (ids.contains(value.getWatchlist().movies[i].id)) continue;
            cards.add(GenericFilmCard(film, key: Key("genericFilmCard-$i")));
            ids.add(film.id);
            i++;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cards,
          );
        },
      )
    ];
  }

  @override
  Widget getTitle(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Text("Your Watchlist",
            textAlign: TextAlign.left, textScaleFactor: 2.2));
  }
}
