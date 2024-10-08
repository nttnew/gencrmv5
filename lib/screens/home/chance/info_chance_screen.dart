import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:get/get.dart';
import '../../../../bloc/blocs.dart';
import '../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/detail_customer.dart';
import '../../../../src/models/model_generator/job_chance.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../../../widgets/widget_appbar.dart';
import '../../attachment/attachment.dart';
import '../clue/widget/work_card_widget.dart';
import 'widget/chance_info.dart';

class InfoChancePage extends StatefulWidget {
  const InfoChancePage({Key? key}) : super(key: key);

  @override
  State<InfoChancePage> createState() => _InfoChancePageState();
}

class _InfoChancePageState extends State<InfoChancePage> {
  List<InfoDataModel> dataChance = [];
  String _id = Get.arguments ?? '';
  String _title = '';
  List<ModuleThaoTac> _list = [];
  late final GetListDetailChanceBloc _bloc;
  late final ListNoteBloc _blocNote;

  @override
  void initState() {
    _bloc = GetListDetailChanceBloc(
        userRepository: GetListDetailChanceBloc.of(context).userRepository);
    _bloc.add(InitGetListDetailEvent(int.parse(_id)));
    _blocNote =
        ListNoteBloc(userRepository: ListNoteBloc.of(context).userRepository);
    _getThaoTac();
    super.initState();
  }

  List<Widget> _listTab = [
    Tab(
      text: getT(KeyT.information),
    ),
    if (ModuleMy.isShowNameModuleMy(ModuleMy.CONG_VIEC))
      Tab(
        text: ModuleMy.getNameModuleMy(
          ModuleMy.CONG_VIEC,
          isTitle: true,
        ),
      )
  ];

  _getThaoTac() {
    _list.add(ModuleThaoTac(
      title: getT(KeyT.sign),
      icon: ICONS.IC_ELECTRIC_SIGN_PNG,
      isSvg: false,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateFormSign(
          getT(KeyT.sign),
          _id,
          type: Module.CO_HOI_BH,
          onRefresh: () {
            _bloc.add(InitGetListDetailEvent(int.parse(_id)));
          },
        );
      },
    ));

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
              type: ADD_CHANCE_JOB,
              id: int.parse(_id),
              onRefreshForm: () {
                _bloc.controllerCV.reloadData();
              });
        },
      ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.add_discuss),
      icon: ICONS.IC_ADD_DISCUSS_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateAddNoteScreen(
          Module.CO_HOI_BH,
          _id,
          onRefresh: () {
            _blocNote.add(RefreshEvent());
          },
        );
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.see_attachment),
      icon: ICONS.IC_ATTACK_PNG,
      isSvg: false,
      onThaoTac: () async {
        Get.back();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Attachment(
                  id: _id,
                  typeModule: Module.CO_HOI_BH,
                )));
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.edit),
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateForm(
          type: EDIT_CHANCE,
          id: int.tryParse(_id),
          onRefreshForm: () {
            _bloc.add(InitGetListDetailEvent(int.parse(_id)));
          },
        );
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.delete),
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
            onTap2: () => _bloc.add(InitDeleteChanceEvent(_id)),
            content: getT(KeyT.are_you_sure_you_want_to_delete));
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<GetListDetailChanceBloc, DetailChanceState>(
        bloc: _bloc,
        listener: (context, state) async {
          if (state is SuccessDeleteChanceState) {
            Loading().popLoading();
            ShowDialogCustom.showDialogBase(
              title: getT(KeyT.notification),
              content: getT(KeyT.success),
              onTap1: () {
                Get.back();
                Get.back();
                Get.back();
                Get.back(result: true);
                GetListChanceBloc.of(context).loadMoreController.reloadData();
              },
            );
          } else if (state is ErrorDeleteChanceState) {
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
            WidgetAppbar(
              title: _title,
              textColor: COLORS.BLACK,
              padding: 10,
              right: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      AppNavigator.navigateBieuMau(
                        idDetail: _id,
                        module: PDF_CO_HOI,
                      );
                    },
                    icon: Icon(
                      Icons.print,
                      color: !isCarCrm() ? COLORS.BLACK : COLORS.WHITE,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            AppValue.vSpaceTiny,
            Expanded(
              child: DefaultTabController(
                  length: _listTab.length,
                  child: Column(
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
                            ChanceInfo(
                              id: _id,
                              blocNote: _blocNote,
                              bloc: _bloc,
                            ),
                            if (ModuleMy.isShowNameModuleMy(ModuleMy.CONG_VIEC))
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 8,
                                ),
                                child: ViewLoadMoreBase(
                                  isInit: true,
                                  functionInit: (page, isInit) {
                                    return _bloc.getJobChance(
                                      id: int.parse(_id),
                                      page: page,
                                    );
                                  },
                                  itemWidget: (int index, data) {
                                    final DataFormAdd item =
                                        data as DataFormAdd;
                                    return WorkCardWidget(
                                      onTap: () {
                                        AppNavigator.navigateDetailWork(
                                          int.tryParse(item.id ?? '') ?? 0,
                                        );
                                      },
                                      color: item.color,
                                      nameCustomer: item.name_customer,
                                      nameJob: item.name_job,
                                      statusJob: item.status_job,
                                      startDate: item.start_date,
                                      totalComment: item.total_comment,
                                      productCustomer: item.product_customer,
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
            BlocBuilder<GetListDetailChanceBloc, DetailChanceState>(
              bloc: _bloc,
              builder: (context, state) {
                if (state is UpdateGetListDetailChanceState) {
                  _title = checkTitle(state.data, 'col111');
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    setState(() {});
                  });
                  return ButtonCustom(onTap: () {
                    showThaoTac(context, _list);
                  });
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
