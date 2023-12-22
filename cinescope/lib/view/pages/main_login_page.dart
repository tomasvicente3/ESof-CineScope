import 'package:cinescope/controller/login.dart';
import 'package:cinescope/view/button/login_button.dart';
import 'package:cinescope/view/pages/login_page.dart';
import 'package:cinescope/view/pages/main_page.dart';
import 'package:cinescope/view/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';

class MainLoginPage extends StatelessWidget {
  MainLoginPage({super.key});

  final TextEditingController _textEditingController = TextEditingController();

  void Function() googleButtonHandler(BuildContext context) {
    return () {
      signInWithGoogle().then((value) => {
            if (value.user != null)
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MainPage()))
              }
            else
              {Logger().i("User failed google auth")}
          });
    };
  }

  void Function() githubButtonHandler(BuildContext context) {
    return () {
      signInWithGitHub().then((value) => {
            if (value.user != null)
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MainPage()))
              }
            else
              {Logger().i("User failed google auth")}
          });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0XFF07393C),
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/logo-no-background.png",
                  color: Colors.white,
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                const Text(
                  "Welcome!",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 35),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                Row(children: [
                  Expanded(
                      child: LoginButton(
                          pressedFunction: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginPage()));
                          },
                          childWidget: const Text("Sign In"),
                          relevant: false,
                          key: const Key("signinButton"),)),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                  Expanded(
                      child: LoginButton(
                          pressedFunction: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>  RegisterPage()));
                          },
                          childWidget: const Text("Sign Up"))),
                ]),
                const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                const Text(
                  "or",
                  textAlign: TextAlign.center,
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                LoginButton(
                    pressedFunction: googleButtonHandler(context),
                    childWidget: Row(children: const [
                      Padding(
                          padding:
                              EdgeInsetsDirectional.symmetric(horizontal: 5)),
                      FaIcon(FontAwesomeIcons.google),
                      Padding(
                          padding:
                              EdgeInsetsDirectional.symmetric(horizontal: 10)),
                      Text("Sign-in with Google")
                    ])),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                LoginButton(
                    pressedFunction: githubButtonHandler(context),
                    childWidget: Row(children: const[
                      Padding(
                          padding:
                              EdgeInsetsDirectional.symmetric(horizontal: 5)),
                      FaIcon(FontAwesomeIcons.github),
                      Padding(
                          padding:
                              EdgeInsetsDirectional.symmetric(horizontal: 10)),
                      Text("Sign-in with GitHub")
                    ])),
              ],
            ))));
  }
}
