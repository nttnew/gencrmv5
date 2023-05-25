import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/bloc/support/support_bloc.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/customer.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_search.dart';
import '../../../../widgets/widget_text.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';
import 'item_support.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  String search = '';
  String id_filter = '';
  ScrollController _scrollController = ScrollController();
  int length = 0;
  int total = 0;
  int page = 1;

  @override
  void initState() {
    SupportBloc.of(context).add(InitGetSupportEvent(1, '', ''));
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          length < total) {
        SupportBloc.of(context)
            .add(InitGetSupportEvent(page + 1, search, id_filter));
        page = page + 1;
      } else {}
    });
    GetListUnReadNotifiBloc.of(context).add(CheckNotification());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MainDrawer(onPress: (v) => handleOnPressItemMenu(_drawerKey, v)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff1AA928),
        onPressed: () => AppNavigator.navigateFormAdd(
            'Thêm ${Get.arguments.toString().toLowerCase()}', 6),
        child: Icon(Icons.add, size: 40),
      ),
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: AppValue.heights * 0.1,
        backgroundColor: HexColor("#D0F1EB"),
        title: Text(Get.arguments ?? '',
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w700,
                fontSize: 16)),
        leading: Padding(
            padding: EdgeInsets.only(left: 40),
            child: InkWell(
                onTap: () {
                  if (_drawerKey.currentContext != null &&
                      !_drawerKey.currentState!.isDrawerOpen) {
                    _drawerKey.currentState!.openDrawer();
                  }
                },
                child: SvgPicture.asset(ICONS.IC_MENU_SVG))),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 30),
              child: InkWell(
                onTap: () => AppNavigator.navigateNotification(),
                child:
                    BlocBuilder<GetListUnReadNotifiBloc, UnReadListNotifiState>(
                        builder: (context, state) {
                  if (state is NotificationNeedRead) {
                    return SvgPicture.asset(ICONS.IC_NOTIFICATION_SVG);
                  } else {
                    return SvgPicture.asset(ICONS.IC_NOTIFICATION2_SVG);
                  }
                }),
              ))
        ],
      ),
      body: BlocBuilder<SupportBloc, SupportState>(builder: (context, state) {
        if (state is SuccessGetSupportState) {
          length = state.listSupport.length;
          total = int.parse(state.total);
          return Column(
            children: [
              AppValue.vSpaceTiny,
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: HexColor("#DBDBDB")),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: WidgetSearch(
                  hintTextStyle: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: HexColor("#707070")),
                  hint:
                      "Tìm ${Get.arguments == 'CSKH' ? Get.arguments : Get.arguments.toString().toLowerCase()}",
                  onSubmit: (v) {
                    search = v;
                    SupportBloc.of(context)
                        .add(InitGetSupportEvent(1, search, id_filter));
                  },
                  leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
                  endIcon: SvgPicture.asset(ICONS.IC_FILL_SVG),
                  onClickRight: () {
                    showBotomSheet(state.listFilter);
                  },
                ),
              ),
              Expanded(
                  child: RefreshIndicator(
                onRefresh: () =>
                    Future.delayed(Duration(milliseconds: 300), () {
                  SupportBloc.of(context).add(InitGetSupportEvent(1, '', ''));
                }),
                child: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: ListView.separated(
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemBuilder: (context, index) => ItemSupport(
                      data: state.listSupport[index],
                    ),
                    itemCount: state.listSupport.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(),
                  ),
                ),
              ))
            ],
          );
        } else
          return Container();
      }),
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
                  child: SingleChildScrollView(
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
                                      id_filter = data[index].id.toString();
                                      SupportBloc.of(context).add(
                                          InitGetSupportEvent(
                                              1, search, id_filter));
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
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
                ),
              );
            },
          );
        });
  }
}
