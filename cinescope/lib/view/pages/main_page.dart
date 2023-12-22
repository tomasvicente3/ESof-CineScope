import 'package:cinescope/view/general_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainPage extends GeneralPage {
  const MainPage({super.key}) : super(needsProviders: true);
  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends GeneralPageState<MainPage> {
  @override
  List<Widget> getBody(BuildContext context) {
    return [
      const Text(
        "Welcome to",
        textAlign: TextAlign.center,
        textScaleFactor: 2,
      ),
      const Padding(
        padding: EdgeInsets.all(20),
      ),
      Image.asset(
        "assets/logo-no-background.png",
        color: Colors.white,
      ),
      const Padding(
        padding: EdgeInsets.all(20),
      ),
      const Text(
        "Bringing film lovers together",
        textAlign: TextAlign.center,
        textScaleFactor: 1.5,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Color(0XFFC4C4C4),
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.all(30),
      ),
      SizedBox(
        height: 350,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context)
                    .size
                    .width - 70,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0XFFC4C4C4),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          [
                            "assets/search.svg",
                            "assets/watchlist.svg",
                            "assets/questions.svg",
                            "assets/chat.svg",
                          ][index],
                          width: 250,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          [
                            "Search for any film or series",
                            "Add your favourite results to your watchlist",
                            "Open discussions and share opinions",
                            "Interact with other users",
                          ][index],
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ];
  }

  @override
  Widget getTitle(BuildContext context) {
    return Container();
  }
}
