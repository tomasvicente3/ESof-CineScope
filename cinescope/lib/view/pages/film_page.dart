import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinescope/model/film.dart';
import 'package:cinescope/model/providers/film_provider.dart';
import 'package:cinescope/model/providers/watchlist_provider.dart';
import 'package:cinescope/view/cards/page_message.dart';
import 'package:cinescope/view/cards/cast_card.dart';
import 'package:cinescope/view/general_page.dart';
import 'package:cinescope/view/pages/discussions/discussion_list_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FilmPage extends GeneralPage {
  final String id;
  const FilmPage(this.id, {super.key});

  @override
  State<StatefulWidget> createState() => FilmPageState();
}

class FilmPageState extends GeneralPageState<FilmPage> {
  List<Widget> buildCast(Film film) {
    List<Widget> cast = [];

    for (var actor in film.cast!) {
      cast.add(CastCard(actor: actor));
    }

    return cast;
  }

  @override
  List<Widget> getBody(BuildContext context) {
    final FilmProvider filmProvider = Provider.of<FilmProvider>(context);
    return [
      FutureBuilder(
        future: filmProvider.getFilm(widget.id),
        builder: ((BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null || snapshot.hasError) {
              return const PageMessage('No information available');
            } else {
              final Film film = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            film.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.left,
                            softWrap: true,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            key: const Key("filmTitle"),
                          ),
                          const SizedBox(height: 10),
                          Text("${film.type}  •  ${film.year}",
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.2,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              key: const Key("filmTypeAndYear")),
                          const SizedBox(height: 10),
                          if (film.duration!.isNotEmpty)
                            Text('Duration: ${film.duration}',
                                textAlign: TextAlign.left,
                                textScaleFactor: 1.2,
                                key: const Key("filmDuration")),
                          const SizedBox(height: 10),
                          if (film.rating != -1)
                            Text(
                              'Rating: ${film.rating}',
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.2,
                            ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Consumer<WatchlistProvider>(
                                  builder: (context, value, child) =>
                                      IconButton(
                                        key: const Key("watchlistButton"),
                                        icon: FaIcon(value
                                                .getWatchlist()
                                                .movieIds
                                                .contains(film.id)
                                            ? FontAwesomeIcons.solidHeart
                                            : FontAwesomeIcons.heart),
                                        onPressed: () {
                                          if (value
                                              .getWatchlist()
                                              .movieIds
                                              .contains(film.id)) {
                                            value.removeFilmFromWatchlist(film);
                                          } else {
                                            value.addFilmToWatchlist(film.id);
                                          }
                                        },
                                        iconSize: 30,
                                        color: Colors.black,
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith((states) =>
                                                        const Color(
                                                            0xffD7CCCF))),
                                      )),
                              const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10)),
                              IconButton(
                                  icon: const FaIcon(FontAwesomeIcons.comment),
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DiscussionListPage(
                                                  widget.id, film.title))),
                                  iconSize: 30,
                                  color: Colors.black,
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) =>
                                                  const Color(0xffD7CCCF)))),
                            ],
                          )
                        ],
                      )),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5)),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            width: 150,
                            imageUrl: film.imgUrl,
                            placeholder: (context, _) => const Image(
                                width: 150,
                                image: AssetImage(
                                    'assets/default-movie-image.png')),
                            errorWidget: (content, _, a) => const Image(
                                width: 150,
                                image: AssetImage(
                                    'assets/default-movie-image.png')),
                          )),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  Text(
                    film.description!,
                    textAlign: TextAlign.justify,
                    textScaleFactor: 1.2,
                    key: const Key("filmDescription"),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Cast',
                    textAlign: TextAlign.left,
                    textScaleFactor: 1.8,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 280),
                      child: ListView(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: buildCast(film),
                      )),
                ],
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }),
      )
    ];
  }

  @override
  Widget getTitle(BuildContext context) {
    return Row(children: [
      IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
        iconSize: 40,
      ),
      const SizedBox(width: 10),
      const Text(
        "Film Details",
        textAlign: TextAlign.left,
        textScaleFactor: 2.2,
      ),
    ]);
  }
}
