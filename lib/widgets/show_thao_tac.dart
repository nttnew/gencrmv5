import 'package:flutter/material.dart';
import '../../l10n/key_text.dart';
import '../src/app_const.dart';
import 'btn_thao_tac.dart';

class ModuleThaoTac {
  String title;
  String icon;
  Function() onThaoTac;
  bool isSvg;

  ModuleThaoTac({
    required this.title,
    required this.icon,
    required this.onThaoTac,
    this.isSvg = true,
  });
}

Future showThaoTac(
  BuildContext context,
  List<ModuleThaoTac> list,
) {
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView(
              padding: EdgeInsets.symmetric(
                vertical: 16,
              ),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: list
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                      ),
                      child: itemIcon(
                        e.title,
                        e.icon,
                        e.onThaoTac,
                        isSvg: e.isSvg,
                      ),
                    ),
                  )
                  .toList(),
            ),
            ButtonCustom(
                title: getT(KeyT.close),
                onTap: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      });
}
