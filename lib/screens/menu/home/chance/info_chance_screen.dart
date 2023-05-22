import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/list_note/list_note_bloc.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:get/get.dart';
import '../../../../bloc/blocs.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../../../widgets/widget_appbar.dart';
import '../../attachment/attachment.dart';
import 'chance_info.dart';
import 'job_chance_item.dart';

class InfoChancePage extends StatefulWidget {
  const InfoChancePage({Key? key}) : super(key: key);

  @override
  State<InfoChancePage> createState() => _InfoChancePageState();
}

class _InfoChancePageState extends State<InfoChancePage> {
  List<DataDetailChance> dataChance = [];
  String id = Get.arguments[0];
  String name = Get.arguments[1];
  List<ModuleThaoTac> list = [];

  @override
  void initState() {
    getThaoTac();
    GetListDetailChanceBloc.of(context)
        .add(InitGetListDetailEvent(int.parse(id)));
    ListNoteBloc.of(context).add(InitNoteOppEvent(id, "1"));
    GetJobChanceBloc.of(context).add(InitGetJobEventChance(int.parse(id)));
    super.initState();
  }

  getThaoTac() {
    list.add(ModuleThaoTac(
      title: "Thêm hợp đồng",
      icon: ICONS.IC_ADD_CONTRACT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateAddContract(id: id, title: 'hợp đồng');
      },
    ));

    list.add(ModuleThaoTac(
      title: "Thêm công việc",
      icon: ICONS.IC_ADD_WORD_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateFormAdd('Thêm công việc', 31, id: int.parse(id));
      },
    ));

    list.add(ModuleThaoTac(
      title: "Thêm thảo luận",
      icon: ICONS.IC_ADD_DISCUSS_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateAddNoteScreen(3, id);
      },
    ));

    list.add(ModuleThaoTac(
      title: "Xem đính kèm",
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
      title: "Sửa",
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateEditDataScreen(id, 3);
      },
    ));

    list.add(ModuleThaoTac(
      title: "Xoá",
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
            onTap2: () => GetListDetailChanceBloc.of(context)
                .add(InitDeleteChanceEvent(id)),
            content: "Bạn chắc chắn muốn xóa không ?");
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
              title: MESSAGES.NOTIFICATION,
              content: "Thành công",
              onTap1: () {
                Get.back();
                Get.back();
                Get.back();
                Get.back();
                GetListChanceBloc.of(context)
                    .add(InitGetListOrderEventChance('', 1, ''));
              },
            );
          } else if (state is ErrorDeleteChanceState) {
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
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: const TabBar(
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
                              ChanceInfo(
                                id: id,
                              ),
                              JobListChance(
                                id: id,
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ButtonThaoTac(onTap: () {
                showThaoTac(context, list);
              }),
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
