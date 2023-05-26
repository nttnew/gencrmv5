import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:get/get.dart';
import '../../../../bloc/clue/clue_bloc.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/clue.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
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
  int length = 0;
  List<ClueData> listClue = [];
  String idFilter = "";
  String title = Get.arguments;

  String search = '';
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    GetListClueBloc.of(context)
        .add(InitGetListClueEvent('', BASE_URL.PAGE_DEFAULT, ''));
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          length < total) {
        page = page + 1;
        GetListClueBloc.of(context).add(InitGetListClueEvent('', page, search));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MainDrawer(onPress: (v) => handleOnPressItemMenu(_drawerKey, v)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          backgroundColor: Color(0xff1AA928),
          onPressed: () {
            AppNavigator.navigateFormAdd('Thêm ${Get.arguments}', 2);
          },
          child: Icon(Icons.add, size: 40),
        ),
      ),
      appBar: AppbarBase(_drawerKey, title),
      body: Column(
        children: [
          AppValue.vSpaceTiny,
          _buildSearch(),
          BlocBuilder<GetListClueBloc, ClueState>(builder: (context, state) {
            if (state is UpdateGetListClueState) {
              listClue = state.listClue;
              length = state.listClue.length;
              total = int.parse(state.total);
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      Future.delayed(Duration(microseconds: 300), () {
                    page = BASE_URL.PAGE_DEFAULT;

                    GetListClueBloc.of(context)
                        .add(InitGetListClueEvent('', page, ''));
                  }),
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 16),
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: length,
                    itemBuilder: (context, index) {
                      return _buildCustomer(listClue[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(),
                  ),
                ),
              );
            } else
              return noData();
          }),
        ],
      ),
    );
  }

  _buildSearch() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: HexColor("#DBDBDB")),
          borderRadius: BorderRadius.circular(10),
        ),
        child:
            BlocBuilder<GetListClueBloc, ClueState>(builder: (context, state) {
          if (state is UpdateGetListClueState) {
            return WidgetSearch(
              hintTextStyle: TextStyle(
                  fontFamily: "Quicksand",
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
                page = BASE_URL.PAGE_DEFAULT;
                GetListClueBloc.of(context)
                    .add(InitGetListClueEvent('', page, v));
              },
            );
          }
          return noData();
        }));
  }

  _buildCustomer(ClueData clueData) {
    return InkWell(
      onTap: () {
        AppNavigator.navigateInfoClue(clueData.id ?? '', clueData.name ?? '');
      },
      child: Container(
        margin: EdgeInsets.only(left: 25, right: 25, bottom: 20),
        padding: EdgeInsets.all(15),
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
            itemTextIcon(
              paddingTop: 0,
              text: clueData.name ?? 'Chưa có',
              icon: ICONS.IC_CHANCE_3X_PNG,
              isSVG: false,
              styleText:
                  AppStyle.DEFAULT_18_BOLD.copyWith(color: COLORS.TEXT_COLOR),
            ),
            itemTextIcon(
              text: clueData.customer?.name ?? 'Chưa có',
              icon: ICONS.IC_USER2_SVG,
              colorIcon: COLORS.GREY,
            ),
            itemTextIcon(
              text: clueData.email?.val ?? 'Chưa có',
              icon: ICONS.IC_MAIL_SVG,
              colorIcon: COLORS.GREY,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Expanded(
                    child: itemTextIcon(
                      paddingTop: 0,
                      text: clueData.phone?.val ?? 'Chưa có',
                      icon: ICONS.IC_CALL_SVG,
                      styleText: AppStyle.DEFAULT_LABEL_PRODUCT
                          .copyWith(color: COLORS.TEXT_COLOR),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  SvgPicture.asset(ICONS.IC_QUESTION_SVG),
                  SizedBox(
                    width: 4,
                  ),
                  WidgetText(
                    title: clueData.total_note ?? 'Chưa có',
                    style: TextStyle(
                      color: HexColor("#0052B4"),
                    ),
                  ),
                ],
              ),
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
                                    page = BASE_URL.PAGE_DEFAULT;
                                    GetListClueBloc.of(context).add(
                                        InitGetListClueEvent(
                                            data[index].id.toString(),
                                            page,
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
