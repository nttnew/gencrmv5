import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class WidgetTouchHideKeyBoard extends StatelessWidget {
  final Widget child;

  WidgetTouchHideKeyBoard({required this.child});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: child,
    );
  }
}
