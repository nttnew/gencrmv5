import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/screens/menu/widget/box_item.dart';
import 'package:gen_crm/widgets/drop_down_base.dart';
import '../../../../bloc/clue/clue_bloc.dart';
import '../../../../bloc/manager_filter/manager_bloc.dart';
import '../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/clue.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
import '../../../../widgets/search_base.dart';
import '../../../../widgets/tree/tree_node_model.dart';
import '../../../../widgets/tree/tree_widget.dart';
import '../../../../widgets/widget_text.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';
import '../../widget/information.dart';

class ClueScreen extends StatefulWidget {
  const ClueScreen({Key? key}) : super(key: key);

  @override
  State<ClueScreen> createState() => _ClueScreenState();
}

class _ClueScreenState extends State<ClueScreen> {
  late final GlobalKey<ScaffoldState> _drawerKey;
  late final ManagerBloc managerBloc;
  late final GetListClueBloc _bloc;
  String title = ModuleMy.getNameModuleMy(
    ModuleMy.DAU_MOI,
    isTitle: true,
  );

  @override
  void initState() {
    _drawerKey = GlobalKey();
    _bloc = GetListClueBloc.of(context);
    managerBloc =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    managerBloc.getManager(module: Module.DAU_MOI);
    UnreadNotificationBloc.of(context).add(CheckNotification(isLoading: false));
    super.initState();
  }

  _reloadLanguage() async {
    await _bloc.loadMoreController.reloadData();
    title = ModuleMy.getNameModuleMy(
      ModuleMy.DAU_MOI,
      isTitle: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      resizeToAvoidBottomInset: false,
      appBar: AppbarBase(_drawerKey, title),
      drawer: MainDrawer(
        drawerKey: _drawerKey,
        moduleMy: ModuleMy.DAU_MOI,
        onReload: () async {
          await _reloadLanguage();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          backgroundColor: COLORS.ff1AA928,
          onPressed: () {
            AppNavigator.navigateForm(
              title: '${getT(KeyT.add)} ${title}',
              type: ADD_CLUE,
            );
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
                      hint: '${getT(KeyT.find)} ${title.toLowerCase()}',
                      leadIcon: itemSearch(),
                      endIcon: (snapshot.data ?? []).isNotEmpty
                          ? itemSearchFilterTree()
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
          return _bloc.getListClue(
            page: page,
          );
        },
        itemWidget: (int index, data) {
          ClueData snap = data;
          return _buildCustomer(snap);
        },
        controller: _bloc.loadMoreController,
      ),
    );
  }

  _buildCustomer(ClueData clueData) {
    return BoxItem(
      onTap: () {
        AppNavigator.navigateDetailClue(
          clueData.id ?? '',
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          itemTextIcon(
            paddingTop: 0,
            text: clueData.name ?? getT(KeyT.not_yet),
            icon: ICONS.IC_CHANCE_3X_PNG,
            isSVG: false,
            styleText:
                AppStyle.DEFAULT_18_BOLD.copyWith(color: COLORS.TEXT_COLOR),
          ),
          itemTextIcon(
            text: clueData.customer?.name ?? getT(KeyT.not_yet),
            icon: ICONS.IC_USER_NEW_PNG,
            isSVG: false,
            colorIcon: COLORS.GREY,
          ),
          itemTextIcon(
            text: clueData.email?.val ?? getT(KeyT.not_yet),
            icon: ICONS.IC_MAIL_SVG,
            colorIcon: COLORS.GREY,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              children: [
                Expanded(
                  child: itemTextIcon(
                    onTap: () {
                      String phone = clueData.phone?.val ?? '';
                      String name = clueData.customer?.name ?? '';
                      if (phone != '') {
                        dialogShowAllSDT(
                          context,
                          handelListSdt(phone),
                          name: name,
                        );
                      }
                    },
                    paddingTop: 0,
                    text: clueData.phone?.val ?? getT(KeyT.not_yet),
                    icon: ICONS.IC_PHONE_C_PNG,
                    colorIcon: COLORS.GREY,
                    isSVG: false,
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
                  title: clueData.total_note ?? getT(KeyT.not_yet),
                  style: TextStyle(
                    color: COLORS.TEXT_BLUE_BOLD,
                  ),
                ),
              ],
            ),
          ),
          AppValue.hSpaceTiny,
        ],
      ),
    );
  }
}
