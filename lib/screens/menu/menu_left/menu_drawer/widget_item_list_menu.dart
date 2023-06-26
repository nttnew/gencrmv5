// ignore: import_of_legacy_library_into_null_saf
import 'package:gen_crm/src/src_index.dart';
import 'package:flutter/material.dart';

class WidgetItemListMenu extends StatelessWidget {
  final String? icon, title;
  final bool? check;
  WidgetItemListMenu({this.icon, this.check, this.title});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            icon != ''
                ? Image.asset(
                    icon!,
                    width: 20,
                    height: 20,
                  )
                : Container(),
            AppValue.hSpaceTiny,
            Text(
              title!,
              style: AppStyle.DEFAULT_16.copyWith(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          color: Colors.grey[300],
          width: MediaQuery.of(context).size.width,
          height: 1,
        )
      ],
    );
  }
}
