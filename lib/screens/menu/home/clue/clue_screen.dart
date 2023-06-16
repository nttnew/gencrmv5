import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/widgets/drop_down_base.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:get/get.dart';
import '../../../../bloc/clue/clue_bloc.dart';
import '../../../../bloc/manager_filter/manager_bloc.dart';
import '../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/clue.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/search_base.dart';
import '../../../../widgets/tree/tree_node_model.dart';
import '../../../../widgets/tree/tree_widget.dart';
import '../../../../widgets/widget_text.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';

class ClueScreen extends StatefulWidget {
  const ClueScreen({Key? key}) : super(key: key);

  @override
  State<ClueScreen> createState() => _ClueScreenState();
}

class _ClueScreenState extends State<ClueScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int page = BASE_URL.PAGE_DEFAULT;
  int total = 0;
  int length = 0;
  List<ClueData> listClue = [];
  String idFilter = '';
  String ids = '';
  String title = Get.arguments ?? '';
  String search = '';
  ScrollController _scrollController = ScrollController();
  late final ManagerBloc managerBloc;
  late final GetListClueBloc _bloc;

  @override
  void initState() {
    _bloc = GetListClueBloc.of(context);
    managerBloc =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    managerBloc.getManager(module: Module.DAU_MOI);
    GetNotificationBloc.of(context).add(CheckNotification());
    _bloc.add(InitGetListClueEvent());
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          length < total) {
        page = page + 1;
        _research(pageNew: page);
      }
    });
    super.initState();
  }

  _research({int? pageNew}) {
    page = pageNew ?? BASE_URL.PAGE_DEFAULT;
    _bloc.add(InitGetListClueEvent(
      filter: idFilter,
      page: page,
      ids: ids,
      search: search,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      resizeToAvoidBottomInset: false,
      drawer: MainDrawer(onPress: (v) => handleOnPressItemMenu(_drawerKey, v)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          backgroundColor: Color(0xff1AA928),
          onPressed: () {
            AppNavigator.navigateFormAdd('Thêm ${title}', ADD_CLUE);
          },
          child: Icon(Icons.add, size: 40),
        ),
      ),
      appBar: AppbarBase(_drawerKey, title),
      body: BlocBuilder<GetListClueBloc, ClueState>(builder: (context, state) {
        if (state is UpdateGetListClueState) {
          listClue = state.listClue;
          length = state.listClue.length;
          total = int.parse(state.total);
          return Column(
            children: [
              AppValue.vSpaceSmall,
              StreamBuilder<List<TreeNodeData>>(
                  stream: managerBloc.managerTrees,
                  builder: (context, snapshot) {
                    return SearchBase(
                      hint: 'Tìm ${title.toLowerCase()}',
                      leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
                      endIcon: (snapshot.data ?? []).isNotEmpty
                          ? SvgPicture.asset(
                              ICONS.IC_FILL_SVG,
                              width: 16,
                              height: 16,
                              fit: BoxFit.contain,
                            )
                          : null,
                      onClickRight: () {
                        showManagerFilter(context, managerBloc, (v) {
                          ids = v;
                          _research();
                        });
                      },
                      onSubmit: (String v) {
                        search = v;
                        _research();
                      },
                    );
                  }),
              SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: DropDownBase(
                    isName: true,
                    stream: _bloc.listType,
                    onTap: (item) {
                      idFilter = item.id.toString();
                      _research();
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      Future.delayed(Duration(microseconds: 300), () {
                    _research();
                  }),
                  child: ListView.separated(
                    physics: ClampingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
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
              ),
            ],
          );
        } else
          return noData();
      }),
    );
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
}
