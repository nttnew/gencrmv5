import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gen_crm/src/src_index.dart';

class MODEL{
  static Color _warningColor = Colors.yellow;
  static Future<void> showMyDialog(BuildContext context, VoidCallback onPressed) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Center(
                child: Icon(
                  Icons.warning,
                  color: _warningColor,
                ),
              ),
              AppValue.hSpaceTiny,
              Text(MESSAGES.LOGIN_EXPIRED),
            ],
          ),
          content: Text(MESSAGES.LOGIN_AGAIN),
          actions: <Widget>[
            InkWell(
              child: Text(MESSAGES.OK),
              onTap: onPressed,
            ),
          ],
        );
      },
    );
  }
}