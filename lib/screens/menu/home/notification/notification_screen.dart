import 'package:flutter/material.dart';
import 'package:gen_crm/screens/menu/home/notification/widget/unread_list.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import 'widget/index.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarBaseNormal(
         getT(KeyT.notification),
        ),
        body: DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Scaffold(
              appBar: TabBar(
                padding: EdgeInsets.symmetric(horizontal: 16),
                isScrollable: true,
                labelColor: COLORS.ff006CB1,
                unselectedLabelColor: COLORS.ff697077,
                labelStyle: AppStyle.DEFAULT_LABEL_TARBAR,
                indicatorColor: COLORS.ff006CB1,
                tabs: <Widget>[
                  Tab(
                    text: getT(KeyT.unread),
                  ),
                  Tab(
                    text: getT(KeyT.readed),
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
              ),),
        ),);
  }
}
