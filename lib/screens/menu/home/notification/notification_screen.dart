import 'package:flutter/material.dart';

import 'package:gen_crm/widgets/line_horizontal_widget.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../src/src_index.dart';
import 'index.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: COLORS.PRIMARY_COLOR,
          title: Text(
            "Thông báo",
            style: AppStyle.DEFAULT_18_BOLD,
          ),
          leading: _buildBack(),
          toolbarHeight: AppValue.heights * 0.08,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
        ),
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
                            ReadedList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }

  _buildBack() {
    return IconButton(
      onPressed: () {
        AppNavigator.navigateMain();
      },
      icon: Image.asset(
        ICONS.ICON_BACK,
        height: 28,
        width: 28,
        color: COLORS.BLACK,
      ),
    );
  }
}
