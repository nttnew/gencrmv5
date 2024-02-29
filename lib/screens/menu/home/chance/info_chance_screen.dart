import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:get/get.dart';
import '../../../../bloc/blocs.dart';
import '../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/job_chance.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/listview_loadmore_base.dart';
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
  List<DataDetailChance> dataChance = [];
  String id = Get.arguments[0] ?? '';
  String name = Get.arguments[1] ?? '';
  List<ModuleThaoTac> list = [];
  late final GetListDetailChanceBloc _bloc;
  late final ListNoteBloc _blocNote;

  @override
  void initState() {
    _bloc = GetListDetailChanceBloc(
        userRepository: GetListDetailChanceBloc.of(context).userRepository);
    _bloc.add(InitGetListDetailEvent(int.parse(id)));
    _blocNote =
        ListNoteBloc(userRepository: ListNoteBloc.of(context).userRepository);
    getThaoTac();
    super.initState();
  }

  getThaoTac() {
    list.add(ModuleThaoTac(
      title:
          "${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.CONG_VIEC)}",
      icon: ICONS.IC_ADD_WORD_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateFormAdd(
            "${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.CONG_VIEC)}",
            ADD_CHANCE_JOB,
            id: int.parse(id), onRefresh: () {
          _bloc.controllerCV.reloadData();
        });
      },
    ));

    list.add(ModuleThaoTac(
      title: getT(KeyT.add_discuss),
      icon: ICONS.IC_ADD_DISCUSS_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateAddNoteScreen(Module.CO_HOI_BH, id, onRefresh: () {
          _blocNote.add(RefreshEvent());
        });
      },
    ));

    list.add(ModuleThaoTac(
      title: getT(KeyT.see_attachment),
      icon: ICONS.IC_ATTACK_SVG,
      onThaoTac: () async {
        Get.back();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Attachment(
                  id: id,
                  typeModule: Module.CO_HOI_BH,
                )));
      },
    ));

    list.add(ModuleThaoTac(
      title: getT(KeyT.edit),
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateEditDataScreen(id, EDIT_CHANCE, onRefresh: () {
          _bloc.add(InitGetListDetailEvent(int.parse(id)));
        });
      },
    ));

    list.add(ModuleThaoTac(
      title: getT(KeyT.delete),
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
            onTap2: () => _bloc.add(InitDeleteChanceEvent(id)),
            content: getT(KeyT.are_you_sure_you_want_to_delete));
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<GetListDetailChanceBloc, DetailChanceState>(
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
                Get.back();
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
            AppbarBaseNormal(name),
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
                              id: id,
                              blocNote: _blocNote,
                              bloc: _bloc,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 8,
                              ),
                              child: ListViewLoadMoreBase(
                                functionInit: (page, isInit) {
                                  return _bloc.getJobChance(
                                    id: int.parse(id),
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
                                        item.name_job ?? '',
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
            ButtonThaoTac(onTap: () {
              showThaoTac(context, list);
            }),
          ],
        ),
      ),
    );
  }
}
