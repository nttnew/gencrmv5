import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../bloc/login/login_bloc.dart';
import '../../../src/src_index.dart';
import '../../add_service_voucher/add_service_voucher_screen.dart';

class MenuFlash extends StatefulWidget {
  const MenuFlash({Key? key}) : super(key: key);

  @override
  State<MenuFlash> createState() => _MenuFlashState();
}

class _MenuFlashState extends State<MenuFlash> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List<Widget>.generate(LoginBloc.of(context).listMenuFlash.length,
              (i) {
            return GestureDetector(
              onTap: () {
                Get.back();
                String id =
                    LoginBloc.of(context).listMenuFlash[i].id.toString();
                String name = LoginBloc.of(context)
                    .listMenuFlash[i]
                    .name
                    .toString()
                    .toLowerCase();
                if (ModuleText.CUSTOMER == id) {
                  AppNavigator.navigateAddCustomer();
                } else if (ModuleText.DAU_MOI == id) {
                  AppNavigator.navigateFormAdd(name, 2);
                } else if (ModuleText.LICH_HEN == id) {
                  AppNavigator.navigateFormAdd(name, 3);
                } else if (ModuleText.HOP_DONG == id) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddServiceVoucherScreen(
                          title: name.toUpperCase().capitalizeFirst ?? '')));
                } else if (ModuleText.CONG_VIEC == id) {
                  AppNavigator.navigateFormAdd(name, 14);
                } else if (ModuleText.CSKH == id) {
                  AppNavigator.navigateFormAdd(name, 6);
                } else if (ModuleText.THEM_MUA_XE == id) {
                  //todo
                } else if (ModuleText.THEM_BAN_XE == id) {
                  //todo
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppValue.hSpaceLarge,
                  Image.asset(
                    ModuleText.getIconMenu(
                        LoginBloc.of(context).listMenuFlash[i].id.toString()),
                    height: 26,
                    width: 26,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 10),
                  Text(
                    LoginBloc.of(context).listMenuFlash[i].name.toString(),
                    style: AppStyle.DEFAULT_16_BOLD
                        .copyWith(color: Color(0xff006CB1)),
                  )
                ],
              ),
            );
          }).toList(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: AppValue.widths * 0.8,
                  height: AppValue.heights * 0.06,
                  decoration: BoxDecoration(
                    color: HexColor("#D0F1EB"),
                    borderRadius: BorderRadius.circular(17.06),
                  ),
                  child: Center(
                    child: Text("Đóng"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
