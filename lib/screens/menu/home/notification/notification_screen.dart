import 'package:flutter/material.dart';

import 'package:gen_crm/widgets/line_horizontal_widget.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import 'index.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarBaseNormal(  "Thông báo"),
        body: SafeArea(
          child: DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: Scaffold(
                appBar: TabBar(
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
                      text: "Chưa đọc",
                    ),
                    Tab(
                      text: "Đã đọc",
                    ),
                  ],
                ),
                body: Container(
                  child: Column(
                    children: [
                      LineHorizontal(),
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
