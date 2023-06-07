import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/bloc/work/work_bloc.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/screens/menu/home/work/index.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import '../../../../bloc/manager_filter/manager_bloc.dart';
import '../../../../src/app_const.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/drop_down_base.dart';
import '../../../../widgets/search_base.dart';
import '../../../../widgets/tree/tree_node_model.dart';
import '../../../../widgets/tree/tree_widget.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({Key? key}) : super(key: key);

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  ScrollController _scrollController = ScrollController();
  int page = BASE_URL.PAGE_DEFAULT;
  int pageTotal = 1;
  String search = "";
  String idFilter = "";
  String title = '';
  String ids = '';
  List<String> listAdd = [
    'Thêm check in',
    'Thêm ${(Get.arguments ?? '').toLowerCase()}'
  ];
  final _key = GlobalKey<ExpandableFabState>();

  _handleRouter(String value) {
    AppNavigator.navigateFormAdd(value, 5, isCheckIn: listAdd.first == value);
  }

  late final ManagerBloc managerBloc;

  @override
  void initState() {
    managerBloc =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    managerBloc.getManager(module: Module.CONG_VIEC);
    title = Get.arguments ?? '';
    GetListUnReadNotifiBloc.of(context).add(CheckNotification());
    WorkBloc.of(context).add(InitGetListWorkEvent());
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          page < pageTotal) {
        page = page + 1;
        _research(pageNew: page);
      } else {}
    });
    super.initState();
  }

  _research({int? pageNew}) {
    page = pageNew ?? BASE_URL.PAGE_DEFAULT;
    WorkBloc.of(context).add(InitGetListWorkEvent(
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
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        distance: 65,
        type: ExpandableFabType.up,
        child: Icon(Icons.add, size: 40),
        closeButtonStyle: const ExpandableFabCloseButtonStyle(
          child: Icon(Icons.close),
          foregroundColor: Colors.white,
          backgroundColor: Color(0xff1AA928),
        ),
        backgroundColor: Color(0xff1AA928),
        overlayStyle: ExpandableFabOverlayStyle(
          blur: 5,
        ),
        children: listAdd
            .map(
              (e) => InkWell(
                onTap: () async {
                  final state = _key.currentState;
                  if (state != null) {
                    if (state.isOpen) {
                      await _handleRouter(e);
                      state.toggle();
                    }
                  }
                },
                child: Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: COLORS.BLACK.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: WidgetText(
                        title: e,
                        style: AppStyle.DEFAULT_18_BOLD.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: COLORS.BLACK.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          )
                        ],
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          ICONS.IC_WORK_3X_PNG,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
            .toList(),
      ),
      appBar: AppbarBase(_drawerKey, title),
      body: Container(
        // padding: EdgeInsets.only(bottom: 70),
        child: Column(
          children: [
            AppValue.vSpaceSmall,
            StreamBuilder<List<TreeNodeData>>(
                stream: managerBloc.managerTrees,
                builder: (context, snapshot) {
                  return SearchBase(
                    hint: "Tìm ${title.toLowerCase()}",
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
                  stream: WorkBloc.of(context).listType,
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
            Expanded(child:
                BlocBuilder<WorkBloc, WorkState>(builder: (context, state) {
              if (state is SuccessGetListWorkState) {
                pageTotal = state.pageCount;
                return RefreshIndicator(
                  onRefresh: () =>
                      Future.delayed(Duration(milliseconds: 300), () {
                    _research();
                  }),
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 8),
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => InkWell(
                        onTap: () => AppNavigator.navigateDetailWork(
                              int.parse(state.data_list[index].id!),
                              state.data_list[index].name_job ?? '',
                            ),
                        child: WorkCardWidget(
                          data_list: state.data_list[index],
                          index: index,
                          length: state.data_list.length,
                        )),
                    itemCount: state.data_list.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(),
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
}
