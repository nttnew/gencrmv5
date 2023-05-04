import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/bloc/work/work_bloc.dart';
import 'package:gen_crm/src/models/model_generator/work.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/screens/menu/home/work/index.dart';
import 'package:gen_crm/widgets/widget_search.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../src/app_const.dart';
import '../../../../storages/share_local.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({Key? key}) : super(key: key);

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  ScrollController _scrollController = ScrollController();
  int page = 1;
  int pageTotal = 1;
  String search = "";
  String filter_id = "";
  String title = '';

  @override
  void initState() {
    GetListUnReadNotifiBloc.of(context).add(CheckNotification());
    WorkBloc.of(context).add(InitGetListWorkEvent("1", "", ""));
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          page < pageTotal) {
        WorkBloc.of(context).add(
            InitGetListWorkEvent((page + 1).toString(), search, filter_id));
        page = page + 1;
      } else {}
    });
    title = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MainDrawer(onPress: (v) => handleOnPressItemMenu(_drawerKey, v)),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff1AA928),
        onPressed: () =>
            AppNavigator.navigateFormAdd('Thêm ${title.toLowerCase()}', 5),
        child: Icon(Icons.add, size: 40),
      ),
      appBar: AppBar(
        toolbarHeight: AppValue.heights * 0.1,
        backgroundColor: HexColor("#D0F1EB"),
        centerTitle: false,
        title: Text(Get.arguments,
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
      body: Container(
        // padding: EdgeInsets.only(bottom: 70),
        child: Column(
          children: [
            BlocBuilder<WorkBloc, WorkState>(builder: (context, state) {
              if (state is SuccessGetListWorkState)
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
                  child: WidgetSearch(
                    hintTextStyle: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: HexColor("#707070")),
                    hint: "Tìm ${title.toLowerCase()}",
                    onSubmit: (v) {
                      search = v;
                      WorkBloc.of(context)
                          .add(InitGetListWorkEvent("1", v, filter_id));
                    },
                    leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
                    endIcon: SvgPicture.asset(ICONS.IC_FILL_SVG),
                    onClickRight: () {
                      showBotomSheet(state.data_filter);
                    },
                  ),
                );
              else
                return Container();
            }),
            Expanded(child:
                BlocBuilder<WorkBloc, WorkState>(builder: (context, state) {
              if (state is SuccessGetListWorkState) {
                pageTotal = state.pageCount;
                return Container(
                  // margin: EdgeInsets.only(bottom: 70),
                  child: RefreshIndicator(
                    onRefresh: () =>
                        Future.delayed(Duration(milliseconds: 300), () {
                      WorkBloc.of(context)
                          .add(InitGetListWorkEvent("1", "", ""));
                    }),
                    child: ListView.separated(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => InkWell(
                          onTap: () => AppNavigator.navigateDeatailWork(
                              int.parse(state.data_list[index].id!),
                              state.data_list[index].name_job ?? ''),
                          child: WorkCardWidget(
                            data_list: state.data_list[index],
                            index: index,
                            length: state.data_list.length,
                          )),
                      itemCount: state.data_list.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(
                        height: AppValue.heights * 0.01,
                      ),
                    ),
                  ),
                );
              } else
                return Container();
            }))
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
                                    filter_id = data[index].id.toString();
                                    WorkBloc.of(context).add(
                                        InitGetListWorkEvent("1", search,
                                            data[index].id.toString()));
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
