import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/widgets/widget_input.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:get/get.dart';
import '../../../../bloc/clue/clue_bloc.dart';
import '../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../src/models/model_generator/clue.dart';
import '../../../../src/src_index.dart';
import '../../../../storages/share_local.dart';
import '../../../../widgets/widget_appbar.dart';
import '../../../../widgets/widget_text.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';

class ClueScreen extends StatefulWidget {
  const ClueScreen({Key? key}) : super(key: key);

  @override
  State<ClueScreen> createState() => _ClueScreenState();
}

class _ClueScreenState extends State<ClueScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int page = 1;
  int total = 0;
  int lenght = 0;
  List<ClueData> listClue = [];
  String idFilter = "";

  String search = '';
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    GetListClueBloc.of(context).add(InitGetListClueEvent('', 1, ''));
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          lenght < total) {
        GetListClueBloc.of(context)
            .add(InitGetListClueEvent('', page + 1, search));
        page = page + 1;
      } else {}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MainDrawer(onPress: handleOnPressItemMenu),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      body: Column(
        children: [
          WidgetAppbar(
            title: Get.arguments,
            textColor: Colors.black,
            left: Padding(
              padding: EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: () {
                  if (_drawerKey.currentContext != null &&
                      !_drawerKey.currentState!.isDrawerOpen) {
                    _drawerKey.currentState!.openDrawer();
                  }
                },
                child: SvgPicture.asset("assets/icons/menu.svg"),
              ),
            ),
            right: GestureDetector(
              onTap: () {
                AppNavigator.navigateNotification();
              },
              child:
                  BlocBuilder<GetListUnReadNotifiBloc, UnReadListNotifiState>(
                      builder: (context, state) {
                if (state is NotificationNeedRead) {
                  return SvgPicture.asset("assets/icons/notification.svg");
                } else {
                  return SvgPicture.asset("assets/icons/notification2.svg");
                }
              }),
            ),
          ),
          AppValue.vSpaceTiny,
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: _buildSearch()),
          BlocBuilder<GetListClueBloc, ClueState>(builder: (context, state) {
            if (state is UpdateGetListClueState) {
              listClue = state.listClue;
              lenght = state.listClue.length;
              total = int.parse(state.total);
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      Future.delayed(Duration(microseconds: 300), () {
                    GetListClueBloc.of(context)
                        .add(InitGetListClueEvent('', 1, ''));
                  }),
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 16),
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: lenght,
                    itemBuilder: (context, index) {
                      return _buildCustomer(listClue[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(),
                  ),
                ),
              );
            } else
              return Expanded(
                  child: Center(
                child: WidgetText(
                  title: 'Không có dữ liệu',
                  style: AppStyle.DEFAULT_18_BOLD,
                ),
              ));
          }),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          backgroundColor: Color(0xff1AA928),
          onPressed: () {
            // AppNavigator.navigateAddClue();
            AppNavigator.navigateFormAdd('Thêm ${Get.arguments}', 2);
          },
          child: Icon(Icons.add, size: 40),
        ),
      ),
    );
  }

  _buildSearch() {
    return Container(
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(
              color: COLORS.COLORS_BA, //                   <--- border color
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10),
            color: COLORS.WHITE),
        child:
            BlocBuilder<GetListClueBloc, ClueState>(builder: (context, state) {
          if (state is UpdateGetListClueState) {
            return Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Center(
                      child: Container(
                    height: 25,
                    width: 25,
                    child: SvgPicture.asset(
                      'assets/icons/Search.svg',
                      color: COLORS.GREY.withOpacity(0.5),
                    ),
                  )),
                ),
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      onEditingComplete: () {
                        GetListClueBloc.of(context)
                            .add(InitGetListClueEvent('', 1, search));
                      },
                      onChanged: (text) {
                        search = text;
                      },
                      style: AppStyle.DEFAULT_14,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: MESSAGES.SEARCH_CLUE,
                        hintStyle: AppStyle.DEFAULT_14
                            .copyWith(color: Color(0xff707070)),
                        // errorText: errorText,
                        // errorStyle: AppStyle.DEFAULT_12.copyWith(color: COLORS.RED),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  margin: EdgeInsets.only(right: 15),
                  color: COLORS.COLORS_BA,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Container(
                    height: 20,
                    width: 20,
                    child: GestureDetector(
                        onTap: () {
                          showBotomSheet(state.listFilter);
                        },
                        child: SvgPicture.asset('assets/icons/Filter.svg')),
                  ),
                ),
              ],
            );
          }
          return Center(
            child: WidgetText(
              title: 'Không có dữ liệu',
              style: AppStyle.DEFAULT_18_BOLD,
            ),
          );
        }));
  }

  _buildCustomer(ClueData cluedata) {
    return GestureDetector(
      onTap: () {
        AppNavigator.navigateInfoClue(cluedata.id ?? '', cluedata.name ?? '');
      },
      child: Container(
        margin: EdgeInsets.only(left: 25, right: 25, bottom: 20),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: COLORS.WHITE,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: COLORS.BLACK.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset('assets/icons/Chance.png'),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                    width: AppValue.widths * 0.6,
                    child: Text(
                      cluedata.name ?? 'Chưa có',
                      style: AppStyle.DEFAULT_18_BOLD
                          .copyWith(color: COLORS.TEXT_COLOR),
                    )),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                SvgPicture.asset('assets/icons/User.svg'),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    cluedata.customer?.name ?? 'Chưa có',
                    style: AppStyle.DEFAULT_LABEL_PRODUCT,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/mail.svg',
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                WidgetText(
                  title: cluedata.email?.val ?? "Chưa có",
                  style: AppStyle.DEFAULT_LABEL_PRODUCT
                      .copyWith(color: COLORS.GREY),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                SvgPicture.asset('assets/icons/Call.svg'),
                SizedBox(
                  width: 10,
                ),
                Text(cluedata.phone ?? "Chưa có",
                    style: AppStyle.DEFAULT_LABEL_PRODUCT
                        .copyWith(color: COLORS.TEXT_COLOR)),
                Spacer(),
                SvgPicture.asset("assets/icons/question_answer.svg"),
                SizedBox(
                  width: AppValue.widths * 0.01,
                ),
                WidgetText(
                  title: cluedata.total_note ?? "Chưa có",
                  style: TextStyle(
                    color: HexColor("#0052B4"),
                  ),
                ),
              ],
            ),
            AppValue.hSpaceTiny,
          ],
        ),
      ),
    );
  }

  showBotomSheet(List<FilterData> data) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        elevation: 2,
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints(maxHeight: Get.height * 0.7),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return SafeArea(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: WidgetText(
                          title: 'Chọn lọc',
                          textAlign: TextAlign.center,
                          style: AppStyle.DEFAULT_16_BOLD,
                        ),
                      ),
                      Column(
                        children: List.generate(
                            data.length,
                            (index) => GestureDetector(
                                  onTap: () {
                                    Get.back();
                                    GetListClueBloc.of(context).add(
                                        InitGetListClueEvent(
                                            data[index].id.toString(),
                                            1,
                                            search));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: COLORS.LIGHT_GREY))),
                                    child: Row(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/Filter.svg',
                                          width: 20,
                                          height: 20,
                                          fit: BoxFit.contain,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                            child: Container(
                                          child: WidgetText(
                                            title: data[index].name ?? '',
                                            style: AppStyle.DEFAULT_16,
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                )),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
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
