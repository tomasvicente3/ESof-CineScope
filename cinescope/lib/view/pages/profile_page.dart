import 'package:cinescope/model/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cinescope/view/pages/main_login_page.dart';
import 'package:cinescope/view/general_page.dart';

class ProfilePage extends GeneralPage {
  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends GeneralPageState<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
    });
  }

  Future<void> _loadProfileData() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final profile = profileProvider.getProfile();
    _nameController.text = profile.name;
    _bioController.text = profile.bio;
  }

  @override
  Widget getTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        children: [
          const Text(
            "Your Profile",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          const Spacer(),
          _isEditing? const SizedBox() :
          IconButton(onPressed: _startEditing, icon: const Icon(Icons.edit),key:const Key("editProfile")),
          IconButton(
            key: const Key("logout"),
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                      TextButton(
                        key: const Key("logoutConfirm"),
                        child: const Text('Logout'),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainLoginPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  List<Widget> getBody(BuildContext context) {
    return [
      const SizedBox(height: 16),
      Consumer<ProfileProvider>(
        builder: (context, value, _) {
          final profile = value.getProfile();
          return GestureDetector(
            onTap: _isEditing ? _selectImage(value) : null,
            child: profile.imageData != null
                ? CircleAvatar(
                    key: const Key("profileImage"),
                    radius: 115,
                    backgroundImage: MemoryImage(profile.imageData!),
                  )
                : const CircleAvatar(
                    key: Key("profileImage"),
                    radius: 115,
                    backgroundImage: AssetImage(
                      "assets/profile-placeholder.png",
                    ),
                  ),
          );
        },
      ),
      const SizedBox(height: 25),
      Consumer<ProfileProvider>(
        builder: (context, value, _) {
          final profile = value.getProfile();
          return _isEditing
              ? TextField(
                  maxLines: 1,
                  controller: _nameController,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name",
                  ),
                  key: const Key("name"),
                )
              : Text(
                  profile.name.isNotEmpty ? profile.name : "What is your name?",
                  style: const TextStyle(
                      fontSize: 27, fontWeight: FontWeight.bold),
                  key: const Key("name"),
                  
                );
        },
      ),
      const SizedBox(height: 10),
      Consumer<ProfileProvider>(
        builder: (context, value, _) {
          final profile = value.getProfile();
          return _isEditing
              ? TextField(
                  maxLines: null,
                  controller: _bioController,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Bio",
                  ),
                  key: const Key("bio"),
                )
              : Text(
                  profile.bio.isNotEmpty
                      ? profile.bio
                      : "What do you want other people to know about you?",
                  style: const TextStyle(fontSize: 17),
                  key: const Key("bio"),
                );
        },
      ),
      const SizedBox(height: 25),
      Consumer<ProfileProvider>(
        builder: (context, value, _) {
          final profileProvider =
              Provider.of<ProfileProvider>(context, listen: false);
          return _isEditing
              ? Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            const Color(0XFFEC7873),
                          ),
                        ),
                        onPressed: () => _cancelEditing(profileProvider),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextButton(
                        key: const Key("saveChanges"),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            const Color(0XFF2C666E),
                          ),
                        ),
                        onPressed: () => _saveChanges(profileProvider),
                        child: const Text("Save Changes"),
                      ),
                    ),
                  ],
                )
              : const SizedBox();
        },
      ),
    ];
  }

  _selectImage(ProfileProvider profileProvider) {
    return () async {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;

      final profile = profileProvider.getProfile();
      final imageData = await pickedImage.readAsBytes();
      profile.imageData = imageData;
      profileProvider.rerender();
    };
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _cancelEditing(ProfileProvider profileProvider) {
    final profile = profileProvider.getProfile();
    setState(() {
      _isEditing = false;
      _nameController.text = profile.name;
      _bioController.text = profile.bio;
    });
  }

  void _saveChanges(ProfileProvider profileProvider) {
    final profile = profileProvider.getProfile();
    if (_nameController.text.isEmpty || _bioController.text.isEmpty) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        message: "Please fill all the fields",
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xFFD7CCCF),
        messageColor: Colors.black,
      ).show(context);
      return;
    }

    setState(() {
      profile.bio = _bioController.text;
      profile.name = _nameController.text;
      profileProvider.saveProfile(profile);
      _isEditing = false;
    });
  }
}
