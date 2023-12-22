


import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class GivenChangePageStep extends Given1WithWorld<String, FlutterWorld>{
  @override
  Future<void> executeStep(String input1) async{
    final pageButton = find.byValueKey(input1);
    expect(await FlutterDriverUtils.isPresent(world.driver, pageButton), true);
    await FlutterDriverUtils.tap(world.driver, pageButton);
    await FlutterDriverUtils.waitForFlutter(world.driver);
  }

  @override
  Pattern get pattern => RegExp(r"the user is on the {string} page");

}

class WhenChangePageStep extends When1WithWorld<String, FlutterWorld>{
  @override
  Future<void> executeStep(String input1) async{
    final pageButton = find.byValueKey(input1);
    expect(await FlutterDriverUtils.isPresent(world.driver, pageButton), true);
    await FlutterDriverUtils.tap(world.driver, pageButton);
    await FlutterDriverUtils.waitForFlutter(world.driver);
  }

  @override
  Pattern get pattern => RegExp(r"I go to the {string} page");

}