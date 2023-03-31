import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  FloatingButton({this.widget, this.function});
  final void Function()? function;
  final Widget? widget;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: FloatingActionButton(
        backgroundColor: Color(0xff1AA928),
        onPressed: function,
        child: widget ?? Icon(Icons.add, size: 40),
      ),
    );
  }
}
