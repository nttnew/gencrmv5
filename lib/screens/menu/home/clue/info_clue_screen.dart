import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/detail_clue/detail_clue_bloc.dart';
import 'package:gen_crm/bloc/work_clue/work_clue_bloc.dart';
import 'package:gen_crm/screens/menu/home/clue/general_info.dart';
import 'package:gen_crm/screens/menu/home/clue/list_work_clue.dart';
import 'package:gen_crm/screens/menu/home/clue/work_card_widget.dart';
import 'package:gen_crm/src/models/model_generator/work_clue.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:get/get.dart';
import '../../../../bloc/clue/clue_bloc.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../../../widgets/widget_appbar.dart';
import '../../../../widgets/widget_text.dart';
import '../../attachment/attachment.dart';

class InfoCluePage extends StatefulWidget {
  const InfoCluePage({Key? key}) : super(key: key);

  @override
  State<InfoCluePage> createState() => _InfoCluePageState();
}

class _InfoCluePageState extends State<InfoCluePage> {
  String id = Get.arguments[0];
  String name = Get.arguments[1];
  List<ModuleThaoTac> list = [];

  @override
  void initState() {
    getThaoTac();
    Future.delayed(Duration(milliseconds: 100), () {
      GetDetailClueBloc.of(context).add(InitGetDetailClueEvent(id));
      WorkClueBloc.of(context).add(GetWorkClue(id: id));
    });
    super.initState();
  }

  getThaoTac() {
    list.add(ModuleThaoTac(
      title: "Thêm công việc",
      icon: ICONS.IC_ADD_WORD_SVG,
      onThaoTac: () {
        AppNavigator.navigateFormAdd('Thêm công việc', 21, id: int.parse(id));
      },
    ));
    list.add(ModuleThaoTac(
        title: 'Thêm thảo luận',
        icon: ICONS.IC_ADD_DISCUSS_SVG,
        onThaoTac: () {
          Get.back();
          AppNavigator.navigateAddNoteScreen(2, id);
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
          AppNavigator.navigateEditDataScreen(id, 2);
        }));
    list.add(ModuleThaoTac(
        title: 'Xóa',
        icon: ICONS.IC_DELETE_SVG,
        onThaoTac: () {
          ShowDialogCustom.showDialogBase(
              onTap2: () =>
                  GetDetailClueBloc.of(context).add(InitDeleteClueEvent(id)),
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
                GetListClueBloc.of(context)
                    .add(InitGetListClueEvent('', 1, ''));
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: DefaultTabController(
                    length: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TabBar(
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
                                text: 'Công việc',
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              GeneralInfo(id: id),
                              ListWorkClue(id: id)
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
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

  BlocBuilder<WorkClueBloc, WorkClueState> buildListWorkClue(
      BuildContext context) {
    return BlocBuilder<WorkClueBloc, WorkClueState>(builder: (context, state) {
      if (state is UpdateWorkClue) {
        List<WorkClueData> listWorkClue = state.data!;
        return ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) => WorkCardWidget(
            nameCustomer: listWorkClue[index].name_customer,
            nameJob: listWorkClue[index].name_job,
            startDate: listWorkClue[index].start_date,
            statusJob: listWorkClue[index].status_job,
            totalComment: listWorkClue[index].total_comment,
            color: listWorkClue[index].color,
          ),
          itemCount: state.data!.length,
          separatorBuilder: (BuildContext context, int index) => SizedBox(
            height: AppValue.heights * 0.01,
          ),
        );
      } else {
        return Center(
          child: WidgetText(
            title: 'Không có dữ liệu',
            style: AppStyle.DEFAULT_18_BOLD,
          ),
        );
      }
    });
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
