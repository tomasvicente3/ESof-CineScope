import 'dart:async';

import 'package:cinescope/view/pages/main_page.dart';
import 'package:cinescope/view/pages/profile_page.dart';
import 'package:cinescope/view/pages/search_page.dart';
import 'package:cinescope/view/pages/watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<StatefulWidget> createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  bool _isVisible = true;
  late StreamSubscription<bool> keyboardVisibleSubscription;

  @override
  void initState() {
    super.initState();
    final keyboardVisibilityController = KeyboardVisibilityController();

    keyboardVisibleSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        _isVisible = !visible;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    keyboardVisibleSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return _isVisible
        ? Container(
            color: const Color(0xFFF0EDEE),
            height: 70,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const MainPage(),
                          transitionDuration: Duration.zero,
                        ),
                      );
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.house,
                      color: Colors.black,
                    ),
                    key: const Key("main"),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const ProfilePage(),
                          transitionDuration: Duration.zero,
                        ),
                      );
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.solidUser,
                      color: Colors.black,
                    ),
                    key: const Key("profile"),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const WatchlistPage(),
                          transitionDuration: Duration.zero,
                        ),
                      );
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.solidHeart,
                      color: Colors.black,
                    ),
                    key: const Key("watchlists"),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD7CCCF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 55,
                    width: 55,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const SearchPage(),
                            transitionDuration: Duration.zero,
                          ),
                        );
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.magnifyingGlass,
                        color: Colors.black,
                        size: 23,
                      ),
                      key: const Key("search"),
                    ),
                  )
                ]))
        : Container();
  }
}
