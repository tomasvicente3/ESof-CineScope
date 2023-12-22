import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class ThenNotFound extends ThenWithWorld<FlutterWorld> {
  @override
  Pattern get pattern =>
      RegExp(r"it should be displayed with a not found message");

  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.waitForFlutter(world.driver);
    final errorNotFound = find.byValueKey("errorNotFound");
    expect(
        await FlutterDriverUtils.isPresent(world.driver, errorNotFound), true,
        reason: "Couldn't find any error with a not found message");
  }
}
