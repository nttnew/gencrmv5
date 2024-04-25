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
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
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

  _getThaoTac() {
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
      icon: ICONS.IC_ATTACK_SVG,
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
            LoadingApi().popLoading();
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
            LoadingApi().popLoading();
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
                  length: 2,
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
                          tabs: [
                            Tab(
                              text: getT(KeyT.information),
                            ),
                            Tab(
                              text: ModuleMy.getNameModuleMy(
                                ModuleMy.CONG_VIEC,
                                isTitle: true,
                              ),
                            )
                          ],
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
                            Padding(
                              padding: EdgeInsets.only(
                                top: 8,
                              ),
                              child: ViewLoadMoreBase(
                                functionInit: (page, isInit) {
                                  return _bloc.getJobChance(
                                    id: int.parse(_id),
                                    page: page,
                                    isInit: isInit,
                                  );
                                },
                                itemWidget: (int index, data) {
                                  final DataFormAdd item = data as DataFormAdd;
                                  return GestureDetector(
                                    onTap: () {
                                      AppNavigator.navigateDetailWork(
                                        int.tryParse(item.id ?? '') ?? 0,
                                        // item.name_job ?? '',
                                      );
                                    },
                                    child: WorkCardWidget(
                                      color: item.color,
                                      nameCustomer: item.name_customer,
                                      nameJob: item.name_job,
                                      statusJob: item.status_job,
                                      startDate: item.start_date,
                                      totalComment: item.total_comment,
                                      productCustomer: item.product_customer,
                                    ),
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
                  return ButtonThaoTac(onTap: () {
                    showThaoTac(context, _list);
                  });
                }
                return ButtonThaoTac(disable: true, onTap: () {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
