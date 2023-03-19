import 'package:flutter/material.dart';

class App {
  static late double height;
  static late double width;
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

  App.init() {
    WidgetsBinding.instance.addPostFrameCallback((t) {
      WidgetsFlutterBinding.ensureInitialized();
      height = MediaQuery.of(navigatorKey!.currentContext!).size.height;
      width = MediaQuery.of(navigatorKey!.currentContext!).size.width;
    });
  }
}

final height = App.height;
final widght = App.width;
