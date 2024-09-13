import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/detail_clue/detail_clue_bloc.dart';
import 'package:gen_crm/screens/home/clue/widget/general_info.dart';
import 'package:gen_crm/screens/home/clue/widget/work_card_widget.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:get/get.dart';
import '../../../../bloc/clue/clue_bloc.dart';
import '../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/work_clue.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../attachment/attachment.dart';

class DetailInfoClue extends StatefulWidget {
  const DetailInfoClue({Key? key}) : super(key: key);

  @override
  State<DetailInfoClue> createState() => _DetailInfoClueState();
}

class _DetailInfoClueState extends State<DetailInfoClue> {
  String _id = Get.arguments ?? '';
  String _title = '';
  List<ModuleThaoTac> _list = [];
  late final ListNoteBloc _blocNote;
  late final GetDetailClueBloc _bloc;

  @override
  void initState() {
    _bloc = GetDetailClueBloc(
      userRepository: GetDetailClueBloc.of(context).userRepository,
    );
    _blocNote =
        ListNoteBloc(userRepository: ListNoteBloc.of(context).userRepository);
    _bloc.add(InitGetDetailClueEvent(_id));
    _getThaoTac();
    super.initState();
  }

  _getThaoTac() {
    if (ModuleMy.isShowNameModuleMy(ModuleMy.CONG_VIEC))
      _list.add(ModuleThaoTac(
        title:
            '${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.CONG_VIEC)}',
        icon: ICONS.IC_ADD_WORD_SVG,
        onThaoTac: () {
          Get.back();
          AppNavigator.navigateForm(
            title:
                '${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.CONG_VIEC)}',
            type: ADD_CLUE_JOB,
            id: int.parse(_id),
            onRefreshForm: () {
              _bloc.controllerCV.reloadData();
            },
          );
        },
      ));
    _list.add(ModuleThaoTac(
        title: getT(KeyT.add_discuss),
        icon: ICONS.IC_ADD_DISCUSS_SVG,
        onThaoTac: () {
          Get.back();
          AppNavigator.navigateAddNoteScreen(
            Module.DAU_MOI,
            _id,
            onRefresh: () {
              _blocNote.add(RefreshEvent());
            },
          );
        }));
    _list.add(ModuleThaoTac(
      title: getT(KeyT.see_attachment),
      icon: ICONS.IC_ATTACK_PNG,
      isSvg: false,
      onThaoTac: () {
        Get.back();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Attachment(
                  id: _id,
                  typeModule: Module.DAU_MOI,
                )));
      },
    ));
    _list.add(ModuleThaoTac(
        title: getT(KeyT.edit),
        icon: ICONS.IC_EDIT_SVG,
        onThaoTac: () {
          Get.back();
          AppNavigator.navigateForm(
            type: EDIT_CLUE,
            id: int.tryParse(_id),
            onRefreshForm: () {
              _bloc.add(InitGetDetailClueEvent(_id));
            },
          );
        }));
    _list.add(ModuleThaoTac(
        title: getT(KeyT.delete),
        icon: ICONS.IC_DELETE_SVG,
        onThaoTac: () {
          ShowDialogCustom.showDialogBase(
              onTap2: () => _bloc.add(InitDeleteClueEvent(_id)),
              content: getT(KeyT.are_you_sure_you_want_to_delete));
        }));
  }

  List<Widget> _listTab = [
    Tab(
      text: getT(KeyT.information),
    ),
    if (ModuleMy.isShowNameModuleMy(ModuleMy.CONG_VIEC))
      Tab(
        text: ModuleMy.getNameModuleMy(ModuleMy.CONG_VIEC, isTitle: true),
      )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<GetDetailClueBloc, DetailClueState>(
        bloc: _bloc,
        listener: (context, state) async {
          if (state is SuccessDeleteClueState) {
            Loading().popLoading();
            ShowDialogCustom.showDialogBase(
              title: getT(KeyT.notification),
              content: getT(KeyT.success),
              onTap1: () {
                Get.back();
                Get.back();
                Get.back();
                Get.back(result: true);
                GetListClueBloc.of(context).loadMoreController.reloadData();
              },
            );
          } else if (state is ErrorDeleteClueState) {
            Loading().popLoading();
            ShowDialogCustom.showDialogBase(
              title: getT(KeyT.notification),
              content: state.msg,
              textButton1: getT(KeyT.come_back),
              onTap1: () {
                Get.back();
                Get.back();
                Get.back();
                Get.back();
              },
            );
          }
        },
        child: Column(
          children: [
            AppbarBaseNormal(_title),
            AppValue.vSpaceTiny,
            Expanded(
              child: DefaultTabController(
                  length: _listTab.length,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          isScrollable: true,
                          indicatorColor: COLORS.TEXT_COLOR,
                          labelColor: COLORS.TEXT_COLOR,
                          unselectedLabelColor: COLORS.GREY,
                          labelStyle: AppStyle.DEFAULT_LABEL_TARBAR,
                          tabs: _listTab,
                        ),
                      ),
                      AppValue.hSpaceTiny,
                      Expanded(
                        child: TabBarView(
                          children: [
                            GeneralInfo(
                              id: _id,
                              blocNote: _blocNote,
                              bloc: _bloc,
                            ),
                            if (ModuleMy.isShowNameModuleMy(ModuleMy.CONG_VIEC))
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: ViewLoadMoreBase(
                                  isInit: true,
                                  functionInit: (page, isInit) {
                                    return _bloc.getWorkClue(
                                      id: _id,
                                      page: page,
                                    );
                                  },
                                  itemWidget: (int index, data) {
                                    final WorkClueData item =
                                        data as WorkClueData;
                                    return WorkCardWidget(
                                      onTap: () {
                                        AppNavigator.navigateDetailWork(
                                          int.tryParse(item.id ?? '') ?? 0,
                                        );
                                      },
                                      productCustomer: item.product_customer,
                                      nameCustomer: item.name_customer,
                                      nameJob: item.name_job,
                                      startDate: item.start_date,
                                      statusJob: item.status_job,
                                      totalComment: item.total_comment,
                                      color: item.color,
                                      recordUrl: item.recording_url,
                                    );
                                  },
                                  controller: _bloc.controllerCV,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
            BlocBuilder<GetDetailClueBloc, DetailClueState>(
              bloc: _bloc,
              builder: (context, state) {
                if (state is GetDetailClueState) {
                  _title = checkTitle(state.list ?? [], 'ho_ten_dm');
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {});
                  });
                  return ButtonCustom(
                    onTap: () {
                      showThaoTac(context, _list);
                    },
                  );
                }

                return ButtonCustom();
              },
            ),
          ],
        ),
      ),
    );
  }
}
