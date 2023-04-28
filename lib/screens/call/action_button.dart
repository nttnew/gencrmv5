import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ActionButton extends StatelessWidget {
  final String title;
  final FontWeight fontWeight;
  final TextStyle titleStyle;
  final TextStyle subTitleStyle;
  final String subTitle;
  IconData? icon;
  final bool checked;
  final bool number;
  final Color? fillColor;
  final Color? iconColor;
  final Function() onPressed;
  Function()? onLongPress;

  ActionButton(
      {Key? key,
      this.title = '',
      this.subTitle = '',
      this.fontWeight = FontWeight.w400,
      this.titleStyle = const TextStyle(),
      this.subTitleStyle = const TextStyle(),
      this.icon,
      required this.onPressed,
      this.onLongPress,
      this.checked = false,
      this.number = false,
      this.fillColor,
      this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
            onLongPress: onLongPress,
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: fillColor ?? (checked ? Colors.blue : Colors.white),
                shape: BoxShape.circle,
              ),
              child: number
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                          Text(
                            title,
                            style: titleStyle,
                          ),
                          Text(
                            subTitle.toUpperCase(),
                            style: subTitleStyle,
                          )
                        ])
                  : Icon(
                      icon,
                      size: 34.0,
                      color: iconColor ??
                          (fillColor != null
                              ? Colors.white
                              : (checked ? Colors.white : Colors.green)),
                    ),
            )),
        number
            ? Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0))
            : Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                child: (number || title != '')
                    ? null
                    : Text(
                        title,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: fillColor ?? Colors.grey[500],
                        ),
                      ),
              )
      ],
    );
  }
}