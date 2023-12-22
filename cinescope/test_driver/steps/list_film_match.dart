

import 'package:cinescope/utils/string_captitalize.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class ThenListFilmMatch extends Then1WithWorld<String, FlutterWorld>{
  @override
  Pattern get pattern => RegExp(r"it should be displayed a list of film/series cards that roughly match {string}");

  @override
  Future<void> executeStep(String input1) async {
    FlutterDriverUtils.waitForFlutter(world.driver);
    final inputString = find.text(input1);
    final inputStringCaps = find.text(input1.capitalize());
    expect((await FlutterDriverUtils.isPresent(world.driver, inputString)) || (await FlutterDriverUtils.isPresent(world.driver, inputStringCaps)), 
      true,
      reason: "Couldn't find any movie that contains the input string");
  }


}


class ThenListFilmDoesntMatch extends Then1WithWorld<String, FlutterWorld>{
  @override
  Pattern get pattern => RegExp(r"it should not be displayed a card that roughly matches {string}");

  @override
  Future<void> executeStep(String input1) async {
    FlutterDriverUtils.waitForFlutter(world.driver);
    final inputString = find.text(input1);
    final inputStringCaps = find.text(input1.capitalize());
    expect((await FlutterDriverUtils.isPresent(world.driver, inputString)) || (await FlutterDriverUtils.isPresent(world.driver, inputStringCaps)), 
      false,
      reason: "Found a card that has $input1 in it.");
  }


}
