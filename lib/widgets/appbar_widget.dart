import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../src/src_index.dart';

class AppBarWidget extends StatelessWidget {
  final String title;

  const AppBarWidget({Key? key,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: AppValue.heights * 0.1,
      backgroundColor: HexColor("#D0F1EB"),
      title:
      Text(title, style:  TextStyle(color: Colors.black,fontFamily: "Montserrat",fontWeight: FontWeight.w700,fontSize: 16)),
      leading: Padding(
          padding: EdgeInsets.only(left: 30),
          child: InkWell(onTap:()=>AppNavigator.navigateBack(),child: SvgPicture.asset("assets/icons/menu.svg"))),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),
      actions: [
        Padding(
            padding: EdgeInsets.only(right: 30),
            child: SvgPicture.asset("assets/icons/notification.svg"))
      ],

    );
  }
}
