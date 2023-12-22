
import 'dart:async';

import 'package:flutter/material.dart';

abstract class RequiredProvider extends ChangeNotifier{


  @protected
  final StreamController<bool> loadedController = StreamController.broadcast();

  bool lastLoaded = false;

  late Stream<bool> loaded = loadedController.stream;


  RequiredProvider(){
    loadedController.add(false);
    loaded.listen((event) { lastLoaded = event;});
  }
}