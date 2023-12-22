import 'package:cinescope/model/discussion.dart';
import 'package:cinescope/model/providers/discussion_provider.dart';
import 'package:cinescope/model/providers/profile_provider.dart';
import 'package:cinescope/view/cards/page_message.dart';
import 'package:cinescope/view/general_page.dart';
import 'package:cinescope/view/pages/discussions/add_comment_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:provider/provider.dart';
import 'package:cinescope/view/cards/comment_card.dart';
import 'package:cinescope/view/cards/discussion_comments_header.dart';

class DiscussionCommentPage extends GeneralPage {
  final Discussion _currentDiscussion;

  DiscussionCommentPage(this._currentDiscussion, {super.key})
      : super(
            floatingActionButton: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 15, 15),
                child: FloatingActionButton(
                  backgroundColor: const Color(0xFFD7CCCF),
                  onPressed: () {
                    navService.push(MaterialPageRoute(
                        builder: (context) =>
                            CommentAddPage(_currentDiscussion, DiscussionCommentsHeader(_currentDiscussion))));
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.plus,
                    color: Colors.black,
                  ),
                )));

  @override
  State<StatefulWidget> createState() => DiscussionCommentPageState();
}

class DiscussionCommentPageState
    extends GeneralPageState<DiscussionCommentPage> {
  Future<List<Comment>> getProfilesOfComments(
      List<Comment> commentsToLoad, ProfileProvider provider) async {
    for (final comment in commentsToLoad) {
      comment.createdBy =
          await provider.getProfileByUid(uid: comment.createdById);
    }
    return commentsToLoad;
  }

  Widget renderCommentCard(List<Comment> comments) {
    List<Widget> cards = [];
    for (final comment in comments) {
      cards.add(const SizedBox(height: 7));
      cards.add(CommentCard(comment));
    }

    return Column(
      children: cards,
    );
  }

  @override
  List<Widget> getBody(BuildContext context) {
    return [
      Consumer<DiscussionProvider>(
          builder: (context, value, _) =>
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                DiscussionCommentsHeader(widget._currentDiscussion),
                Consumer<ProfileProvider>(
                  builder: (context, value, child) {
                    return FutureBuilder(
                        future: getProfilesOfComments(
                            widget._currentDiscussion.comments, value),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            snapshot.data!.sort((a, b) =>
                                b.creationTime.compareTo(a.creationTime));
                            return renderCommentCard(snapshot.data!);
                          }
                          if (snapshot.hasError) {
                            return const PageMessage(
                                "Something went wrong while getting the comments");
                          }
                          return const SizedBox(
                              height: 300,
                              child:
                                  Center(child: CircularProgressIndicator()));
                        }));
                  },
                )
              ]))
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
        "Comments",
        textAlign: TextAlign.left,
        textScaleFactor: 2.2,
      ),
    ]);
  }
}
