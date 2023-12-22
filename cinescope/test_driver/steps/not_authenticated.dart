import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class GivenUserNotAuthenticated extends GivenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.waitForFlutter(world.driver);
    final mainPage = find.byType("MainPage");

    if (await FlutterDriverUtils.isPresent(world.driver, mainPage)) {
      await FlutterDriverUtils.waitForFlutter(world.driver);
      final profileButton = find.byValueKey("profile");
      expect(
          await FlutterDriverUtils.isPresent(world.driver, profileButton), true,
          reason: " profile button not found");
      await FlutterDriverUtils.tap(world.driver, profileButton);
      await FlutterDriverUtils.waitForFlutter(world.driver);

      await FlutterDriverUtils.tap(world.driver, find.byValueKey("logout"));
      await FlutterDriverUtils.waitForFlutter(world.driver);

      await FlutterDriverUtils.tap(world.driver, find.byValueKey("logoutConfirm"));
      await FlutterDriverUtils.waitForFlutter(world.driver);
    } else {
      expect(await FlutterDriverUtils.isPresent(world.driver, find.byType("MainLoginPage")),
          true,
          reason: " not in MainLoginPage");
    }
  }

  @override
  Pattern get pattern => RegExp(r"the user is not authenticated");
}
