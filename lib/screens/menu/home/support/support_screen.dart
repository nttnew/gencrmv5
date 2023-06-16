import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/bloc/support/support_bloc.dart';
import 'package:get/get.dart';
import '../../../../bloc/manager_filter/manager_bloc.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/drop_down_base.dart';
import '../../../../widgets/search_base.dart';
import '../../../../widgets/tree/tree_node_model.dart';
import '../../../../widgets/tree/tree_widget.dart';
import '../../../../widgets/widget_text.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';
import 'widget/item_support.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final _key = GlobalKey<ExpandableFabState>();
  String search = '';
  String title = Get.arguments ?? '';
  String idFilter = '';
  ScrollController _scrollController = ScrollController();
  int length = 0;
  int total = 0;
  int page = BASE_URL.PAGE_DEFAULT;
  String ids = '';
  List<String> listAdd = [
    'Thêm check in',
    'Thêm ${(Get.arguments ?? '').toLowerCase()}'
  ];
  late final ManagerBloc managerBloc;
  late final SupportBloc _bloc;

  @override
  void initState() {
    _bloc = SupportBloc.of(context);
    managerBloc =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    managerBloc.getManager(module: Module.HO_TRO);
    _bloc.add(InitGetSupportEvent());
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          length < total) {
        page = page + 1;
        _research(pageNew: page);
      } else {}
    });
    GetNotificationBloc.of(context).add(CheckNotification());
    super.initState();
  }

  _handleRouter(String value) {
    AppNavigator.navigateFormAdd(value, ADD_SUPPORT, isCheckIn: listAdd.first == value);
  }

  _research({
    int? pageNew,
  }) {
    page = pageNew ?? BASE_URL.PAGE_DEFAULT;
    _bloc.add(InitGetSupportEvent(
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
                          ICONS.IC_SUPPORT_3X_PNG,
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
      body: BlocBuilder<SupportBloc, SupportState>(builder: (context, state) {
        if (state is SuccessGetSupportState) {
          length = state.listSupport.length;
          total = int.parse(state.total);
          return Column(
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
                    Future.delayed(Duration(milliseconds: 300), () {
                  _research();
                }),
                child: ListView.separated(
                  physics: ClampingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemBuilder: (context, index) => ItemSupport(
                    data: state.listSupport[index],
                  ),
                  itemCount: state.listSupport.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(),
                ),
              ))
            ],
          );
        } else
          return Container();
      }),
    );
  }
}
