import 'package:cinescope/model/discussion.dart';
import 'package:cinescope/model/providers/discussion_provider.dart';
import 'package:cinescope/view/general_page.dart';
import 'package:cinescope/view/simple_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscussionAddPage extends GeneralPage {
  final String filmId;
  final FirebaseAuth _firebaseAuth;
  final Widget header;
  DiscussionAddPage(this.filmId, this.header, {super.key, FirebaseAuth? authInstance}) 
    : _firebaseAuth = authInstance ?? FirebaseAuth.instance;

  @override
  State<StatefulWidget> createState() => DiscussionAddPageState();
}

class DiscussionAddPageState extends GeneralPageState<DiscussionAddPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  List<Widget> getBody(BuildContext context) {
    return [
      widget.header,
      TextField(
        key: const Key("title-field"),
        controller: _titleController,
        maxLines: 1,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: 'Title'),
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
      TextField(
        key: const Key("body-field"),
        controller: _bodyController,
        maxLines: null,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: 'Body'),
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
      Consumer<DiscussionProvider>(
          builder: (context, provider, _) => TextButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Color(0XFF2C666E))),
              onPressed: () {
                if (_titleController.text == '') {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const GenericDialog(
                            title: "Error:",
                            content: "You can't have an empty title");
                      });
                  return;
                }
                if (_bodyController.text == '') {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const GenericDialog(
                            title: "Error:",
                            content: "You can't have an empty body");
                      });
                  return;
                }
                provider
                    .addNewDiscussion(Discussion(
                        '',
                        widget.filmId,
                        _titleController.text,
                        _bodyController.text,
                        widget._firebaseAuth.currentUser!.uid,
                        DateTime.now(), []))
                    .then((value) => Navigator.of(context).pop());
              },
              child: const Text("Start your discussion")))
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
        "Add Discussion",
        textAlign: TextAlign.left,
        textScaleFactor: 2.2,
      ),
    ]);
  }
}
