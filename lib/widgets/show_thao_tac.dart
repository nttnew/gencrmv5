import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
              padding: EdgeInsets.symmetric(vertical: 15),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: list
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ButtonThaoTac(
                  title: AppLocalizations.of(Get.context!)
                      ?.close ??
                      '',
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
            ),
          ],
        );
      });
}


