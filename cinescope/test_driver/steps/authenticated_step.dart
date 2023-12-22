import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class GivenUserAuthenticated extends GivenWithWorld<FlutterWorld> {

  GivenUserAuthenticated() : super(StepDefinitionConfiguration()..timeout = const Duration(seconds: 20));

  @override
  RegExp get pattern => RegExp(r"the user is authenticated");

  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.waitForFlutter(world.driver);
    final mainPage = find.byType("MainPage");
    if(await FlutterDriverUtils.isPresent(world.driver, mainPage)) return;

    final loginButton = find.byValueKey("signinButton");
    await FlutterDriverUtils.tap(world.driver, loginButton);
    await FlutterDriverUtils.waitForFlutter(world.driver);
    final emailText = find.byValueKey("emailField");
    await FlutterDriverUtils.tap(world.driver, emailText);
    await FlutterDriverUtils.enterText(world.driver, emailText, "teste@gmail.com");

    final passwordText = find.byValueKey("passwordField");
    await FlutterDriverUtils.tap(world.driver, passwordText);
    await FlutterDriverUtils.enterText(world.driver, passwordText, "teste123");

    final signupButton = find.byValueKey("loginButton");
    await FlutterDriverUtils.tap(world.driver, signupButton);
    await FlutterDriverUtils.waitForFlutter(world.driver);

    sleep(const Duration(seconds: 5));


    expect(await FlutterDriverUtils.isPresent(world.driver, mainPage), true, 
    reason: "Not in main page after login");





  }
}
