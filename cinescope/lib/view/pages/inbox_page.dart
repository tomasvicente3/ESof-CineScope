import 'package:cinescope/view/general_page.dart';
import 'package:flutter/material.dart';

class InboxPage extends GeneralPage {
  const InboxPage({super.key});

  @override
  State<StatefulWidget> createState() => InboxPageState();
}

class InboxPageState extends GeneralPageState<InboxPage> {
  @override
  List<Widget> getBody(BuildContext context) {
    return [];
  }

  @override
  Widget getTitle(BuildContext context) {
    return const Text(
      "Inbox:",
      textAlign: TextAlign.left,
      textScaleFactor: 2.2,
    );
  }
}
