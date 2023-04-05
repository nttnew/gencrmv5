import 'dart:convert';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/get_infor_acc/get_infor_acc_bloc.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/screens/add_service_voucher/add_service_voucher_screen.dart';
import 'package:gen_crm/widgets/widget_appbar.dart';
import 'package:get/get.dart';
import 'package:gen_crm/models/index.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:hexcolor/hexcolor.dart';

import '../bloc/login/login_bloc.dart';
import '../storages/share_local.dart';
import 'menu/menu_left/menu_drawer/main_drawer.dart';

class ScreenMain extends StatefulWidget {
  @override
  _ScreenMainState createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  List<ButtonMenuModel> listMenu = [];

  // List<Map> menuItems = [
  //   {"icon": "assets/icons/addContent.png", "name": "Thêm mua xe"},
  //   {"icon": "assets/icons/addContent.png", "name": "Thêm bán xe"},
  //   {"icon": "assets/icons/addContent.png", "name": "Thêm đặt lịch"},
  //   {"icon": "assets/icons/addContent.png", "name": "Thêm phiếu dịch vụ"},
  //   {"icon": "assets/icons/add_clue.png", "name": "Thêm khách hàng"},
  //   {"icon": "assets/icons/addWork.png", "name": "Thêm công việc"},
  //   {"icon": "assets/icons/Support.png", "name": "Thêm hỗ trợ"},
  // ];

