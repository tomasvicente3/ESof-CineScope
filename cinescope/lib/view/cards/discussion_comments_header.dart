import 'package:flutter/material.dart';
import 'package:cinescope/model/discussion.dart';

class DiscussionCommentsHeader extends StatelessWidget {
  final Discussion discussion;

  const DiscussionCommentsHeader(this.discussion, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            discussion.title,
            maxLines: null,
            textScaleFactor: 1.5,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            discussion.description,
            maxLines: null,
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        // Text(
        //   "Opened by ${discussion.createdBy!.name} ${DateTime.now().difference(discussion.creationDate).toFormattedString("{} ago", "{} ago")}",
        //   style: const TextStyle(color: Color(0xFFD7CCCF)),
        //   textScaleFactor: 0.9,
        // ),
        // const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        const Divider(),
        const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
      ],
    );
  }
}
