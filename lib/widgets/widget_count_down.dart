// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';

class Countdown extends AnimatedWidget {

  Animation<int> animation;
  Countdown({Key? key, required this.animation}) : super(listenable: animation);

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    print('animation.value  ${animation.value} ');
    print('inMinutes ${clockTimer.inMinutes.toString()}');
    print('inSeconds ${clockTimer.inSeconds.toString()}');
    print('inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');

    return Center(
      child: Text(
        "$timerText",
        style: TextStyle(
            fontSize: 20,
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }



}
