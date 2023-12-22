import 'dart:collection';

import 'package:cinescope/model/providers/discussion_provider.dart';
import 'package:cinescope/view/cards/discussion_card.dart';
import 'package:cinescope/view/general_page.dart';
import 'package:cinescope/view/pages/discussions/add_discussion_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:provider/provider.dart';
import 'package:cinescope/model/discussion.dart';
import 'package:cinescope/view/cards/page_message.dart';
import 'package:cinescope/view/cards/discussion_list_header.dart';

class DiscussionListPage extends GeneralPage {
  final String filmId, filmTitle;
  DiscussionListPage(this.filmId, this.filmTitle, {super.key})
      : super(
            floatingActionButton: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 15, 15),
                child: FloatingActionButton(
                  backgroundColor: const Color(0xFFD7CCCF),
                  onPressed: () {
                    navService.push(MaterialPageRoute(
                        builder: (context) => DiscussionAddPage(filmId, DiscussionListHeader(filmTitle))));
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.plus,
                    color: Colors.black,
                  ),
                )));

  @override
  State<StatefulWidget> createState() => DiscussionListPageState();
}

class DiscussionListPageState extends GeneralPageState<DiscussionListPage> {

  Widget buildDiscussionCards(BuildContext context,
      UnmodifiableSetView<Discussion> discussions, String filmTitle) {
    List<Widget> cards = [];
    cards.add(DiscussionListHeader(widget.filmTitle));

    if (discussions.isEmpty) {
      cards.add(const PageMessage("No discussions for this film"));
    }

    for (final discussion in discussions) {
      cards.add(const SizedBox(height: 7));
      cards.add(DiscussionCard(discussion: discussion));
    }

    return Column(children: cards);
  }

  @override
  List<Widget> getBody(BuildContext context) {
    return [
      Consumer<DiscussionProvider>(
          builder: (context, provider, _) => FutureBuilder(
                future: provider.getDiscussionsByFilmId(widget.filmId),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return buildDiscussionCards(
                        context, snapshot.data!, widget.filmTitle);
                  } else if (!snapshot.hasError) {
                    return const SizedBox(
                        height: 300,
                        child: Center(child: CircularProgressIndicator()));
                  } else {
                    Logger().e("", snapshot.error);
                    return const PageMessage('Error loading discussions');
                  }
                }),
              )),
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
        "Discussions",
        textAlign: TextAlign.left,
        textScaleFactor: 2.2,
      ),
    ]);
  }
}
