import 'package:cinescope/firebase_options.dart';
import 'package:cinescope/main.dart';
import 'package:cinescope/view/pages/main_login_page.dart';
import 'package:cinescope/view/pages/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_driver/driver_extension.dart';

Future<void> main() async {
// This line enables the extension.
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Widget startingWidget = MainLoginPage();
  if (FirebaseAuth.instance.currentUser != null) {
    startingWidget = const MainPage();
  }

  runApp(MyApp(
    startingWidget: startingWidget,
  ));
  
}
