import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/detail_clue/detail_clue_bloc.dart';
import 'package:gen_crm/screens/menu/home/clue/widget/general_info.dart';
import 'package:gen_crm/screens/menu/home/clue/widget/work_card_widget.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:get/get.dart';
import '../../../../bloc/clue/clue_bloc.dart';
import '../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/listview_loadmore_base.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../../../widgets/widget_appbar.dart';
import '../../attachment/attachment.dart';

class DetailInfoClue extends StatefulWidget {
  const DetailInfoClue({Key? key}) : super(key: key);

  @override
  State<DetailInfoClue> createState() => _DetailInfoClueState();
}

class _DetailInfoClueState extends State<DetailInfoClue> {
  String id = Get.arguments[0];
  String name = Get.arguments[1];
  List<ModuleThaoTac> list = [];
  late final ListNoteBloc _blocNote;
  late final GetDetailClueBloc _bloc;

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void initState() {
    _bloc = GetDetailClueBloc(
      userRepository: GetDetailClueBloc.of(context).userRepository,
    );
    _blocNote =
        ListNoteBloc(userRepository: ListNoteBloc.of(context).userRepository);
    _bloc.add(InitGetDetailClueEvent(id));
    getThaoTac();
    super.initState();
  }

  getThaoTac() {
    list.add(ModuleThaoTac(
      title: "Thêm ${ModuleMy.getNameModuleMy(ModuleMy.CONG_VIEC)}",
      icon: ICONS.IC_ADD_WORD_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateFormAdd(
            "Thêm ${ModuleMy.getNameModuleMy(ModuleMy.CONG_VIEC)}",
            ADD_CLUE_JOB,
            id: int.parse(id), onRefresh: () {
          _bloc.controllerCV.reloadData();
        });
      },
    ));
    list.add(ModuleThaoTac(
        title: 'Thêm thảo luận',
        icon: ICONS.IC_ADD_DISCUSS_SVG,
        onThaoTac: () {
          Get.back();
          AppNavigator.navigateAddNoteScreen(Module.DAU_MOI, id, onRefresh: () {
            _blocNote.add(RefreshEvent());
          });
        }));
    list.add(ModuleThaoTac(
      title: 'Xem đính kèm',
      icon: ICONS.IC_ATTACK_SVG,
      onThaoTac: () {
        Get.back();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Attachment(
                  id: id,
                  typeModule: Module.DAU_MOI,
                )));
      },
    ));
    list.add(ModuleThaoTac(
        title: 'Sửa',
        icon: ICONS.IC_EDIT_SVG,
        onThaoTac: () {
          Get.back();
          AppNavigator.navigateEditDataScreen(id, EDIT_CLUE, onRefresh: () {
            _bloc.add(InitGetDetailClueEvent(id));
          });
        }));
    list.add(ModuleThaoTac(
        title: 'Xóa',
        icon: ICONS.IC_DELETE_SVG,
        onThaoTac: () {
          ShowDialogCustom.showDialogBase(
              onTap2: () => _bloc.add(InitDeleteClueEvent(id)),
              content: "Bạn chắc chắn muốn xóa không ?");
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<GetDetailClueBloc, DetailClueState>(
        listener: (context, state) async {
          if (state is SuccessDeleteClueState) {
            LoadingApi().popLoading();
            ShowDialogCustom.showDialogBase(
              title: MESSAGES.NOTIFICATION,
              content: "Thành công",
              onTap1: () {
                Get.back();
                Get.back();
                Get.back();
                Get.back();
                GetListClueBloc.of(context).add(InitGetListClueEvent());
              },
            );
          } else if (state is ErrorDeleteClueState) {
            LoadingApi().popLoading();
            ShowDialogCustom.showDialogBase(
              title: MESSAGES.NOTIFICATION,
              content: state.msg,
              textButton1: "Quay lại",
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
              title: name,
              left: _buildBack(),
            ),
            AppValue.vSpaceTiny,
            Expanded(
              child: DefaultTabController(
                  length: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          isScrollable: true,
                          indicatorColor: COLORS.TEXT_COLOR,
                          labelColor: COLORS.TEXT_COLOR,
                          unselectedLabelColor: COLORS.GREY,
                          labelStyle: AppStyle.DEFAULT_LABEL_TARBAR,
                          tabs: [
                            Tab(
                              text: 'Thông tin chung',
                            ),
                            Tab(
                              text: ModuleMy.getNameModuleMy(ModuleMy.CONG_VIEC,
                                  isTitle: true),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            GeneralInfo(
                              id: id,
                              blocNote: _blocNote,
                              bloc: _bloc,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: ListViewLoadMoreBase(
                                functionInit: (page, isInit) {
                                  return _bloc.getWorkClue(
                                    id: id,
                                    page: page,
                                    isInit: isInit,
                                  );
                                },
                                itemWidget: (int index, data) {
                                  return GestureDetector(
                                    onTap: () {
                                      AppNavigator.navigateDetailWork(
                                          int.parse(data.id ?? '0'),
                                          data.name_job ?? '');
                                    },
                                    child: WorkCardWidget(
                                      nameCustomer: data.name_customer,
                                      nameJob: data.name_job,
                                      startDate: data.start_date,
                                      statusJob: data.status_job,
                                      totalComment: data.total_comment,
                                      color: data.color,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ButtonThaoTac(
                onTap: () {
                  showThaoTac(context, list);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildBack() {
    return IconButton(
      onPressed: () {
        AppNavigator.navigateBack();
      },
      icon: Image.asset(
        ICONS.IC_BACK_PNG,
        height: 28,
        width: 28,
        color: COLORS.BLACK,
      ),
    );
  }
}
