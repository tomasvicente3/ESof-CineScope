import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinescope/model/providers/watchlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:cinescope/model/film.dart';
import 'package:cinescope/view/pages/film_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class GenericFilmCard extends StatelessWidget {
  final Film film;

  const GenericFilmCard(this.film, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: const Key("genericFilmCard"),
        onTap: () {
          print("****** OPEN FILM PAGE: ${film.id}");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FilmPage(film.id)),
          );
        },
        child: Stack(alignment: Alignment.bottomCenter, children: [
          Card(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      width: 100,
                      imageUrl: film.imgUrl,
                      placeholder: (context, _) => const Image(
                          width: 100,
                          image: AssetImage('assets/default-movie-image.png')),
                      errorWidget: (content, _, a) => const Image(
                          width: 100,
                          image: AssetImage('assets/default-movie-image.png')),
                    )),
                const SizedBox(width: 16),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              film.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              (film.year == -1)
                                  ? film.type
                                  : "${film.type}  •  ${film.year}",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ))),
              ],
            ),
          ),
          Consumer<WatchlistProvider>(builder: (context, provider, _) {
            return Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: FaIcon(provider.getWatchlist().movieIds.contains(film.id)
                    ? FontAwesomeIcons.solidHeart
                    : FontAwesomeIcons.heart),
                onPressed: () {
                  if (provider.getWatchlist().movieIds.contains(film.id)) {
                    provider.removeFilmFromWatchlist(film);
                  } else {
                    provider.addFilmToWatchlist(film.id);
                  }
                },
                iconSize: 30,
                color: Colors.black,
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => const Color(0xffD7CCCF))),
              ),
            );
          }),
        ]));
  }
}
