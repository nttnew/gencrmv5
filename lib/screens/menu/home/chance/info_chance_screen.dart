import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/list_note/list_note_bloc.dart';
import 'package:gen_crm/widgets/widget_button.dart';
import 'package:get/get.dart';

import '../../../../bloc/blocs.dart';
import '../../../../bloc/contract/detail_contract_bloc.dart';
import '../../../../src/models/model_generator/file_response.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_appbar.dart';
import '../../../../widgets/widget_dialog.dart';
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

  @override
  void initState() {
    DetailContractBloc.of(context).getFile(int.parse(id), Module.CO_HOI_BH);
    GetListDetailChanceBloc.of(context)
        .add(InitGetListDetailEvent(int.parse(id)));
    ListNoteBloc.of(context).add(InitNoteOppEvent(id, "1"));
    GetJobChanceBloc.of(context).add(InitGetJobEventChance(int.parse(id)));
    super.initState();
  }

  void callApiUploadFile() {
    DetailContractBloc.of(context).getFile(int.parse(id), Module.CO_HOI_BH);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<GetListDetailChanceBloc, DetailChanceState>(
        listener: (context, state) async {
          if (state is SuccessDeleteChanceState) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return WidgetDialog(
                  title: MESSAGES.NOTIFICATION,
                  content: "Thành công",
                  textButton1: MESSAGES.OKE,
                  backgroundButton1: COLORS.PRIMARY_COLOR,
                  onTap1: () {
                    Get.back();
                    Get.back();
                    Get.back();
                    Get.back();
                    GetListChanceBloc.of(context)
                        .add(InitGetListOrderEventChance('', 1, ''));
                  },
                );
              },
            );
          } else if (state is ErrorDeleteChanceState) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return WidgetDialog(
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
            )
          ],
        ),
      ),
      bottomNavigationBar: WidgetButton(
        text: MESSAGES.MOVEMENT,
        onTap: () {
          showModalBottomSheet(
              // isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: AppValue.heights * 0.45,
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppValue.hSpaceLarge,
                          Image.asset(ICONS.IC_HOP_DONG_PNG),
                          SizedBox(width: 10),
                          InkWell(
                              onTap: () {
                                Get.back();
                                AppNavigator.navigateAddContract(
                                    id: id, title: 'hợp đồng');
                              },
                              child: Text(
                                'Thêm hợp đồng',
                                style: AppStyle.DEFAULT_16_BOLD
                                    .copyWith(color: Color(0xff006CB1)),
                              ))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppValue.hSpaceLarge,
                          Image.asset(ICONS.IC_WORK_PNG),
                          SizedBox(width: 10),
                          InkWell(
                              onTap: () {
                                Get.back();
                                AppNavigator.navigateFormAdd(
                                    'Thêm công việc', 31,
                                    id: int.parse(id));
                              },
                              child: Text(
                                'Thêm công việc',
                                style: AppStyle.DEFAULT_16_BOLD
                                    .copyWith(color: Color(0xff006CB1)),
                              ))
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          AppNavigator.navigateAddNoteScreen(3, id);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppValue.hSpaceLarge,
                            Image.asset(ICONS.IC_CONTENT_PNG),
                            SizedBox(width: 10),
                            Text(
                              'Thêm thảo luận',
                              style: AppStyle.DEFAULT_16_BOLD
                                  .copyWith(color: Color(0xff006CB1)),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final List<FileDataResponse> list = [];
                          for (final a in DetailContractBloc.of(context)
                              .listFileResponse) {
                            list.add(a);
                          }
                          Get.back();
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => Attachment(
                                        id: id,
                                        name: name,
                                        listFileResponse: list,
                                        typeModule: Module.CO_HOI_BH,
                                      )))
                              .whenComplete(() => callApiUploadFile());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppValue.hSpaceLarge,
                            SvgPicture.asset(ICONS.IC_ATTACK_SVG),
                            SizedBox(width: 10),
                            Text(
                              'Xem đính kèm',
                              style: AppStyle.DEFAULT_16_BOLD
                                  .copyWith(color: Color(0xff006CB1)),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          AppNavigator.navigateEditDataScreen(id, 3);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppValue.hSpaceLarge,
                            Image.asset('ICONS.ICON_EDIT2'),
                            SizedBox(width: 10),
                            Text(
                              'Sửa',
                              style: AppStyle.DEFAULT_16_BOLD
                                  .copyWith(color: Color(0xff006CB1)),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ShowDialogCustom.showDialogTwoButton(
                              onTap2: () => GetListDetailChanceBloc.of(context)
                                  .add(InitDeleteChanceEvent(id)),
                              content: "Bạn chắc chắn muốn xóa không ?");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppValue.hSpaceLarge,
                            Image.asset(ICONS.IC_REMOVE_PNG),
                            SizedBox(width: 10),
                            Text(
                              'Xóa',
                              style: AppStyle.DEFAULT_16_BOLD
                                  .copyWith(color: Color(0xff006CB1)),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => AppNavigator.navigateBack(),
                        child: Container(
                          width: AppValue.widths,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: COLORS.PRIMARY_COLOR,
                          ),
                          child: Center(
                            child:
                                Text('Đóng', style: AppStyle.DEFAULT_16_BOLD),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });
        },
        textColor: Colors.black,
        backgroundColor: COLORS.PRIMARY_COLOR,
        height: 40,
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
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
