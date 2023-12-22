import 'package:flutter/material.dart';

class DiscussionListHeader extends StatelessWidget {
  final String filmTitle;

  const DiscussionListHeader(this.filmTitle, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          filmTitle,
          maxLines: null,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
          textAlign: TextAlign.center,
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        const Divider(),
        const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
      ],
    );
  }
}
