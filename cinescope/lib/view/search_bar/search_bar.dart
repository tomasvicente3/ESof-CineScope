import 'package:cinescope/view/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cinescope/controller/search_results_fetcher.dart';

class AppSearchBar extends StatefulWidget {
  final SearchPageState pageState;

  const AppSearchBar({super.key, required this.pageState});

  @override
  State<StatefulWidget> createState() => AppSearchBarState();
}

class AppSearchBarState extends State<AppSearchBar> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _submitEvent(String value) {
    print(value);
  }

  void _submitEventButton() {
    _submitEvent(_textEditingController.text);
  }

  Future<void> _search(String value) async {
    if (value.length < 3) return;
    print("****** SEARCHING FOR: $value");
    var results = await SearchResultsFetcher.getSearchResults(value);
    print("****** RESULTS: $results");
    widget.pageState.setState(() {
      widget.pageState.films = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: const Color(0xFFF0EDEE),
          border: Border.all(color: const Color(0xFFF0EDEE)),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const FaIcon(FontAwesomeIcons.chevronLeft),
              color: Colors.black,
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 2.5)),
            Flexible(
              child: TextField(
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.black, fontSize: 20)),
                controller: _textEditingController,
                onSubmitted: _submitEvent,
                style: const TextStyle(color: Colors.black, fontSize: 20),
                onChanged: _search,
                key: const Key("searchField"),
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 2.5)),
            IconButton(
              onPressed: _submitEventButton,
              icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
              color: Colors.black,
            )
          ]),
    );
  }
}
