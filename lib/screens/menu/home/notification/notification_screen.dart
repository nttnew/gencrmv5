import 'package:flutter/material.dart';
import 'package:gen_crm/screens/menu/home/notification/widget/unread_list.dart';
import '../../../../src/color.dart';
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
        body: DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Scaffold(
              appBar: TabBar(
                padding: EdgeInsets.symmetric(horizontal: 25),
                isScrollable: true,
                labelColor: COLORS.ff006CB1,
                unselectedLabelColor: COLORS.ff697077,
                labelStyle: TextStyle(
                    fontFamily: "Quicksand",
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
                indicatorColor: COLORS.ff006CB1,
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
        ));
  }
}
