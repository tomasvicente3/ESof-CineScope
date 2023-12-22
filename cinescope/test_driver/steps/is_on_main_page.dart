

import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class ThenIsMainPage extends ThenWithWorld<FlutterWorld>{
  @override
  Future<void> executeStep() async {
    final mainPage = find.byType("MainPage");
    expect(await FlutterDriverUtils.isPresent(world.driver, mainPage), true, 
    reason: "Not in main page after");
  }

  @override
  Pattern get pattern => RegExp(r"I expect to be in the main page");

}