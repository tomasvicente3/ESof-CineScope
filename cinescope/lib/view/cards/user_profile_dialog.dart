import 'package:flutter/material.dart';
import 'package:cinescope/model/profile.dart';

class UserProfileDialog extends StatelessWidget {
  final Profile profile;

  const UserProfileDialog(this.profile, {Key? key}) : super(key: key);

  Widget getAvatar(Profile profile) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: profile.imageData != null
          ? CircleAvatar(
              radius: 100,
              backgroundImage: MemoryImage(profile.imageData!),
            )
          : const CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage("assets/profile-placeholder.png"),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(children: [
        getAvatar(profile),
        const SizedBox(height: 15),
        Text(
          profile.name,
          textScaleFactor: 1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
      ]),
      content: 
          Text(profile.bio, style: const TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
