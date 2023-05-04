import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:get/get.dart';
import '../../../../bloc/clue/clue_bloc.dart';
import '../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/clue.dart';
import '../../../../src/src_index.dart';
import '../../../../storages/share_local.dart';
import '../../../../widgets/widget_appbar.dart';
import '../../../../widgets/widget_search.dart';
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
      drawer: MainDrawer(onPress: (v) => handleOnPressItemMenu(_drawerKey, v)),
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
                child: SvgPicture.asset(ICONS.IC_MENU_SVG),
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
                  return SvgPicture.asset(ICONS.IC_NOTIFICATION_SVG);
                } else {
                  return SvgPicture.asset(ICONS.IC_NOTIFICATION2_SVG);
                }
              }),
            ),
          ),
          AppValue.vSpaceTiny,
          _buildSearch(),
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
        margin: EdgeInsets.symmetric(
            horizontal: AppValue.widths * 0.05,
            vertical: AppValue.heights * 0.02),
        width: double.infinity,
        height: AppValue.heights * 0.06,
        decoration: BoxDecoration(
          border: Border.all(color: HexColor("#DBDBDB")),
          borderRadius: BorderRadius.circular(10),
        ),
        child:
            BlocBuilder<GetListClueBloc, ClueState>(builder: (context, state) {
          if (state is UpdateGetListClueState) {
            return WidgetSearch(
              hintTextStyle: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: HexColor("#707070")),
              hint: 'Tìm ${Get.arguments.toString().toLowerCase()}',
              leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
              endIcon: SvgPicture.asset(ICONS.IC_FILL_SVG),
              onClickRight: () {
                showBotomSheet(state.listFilter);
              },
              onSubmit: (v) {
                search = v;
                GetListClueBloc.of(context).add(InitGetListClueEvent('', 1, v));
              },
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
        AppNavigator.navigateInfoClue(cluedata.id!, cluedata.name!);
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
                Image.asset(ICONS.IC_CHANCE_PNG),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                    width: AppValue.widths * 0.6,
                    child: Text(
                      (cluedata.name == "" || cluedata.name == null)
                          ? 'Chưa có'
                          : cluedata.name!,
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
                SvgPicture.asset(ICONS.IC_USER2_SVG),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    (cluedata.customer!.name == "" ||
                            cluedata.customer!.name == null)
                        ? 'Chưa có'
                        : cluedata.customer!.name!,
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
                  ICONS.IC_MAIL_SVG,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                WidgetText(
                  title:
                      (cluedata.email!.val == null || cluedata.email!.val == "")
                          ? "Chưa có"
                          : cluedata.email!.val!,
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
                SvgPicture.asset(ICONS.IC_CALL_SVG),
                SizedBox(
                  width: 10,
                ),
                Text(
                    (cluedata.phone!.val == null || cluedata.phone!.val == "")
                        ? "Chưa có"
                        : cluedata.phone!.val!,
                    style: AppStyle.DEFAULT_LABEL_PRODUCT
                        .copyWith(color: COLORS.TEXT_COLOR)),
                Spacer(),
                SvgPicture.asset(ICONS.IC_QUESTION_SVG),
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
                                          ICONS.IC_FILTER_SVG,
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
}
