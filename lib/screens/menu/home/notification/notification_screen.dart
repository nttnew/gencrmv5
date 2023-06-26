import 'package:flutter/material.dart';
import 'package:gen_crm/screens/menu/home/notification/widget/unread_list.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../widgets/appbar_base.dart';
import 'widget/index.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarBaseNormal(
          AppLocalizations.of(Get.context!)?.notification ?? '',
        ),
        body: SafeArea(
          child: DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: Scaffold(
                appBar: TabBar(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  isScrollable: true,
                  labelColor: HexColor("#006CB1"),
                  unselectedLabelColor: HexColor("#697077"),
                  labelStyle: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                  indicatorColor: HexColor("#006CB1"),
                  tabs: <Widget>[
                    Tab(
                      text: AppLocalizations.of(Get.context!)?.unread ?? '',
                    ),
                    Tab(
                      text: AppLocalizations.of(Get.context!)?.readed ?? '',
                    ),
                  ],
                ),
                body: Container(
                  child: Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          children: [
                            UnReadList(),
                            ReadList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }
}