  String getIconMenu(String id) {
    if (ModuleText.CUSTOMER == id) {
      return ICONS.CUSTUMER_3X;
    } else if (ModuleText.DAU_MOI == id) {
      return ICONS.CLUE_3X;
    } else if (ModuleText.LICH_HEN == id) {
      return ICONS.CHANCE_3X;
    } else if (ModuleText.HOP_DONG == id) {
      return ICONS.CONTRACT_3X;
    } else if (ModuleText.CONG_VIEC == id) {
      return ICONS.WORK_3X;
    } else if (ModuleText.CSKH == id) {
      return ICONS.SUPPORT_3X;
    }
    return ICONS.WORK_3X;
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 300), () {
      GetInforAccBloc.of(context).add(InitGetInforAcc());
      GetListUnReadNotifiBloc.of(context).add(CheckNotification());
    });
    getMenu();
    super.initState();
  }

  getMenu() async {
    String menu = await shareLocal.getString(PreferencesKey.MENU);
    List listM = jsonDecode(menu);
    for (int i = 0; i < listM.length; i++) {
      listMenu.add(
        ButtonMenuModel(
            title: listM[i]['name'],
            image: listM[i]['id'] == 'opportunity'
                ? ICONS.CHANCE_3X
                : listM[i]['id'] == 'job'
                    ? ICONS.WORK_3X
                    : listM[i]['id'] == 'contract'
                        ? ICONS.CONTRACT_3X
                        : listM[i]['id'] == 'support'
                            ? ICONS.SUPPORT_3X
                            : listM[i]['id'] == 'customer'
                                ? ICONS.CUSTUMER_3X
                                : ICONS.CLUE_3X,
            backgroundColor: listM[i]['id'] == 'opportunity'
                ? Color(0xffFDC9D2)
                : listM[i]['id'] == 'job'
                    ? Color(0xffFF993A)
                    : listM[i]['id'] == 'contract'
                        ? Color(0xffFFC000)
                        : listM[i]['id'] == 'support'
                            ? Color(0xff8AC53E)
                            : listM[i]['id'] == 'customer'
                                ? Color(0xff369FFF)
                                : Color(0xffA5A6F6),
            onTap: () {
              if (listM[i]['id'] == 'opportunity') {
                AppNavigator.navigateChance(listM[i]['name']);
              } else if (listM[i]['id'] == 'job') {
                AppNavigator.navigateWork(listM[i]['name']);
              } else if (listM[i]['id'] == 'contract') {
                AppNavigator.navigateContract(listM[i]['name']);
              } else if (listM[i]['id'] == 'support') {
                AppNavigator.navigateSupport(listM[i]['name']);
              } else if (listM[i]['id'] == 'customer') {
                AppNavigator.navigateCustomer(listM[i]['name']);
              } else {
                AppNavigator.navigateClue(listM[i]['name']);
              }
            }),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MainDrawer(onPress: handleOnPressItemMenu),
      floatingActionButton: listMenu.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: Color(0xff1AA928),
              onPressed: () {
                showModalBottomSheet(
                    isDismissible: false,
                    enableDrag: false,
                    context: context,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    builder: (BuildContext context) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...List<Widget>.generate(
                                LoginBloc.of(context).listMenuFlash.length,
                                (i) {
                              return GestureDetector(
                                onTap: () {
                                  Get.back();

                                  String id = LoginBloc.of(context)
                                      .listMenuFlash[i]
                                      .id
                                      .toString();
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
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddServiceVoucherScreen(
                                                    title: name
                                                            .toUpperCase()
                                                            .capitalizeFirst ??
                                                        '')));
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
                                      getIconMenu(LoginBloc.of(context)
                                          .listMenuFlash[i]
                                          .id
                                          .toString()),
                                      height: 26,
                                      width: 26,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      LoginBloc.of(context)
                                          .listMenuFlash[i]
                                          .name
                                          .toString(),
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
                                      borderRadius:
                                          BorderRadius.circular(17.06),
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
                    });
              },
              child: Icon(Icons.add, size: 40),
            )
          : SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text(
            MESSAGES.BACK_TO_EXIT,
            style: AppStyle.DEFAULT_16.copyWith(color: COLORS.WHITE),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<GetInforAccBloc, GetInforAccState>(
                  builder: (context, state) {
                if (state is UpdateGetInforAccState) {
                  return WidgetAppbar(
                    title:
                        state.inforAcc != null ? state.inforAcc.fullname : '',
                    textColor: Colors.black,
                    right: GestureDetector(onTap: () {
                      return AppNavigator.navigateNotification();
                    }, child: BlocBuilder<GetListUnReadNotifiBloc,
                        UnReadListNotifiState>(builder: (context, state) {
                      if (state is NotificationNeedRead) {
                        return SvgPicture.asset(
                            "assets/icons/notification.svg");
                      } else {
                        return SvgPicture.asset(
                            "assets/icons/notification2.svg");
                      }
                    })),
                    left: GestureDetector(
                      onTap: () {
                        if (_drawerKey.currentContext != null &&
                            !_drawerKey.currentState!.isDrawerOpen) {
                          _drawerKey.currentState!.openDrawer();
                        }
                      },
                      child: WidgetNetworkImage(
                        image: state.inforAcc != null
                            ? state.inforAcc.avatar!
                            : '',
                        width: 50,
                        height: 50,
                        borderRadius: 25,
                      ),
                    ),
                  );
                } else {
                  return WidgetAppbar(
                    title: '',
                    textColor: Colors.black,
                    right: GestureDetector(onTap: () {
                      return AppNavigator.navigateNotification();
                    }, child: BlocBuilder<GetListUnReadNotifiBloc,
                        UnReadListNotifiState>(builder: (context, state) {
                      if (state is NotificationNeedRead) {
                        return SvgPicture.asset(
                            "assets/icons/notification.svg");
                      } else {
                        return SvgPicture.asset(
                            "assets/icons/notification2.svg");
                      }
                    })),
                    left: GestureDetector(
                      onTap: () {
                        if (_drawerKey.currentContext != null &&
                            !_drawerKey.currentState!.isDrawerOpen) {
                          _drawerKey.currentState!.openDrawer();
                        }
                      },
                      child: WidgetNetworkImage(
                        image: '',
                        width: 50,
                        height: 50,
                        borderRadius: 25,
                      ),
                    ),
                  );
                }
              }),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listMenu.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 25,
                        mainAxisSpacing: 25),
                    itemBuilder: (context, index) {
                      // List<ButtonMenuModel> list = [];
                      return _buildItemMenu(
                          data: listMenu[index], index: index);
                    }),
              ),
              GestureDetector(
                onTap: () async {
                  String? money =
                      await shareLocal.getString(PreferencesKey.MONEY);
                  AppNavigator.navigateReport(money ?? "đ");
                },
                child: Container(
                  width: AppValue.widths,
                  height: AppValue.heights * 0.18,
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xff5D5FEF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: WidgetContainerImage(
                          image: ICONS.WORK_3X,
                          fit: BoxFit.contain,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      AppValue.vSpaceTiny,
                      Text("Báo cáo",
                          style: AppStyle.DEFAULT_20_BOLD.copyWith(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildItemMenu({required ButtonMenuModel data, required int index}) {
    return GestureDetector(
      onTap: data.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: data.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: 80,
                height: 80,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: WidgetContainerImage(
                  image: data.image,
                  fit: BoxFit.contain,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            Expanded(
              child: Container(
                // height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  data.title,
                  style: AppStyle.DEFAULT_12.copyWith(
                      fontFamily: 'Roboto', fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  handleOnPressItemMenu(value) async {
    switch (value['id']) {
      case '1':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateMain();
        break;
      case 'opportunity':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateChance(value['title']);
        break;
      case 'job':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateWork(value['title']);
        break;
      case 'contract':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateContract(value['title']);
        break;
      case 'support':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateSupport(value['title']);
        break;
      case 'customer':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateCustomer(value['title']);
        break;
      case 'contact':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateClue(value['title']);
        break;
      case 'report':
        _drawerKey.currentState!.openEndDrawer();
        String? money = await shareLocal.getString(PreferencesKey.MONEY);
        AppNavigator.navigateReport(money ?? "đ");
        break;
      case '2':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateInformationAccount();
        break;
      case '3':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateAboutUs();
        break;
      case '4':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigatePolicy();
        break;
      case '5':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateChangePassword();
        break;
      default:
        break;
    }
  }
}
