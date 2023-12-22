
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import 'global_state.dart';

class ThenSavesProfileState extends ThenWithWorld<FlutterWorld>{
  @override
  Future<void> executeStep() async {

    GlobalScenarioState().previousProfileName = await FlutterDriverUtils.getText(world.driver!, find.byValueKey("name"));
    GlobalScenarioState().previousProfileBio = await FlutterDriverUtils.getText(world.driver!, find.byValueKey("bio"));
  }

  @override
  Pattern get pattern => RegExp(r"it saves profile state");

}

class ThenRestoresProfileState extends ThenWithWorld<FlutterWorld>{
  ThenRestoresProfileState() : super(StepDefinitionConfiguration()..timeout=const Duration(seconds: 20));

  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(world.driver, find.byValueKey("editProfile"));
    await FlutterDriverUtils.waitForFlutter(world.driver);

    await FlutterDriverUtils.enterText(world.driver, find.byValueKey("name"), GlobalScenarioState().previousProfileName);
    await FlutterDriverUtils.enterText(world.driver, find.byValueKey("bio"), GlobalScenarioState().previousProfileBio);
    await world.driver!.scroll(find.byValueKey("bio"), 0, -200, const Duration(milliseconds: 500));
    await FlutterDriverUtils.tap(world.driver, find.byValueKey("saveChanges"));

  }

  @override
  Pattern get pattern => RegExp("Then it restores profile state");

}