import 'package:cinescope/model/discussion.dart';
import 'package:cinescope/model/providers/discussion_provider.dart';
import 'package:cinescope/view/general_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../simple_dialog.dart';

class CommentAddPage extends GeneralPage {
  final Discussion _discussion;
  final Widget header;
  final FirebaseAuth _firebaseAuth;

  CommentAddPage(this._discussion, this.header, {super.key, FirebaseAuth? authInstance})
      : _firebaseAuth = authInstance ?? FirebaseAuth.instance;
  @override
  State<StatefulWidget> createState() => CommentAddPageState();
}

class CommentAddPageState extends GeneralPageState<CommentAddPage> {
  final TextEditingController _editingController = TextEditingController();

  @override
  List<Widget> getBody(BuildContext context) {
    return [
      widget.header,
      TextField(
        key: const Key("comment-field"),
        controller: _editingController,
        maxLines: null,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: 'Comment'),
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
      Consumer<DiscussionProvider>(
          builder: (context, provider, _) => TextButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Color(0XFF2C666E))),
              onPressed: () {
                if (_editingController.text == '') {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const GenericDialog(
                            title: "Error",
                            content: "You can't have an empty comment");
                      });
                  return;
                }
                provider
                    .addCommentToDiscussion(
                        widget._discussion,
                        Comment(_editingController.text, DateTime.now(),
                            widget._firebaseAuth.currentUser!.uid))
                    .then((value) => Navigator.of(context).pop());
              },
              child: const Text("Send")))
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
        "Add Comment",
        textAlign: TextAlign.left,
        textScaleFactor: 2.2,
      ),
    ]);
  }
}
