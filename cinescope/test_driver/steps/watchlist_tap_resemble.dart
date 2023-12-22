
import 'package:cinescope/utils/string_captitalize.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class WhenWatchlistButtonTapResemble
    extends When1WithWorld<String, FlutterWorld> {
  @override
  Pattern get pattern => RegExp(
      r"the user taps the watchlist button on a entry that resembles {string} on the card content");

  @override
  Future<void> executeStep(String input1) async {
    await FlutterDriverUtils.waitForFlutter(world.driver);
    int id = 0;
    SerializableFinder genericFilmCard = find.byValueKey("genericFilmCard-$id");
    while (await FlutterDriverUtils.isPresent(world.driver, genericFilmCard)) {
      final normal =
          find.descendant(of: genericFilmCard, matching: find.text(input1));
      final caps = find.descendant(
          of: genericFilmCard, matching: find.text(input1.capitalize()));

      if (await FlutterDriverUtils.isAbsent(world.driver, normal) ||
          await FlutterDriverUtils.isAbsent(world.driver, caps)) {
        final button = find.descendant(
            of: genericFilmCard, matching: find.byType("IconButton"));
        await FlutterDriverUtils.tap(world.driver, button);
        await FlutterDriverUtils.waitForFlutter(world.driver);
        return;
      }
      id++;
      genericFilmCard = find.byValueKey("genericFilmCard-$id");
    }
    expect(false, true, reason: "Couldn't find any films with that name");
  }
}
