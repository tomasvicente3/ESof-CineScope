import 'package:cinescope/controller/register_callback.dart';
import 'package:cinescope/utils/validators.dart';
import 'package:cinescope/view/pages/main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../button/login_button.dart';

class RegisterPage extends StatefulWidget {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  RegisterPage({super.key, FirebaseAuth? firebaseAuth, FirebaseFirestore? firebaseFirestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController _textEditingControllerEmail =
      TextEditingController();
  final TextEditingController _textEditingControllerPass =
      TextEditingController();
  final TextEditingController _textEditingControllerPassVerification =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void Function() registerButtonHandler(BuildContext context) {
    return () {
      if (_formKey.currentState!.validate()) {
            widget._firebaseAuth
            .createUserWithEmailAndPassword(
                email: _textEditingControllerEmail.text,
                password: _textEditingControllerPass.text)
            .then((value) {
          registerCallback(widget._firebaseAuth, widget._firebaseFirestore);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const MainPage()));
        }).onError((error, stackTrace) {
          final err = (error as FirebaseAuthException);
          if (err.code == "email-already-in-use") {
            showDialog(
                context: context,
                builder: ((context) => AlertDialog(
                      title: const Text("Register failed"),
                      content: const Text("This email is already in use"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Ok"))
                      ],
                    )));
          } else {
            showDialog(
                context: context,
                builder: ((context) => AlertDialog(
                      title: const Text("Register failed"),
                      content: const Text(
                          "Something went wrong while registring"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Ok"))
                      ],
                    )));
          }
        });
      }
    };
  }

  String? samePassword(String? data) {
    if (data != null && data == _textEditingControllerPass.text) {
      return null;
    }
    return "The passwords must match";
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
                    "Register:",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 35),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        controller: _textEditingControllerEmail,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                        key: const Key("emailField"),
                        validator: emailValidator,
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10)),
                      TextFormField(
                        controller: _textEditingControllerPass,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: 'Password',

                        ),
                        key: const Key("passwordField"),
                        validator: strongPasswordValidator,
                        obscureText: true,
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                      TextFormField(
                        controller: _textEditingControllerPassVerification,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        validator: samePassword,
                        obscureText: true,
                        key: const Key("confirmPasswordField"),
                      ),
                    ]),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  LoginButton(
                      key: const Key("registerButton"),
                      pressedFunction: registerButtonHandler(context),
                      childWidget: const Text("Sign up")),
                ]))));
  }
}
