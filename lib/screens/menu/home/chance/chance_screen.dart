import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/blocs.dart';
import '../../../../bloc/manager_filter/manager_bloc.dart';
import '../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/drop_down_base.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
import '../../../../widgets/search_base.dart';
import '../../../../widgets/tree/tree_node_model.dart';
import '../../../../widgets/tree/tree_widget.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';
import 'widget/widget_chance_item.dart';

class ChanceScreen extends StatefulWidget {
  const ChanceScreen({Key? key}) : super(key: key);

  @override
  State<ChanceScreen> createState() => _ChanceScreenState();
}

class _ChanceScreenState extends State<ChanceScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  String title = ModuleMy.getNameModuleMy(
    ModuleMy.LICH_HEN,
    isTitle: true,
  );
  late final ManagerBloc managerBloc;
  late final GetListChanceBloc _bloc;

  _reloadLanguage() async {
    await _bloc.loadMoreController.reloadData();
    title = ModuleMy.getNameModuleMy(
      ModuleMy.LICH_HEN,
      isTitle: true,
    );
    setState(() {});
  }

  @override
  void initState() {
    _bloc = GetListChanceBloc.of(context);
    managerBloc =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    managerBloc.getManager(module: Module.CO_HOI_BH);
    GetNotificationBloc.of(context).add(CheckNotification(isLoading: false));
    super.initState();
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
        onPress: (v) => handleOnPressItemMenu(_drawerKey, v),
        onReload: () async {
          await _reloadLanguage();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      appBar: AppbarBase(_drawerKey, title),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          backgroundColor: COLORS.ff1AA928,
          onPressed: () {
            AppNavigator.navigateFormAdd(
                '${getT(KeyT.add)} ${title.toLowerCase()}', ADD_CHANCE);
          },
          child: Icon(Icons.add, size: 40),
        ),
      ),
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
                      onSubmit: (String v) {
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
          return _bloc.getListChance(
            page: page,
          );
        },
        itemWidget: (int index, data) {
          ListChanceData snap = data;
          return WidgetItemChance(
            listChanceData: snap,
          );
        },
        controller: _bloc.loadMoreController,
      ),
    );
  }
}
