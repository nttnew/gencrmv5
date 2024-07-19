import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/bloc/work/work_bloc.dart';
import 'package:gen_crm/src/models/model_generator/work.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/screens/menu/home/work/widget/index.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import '../../../../bloc/manager_filter/manager_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/drop_down_base.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
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
  String title = '';
  List<String> listAdd = [];
  final _key = GlobalKey<ExpandableFabState>();
  late final ManagerBloc managerBloc;
  late final WorkBloc _bloc;

  @override
  void initState() {
    _getDataFirst();
    _bloc = WorkBloc.of(context);
    managerBloc =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    managerBloc.getManager(module: Module.CONG_VIEC);
    UnreadNotificationBloc.of(context).add(CheckNotification(isLoading: false));
    super.initState();
  }

  _handleRouter(String value) {
    AppNavigator.navigateForm(
      title: value,
      type: ADD_JOB,
      isCheckIn: listAdd.first == value,
    );
  }

  _getDataFirst() {
    title = ModuleMy.getNameModuleMy(
      ModuleMy.CONG_VIEC,
      isTitle: true,
    );
    listAdd = [
      '${getT(KeyT.add)} ${getT(KeyT.check_in).toLowerCase()}',
      '${getT(KeyT.add)} ${title.toLowerCase()}'
    ];
  }

  _reloadLanguage() async {
    await _bloc.loadMoreController.reloadData();
    _getDataFirst();
    setState(() {});
  }

  @override
  void dispose() {
    _bloc.init();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      resizeToAvoidBottomInset: false,
      drawer: MainDrawer(
        drawerKey: _drawerKey,
        onReload: () async {
          await _reloadLanguage();
        },
        moduleMy: ModuleMy.CONG_VIEC,
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        distance: 65,
        type: ExpandableFabType.up,
        child: Icon(Icons.add, size: 40),
        closeButtonStyle: const ExpandableFabCloseButtonStyle(
          child: Icon(Icons.close),
          foregroundColor: COLORS.WHITE,
          backgroundColor: COLORS.ff1AA928,
        ),
        backgroundColor: COLORS.ff1AA928,
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
                        color: COLORS.WHITE,
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
                        color: COLORS.WHITE,
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
      body: ViewLoadMoreBase(
        isShowAll: _bloc.listType,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppValue.vSpaceSmall,
              StreamBuilder<List<TreeNodeData>>(
                  stream: managerBloc.managerTrees,
                  builder: (context, snapshot) {
                    return SearchBase(
                      hint: "${getT(KeyT.find)} ${title.toLowerCase()}",
                      leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
                      endIcon: (snapshot.data ?? []).isNotEmpty
                          ? SvgPicture.asset(
                              ICONS.IC_USER2_SVG,
                              width: 16,
                              height: 16,
                              fit: BoxFit.contain,
                            )
                          : null,
                      onClickRight: () {
                        showManagerFilter(context, managerBloc, (v) {
                          _bloc.ids = v;
                          _bloc.loadMoreController.reloadData();
                        });
                      },
                      onChange: (String v) {
                        _bloc.search = v;
                        _bloc.loadMoreController.reloadData();
                      },
                    );
                  }),
              AppValue.vSpaceTiny,
              DropDownBase(
                isName: true,
                stream: _bloc.listType,
                onTap: (item) {
                  _bloc.idFilter = item.id.toString();
                  _bloc.loadMoreController.reloadData();
                },
              ),
            ],
          ),
        ),
        isInit: true,
        functionInit: (page, isInit) {
          return _bloc.getListWork(
            page: page,
          );
        },
        itemWidget: (int index, data) {
          WorkItemData snap = data;
          return WorkCardWidget(
            item: snap,
            onTap: () => AppNavigator.navigateDetailWork(
              int.parse(snap.id ?? '0'),
            ),
          );
        },
        controller: _bloc.loadMoreController,
      ),
    );
  }
}
