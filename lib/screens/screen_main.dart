import 'dart:convert';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/bloc/get_infor_acc/get_infor_acc_bloc.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/src/models/model_generator/login_response.dart';
import 'package:gen_crm/widgets/widget_appbar.dart';
import 'package:get/get.dart';
import 'package:gen_crm/models/index.dart';
import 'package:gen_crm/screens/screens.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:hexcolor/hexcolor.dart';

import '../storages/share_local.dart';
import 'menu/menu_left/menu_drawer/main_drawer.dart';

class ScreenMain extends StatefulWidget {
  @override
  _ScreenMainState createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  List<ButtonMenuModel> listMenu = [];

  List<Map> menuItems = [
    {"icon": "assets/icons/addContent.png", "name": "Thêm mua xe"},
    {"icon": "assets/icons/addContent.png", "name": "Thêm bán xe"},
    {"icon": "assets/icons/addContent.png", "name": "Thêm đặt lịch"},
    {"icon": "assets/icons/addContent.png", "name": "Thêm phiếu dịch vụ"},
    {"icon": "assets/icons/add_clue.png", "name": "Thêm khách hàng"},
    {"icon": "assets/icons/addWork.png", "name": "Thêm công việc"},
    {"icon": "assets/icons/Support.png", "name": "Thêm hỗ trợ"},
  ];

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
                ? ICONS.CHANCE
                : listM[i]['id'] == 'job'
                    ? ICONS.WORK
                    : listM[i]['id'] == 'contract'
                        ? ICONS.CONTRACT
                        : listM[i]['id'] == 'support'
                            ? ICONS.SUPPORT
                            : listM[i]['id'] == 'customer'
                                ? ICONS.CUSTUMER
                                : ICONS.CLUE,
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
    // listMenu=[
    //   ButtonMenuModel(title: listM[0]['name'], image: ICONS.CUSTUMER,backgroundColor: Color(0xff369FFF),onTap: (){AppNavigator.navigateCustomer();}),
    //   ButtonMenuModel(title: listM[1]['name'], image: ICONS.CLUE,backgroundColor: Color(0xffA5A6F6),onTap: (){AppNavigator.navigateClue();}),
    //   ButtonMenuModel(title: listM[2]['name'], image: ICONS.CHANCE,backgroundColor: Color(0xffFDC9D2),onTap: (){AppNavigator.navigateChance();}),
    //   ButtonMenuModel(title: listM[3]['name'], image: ICONS.CONTRACT,backgroundColor: Color(0xffFFC000),onTap: (){AppNavigator.navigateContract();}),
    //   ButtonMenuModel(title: listM[4]['name'], image: ICONS.WORK,backgroundColor: Color(0xffFF993A),onTap: (){AppNavigator.navigateWork();}),
    //   ButtonMenuModel(title: listM[5]['name'], image: ICONS.SUPPORT,backgroundColor: Color(0xff8AC53E),onTap: (){AppNavigator.navigateSupport();}),
    // ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MainDrawer(onPress: handleOnPressItemMenu),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff1AA928),
        onPressed: () {
          showModalBottomSheet(
              isDismissible: false,
              enableDrag: false,
              context: context,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List<Widget>.generate(menuItems.length, (i) {
                        return GestureDetector(
                          onTap: () {
                            Get.back();
                            switch (i) {
                              case 0:
                                {
                                  //AppNavigator.navigateAddBuyCar();
                                  break;
                                }
                              case 1:
                                {
                                  //AppNavigator.navigateAddSellCar();
                                  break;
                                }
                              case 2:
                                {
                                  //AppNavigator.navigateAddBooking();
                                  break;
                                }
                              case 3:
                                {
                                  //AppNavigator.navigateAddServiceCard();
                                  break;
                                }
                              case 4:
                                {
                                  AppNavigator.navigateAddCustomer();
                                  break;
                                }
                              case 5:
                                {
                                  AppNavigator.navigateFormAdd("Thêm công việc", 14);
                                  break;
                                }
                              case 6:
                                {
                                  AppNavigator.navigateFormAdd("Thêm công việc", 15);
                                  break;
                                }

                              default:
                                break;
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AppValue.hSpaceLarge,
                              Image.asset(menuItems[i]["icon"]),
                              SizedBox(width: 10),
                              Text(
                                menuItems[i]["name"],
                                style: AppStyle.DEFAULT_16_BOLD.copyWith(color: Color(0xff006CB1)),
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
              });
        },
        child: Icon(Icons.add, size: 40),
      ),
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
              BlocBuilder<GetInforAccBloc, GetInforAccState>(builder: (context, state) {
                if (state is UpdateGetInforAccState) {
                  return WidgetAppbar(
                    title: state.inforAcc != null ? state.inforAcc.fullname : '',
                    textColor: Colors.black,
                    right: GestureDetector(onTap: () {
                      return AppNavigator.navigateNotification();
                    }, child: BlocBuilder<GetListUnReadNotifiBloc, UnReadListNotifiState>(builder: (context, state) {
                      if (state is NotificationNeedRead) {
                        return SvgPicture.asset("assets/icons/notification.svg");
                      } else {
                        return SvgPicture.asset("assets/icons/notification2.svg");
                      }
                    })),
                    left: GestureDetector(
                      onTap: () {
                        if (_drawerKey.currentContext != null && !_drawerKey.currentState!.isDrawerOpen) {
                          _drawerKey.currentState!.openDrawer();
                        }
                      },
                      child: WidgetNetworkImage(
                        image: state.inforAcc != null ? state.inforAcc.avatar! : '',
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
                    }, child: BlocBuilder<GetListUnReadNotifiBloc, UnReadListNotifiState>(builder: (context, state) {
                      if (state is NotificationNeedRead) {
                        return SvgPicture.asset("assets/icons/notification.svg");
                      } else {
                        return SvgPicture.asset("assets/icons/notification2.svg");
                      }
                    })),
                    left: GestureDetector(
                      onTap: () {
                        if (_drawerKey.currentContext != null && !_drawerKey.currentState!.isDrawerOpen) {
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 35, mainAxisSpacing: 25),
                    itemBuilder: (context, index) {
                      // List<ButtonMenuModel> list = [];
                      return _buildItemMenu(data: listMenu[index], index: index);
                    }),
              ),
              GestureDetector(
                onTap: () async {
                  String? money = await shareLocal.getString(PreferencesKey.MONEY);
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
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white),
                        child: WidgetContainerImage(
                          image: ICONS.WORK,
                        ),
                      ),
                      AppValue.vSpaceTiny,
                      Text("Báo cáo", style: AppStyle.DEFAULT_12_BOLD.copyWith(fontFamily: 'Roboto'))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      // floatingActionButton: Padding(
      //   padding: EdgeInsets.only(bottom: 20),
      //   child: FloatingActionButton(
      //     backgroundColor: Color(0xff1AA928),
      //     onPressed: () {},
      //     child: Icon(Icons.add,size: 40),
      //   ),
      // ),
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
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white),
              child: WidgetContainerImage(
                image: data.image,
              ),
            ),
            AppValue.vSpaceTiny,
            Text(data.title, style: AppStyle.DEFAULT_12_BOLD.copyWith(fontFamily: 'Roboto'))
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
