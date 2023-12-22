

import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class WhenSearchFilm extends When1WithWorld<String, FlutterWorld>{

  @override
  Pattern get pattern => RegExp(r"the user enters {string} in the search bar");

  @override
  Future<void> executeStep(String input1) async {
    final searchField = find.byValueKey("searchField");
    expect(await FlutterDriverUtils.isPresent(world.driver, searchField), true);
    await FlutterDriverUtils.tap(world.driver, searchField);
    await FlutterDriverUtils.enterText(world.driver, searchField, input1);
    await FlutterDriverUtils.waitForFlutter(world.driver);

  }

}