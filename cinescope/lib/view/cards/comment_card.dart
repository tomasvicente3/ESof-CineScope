import 'package:cinescope/model/discussion.dart';
import 'package:cinescope/model/profile.dart';
import 'package:cinescope/model/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cinescope/utils/duration_string_formatter.dart';
import 'package:provider/provider.dart';
import 'package:cinescope/view/cards/user_profile_dialog.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  const CommentCard(this.comment, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget getAvatar(Profile profile) {
      return FittedBox(
          fit: BoxFit.scaleDown,
          child: profile.imageData != null
              ? CircleAvatar(
                  radius: 20,
                  backgroundImage: MemoryImage(
                    profile.imageData!,
                  ))
              : const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(
                    "assets/profile-placeholder.png",
                  )));
    }

    Widget getProfileRow(BuildContext context, String uid) {
      return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return UserProfileDialog(snapshot.data!);
                      });
                },
                child: Row(
                  children: [
                    getAvatar(snapshot.data!),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                    ),
                    Text(
                      snapshot.data!.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textScaleFactor: 1.3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ));
          } else {
            return Container();
          }
        },
        future: Provider.of<ProfileProvider>(context, listen: false)
            .getProfileByUid(uid: uid),
      );
    }

    return Consumer<ProfileProvider>(builder: (context, provider, _) {
      return Card(
          key: const Key("comment-card"),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getProfileRow(context, comment.createdById),
                const Padding(
                  padding: EdgeInsets.all(7),
                ),
                Text(
                  comment.content,
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.clock,
                      size: 15,
                      color: Color(0xFFD7CCCF),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
                    Text(
                      DateTime.now()
                          .difference(comment.creationTime)
                          .toFormattedString("{} ago", "{} ago"),
                      style: const TextStyle(color: Color(0xFFD7CCCF)),
                      textScaleFactor: 0.9,
                    ),
                  ],
                ),
              ],
            ),
          ));
    });
  }
}
