

import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class WhenGoesToPage extends When1WithWorld<String, FlutterWorld>{
  @override
  Future<void> executeStep(String input1) async {
    await FlutterDriverUtils.waitForFlutter(world.driver);
      final searchButton = find.byValueKey("search");
      expect(
          await FlutterDriverUtils.isPresent(world.driver, searchButton), true,
          reason: " profile button not found");
      await FlutterDriverUtils.tap(world.driver, searchButton);
    final searchField = find.byValueKey("searchField");
    expect(await FlutterDriverUtils.isPresent(world.driver, searchField), true);
    await FlutterDriverUtils.enterText(world.driver, searchField, input1);
    sleep(const Duration(seconds: 5));
    final card = find.byValueKey("genericFilmCard-0");

    await FlutterDriverUtils.tap(world.driver, card);


      
  }

  @override
  Pattern get pattern => RegExp(r"the user cicks on the first card when searching for {string}");

}