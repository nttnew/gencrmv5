import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/detail_clue/detail_clue_bloc.dart';
import 'package:gen_crm/bloc/work_clue/work_clue_bloc.dart';
import 'package:gen_crm/screens/menu/home/clue/general_info.dart';
import 'package:gen_crm/screens/menu/home/clue/list_work_clue.dart';
import 'package:gen_crm/screens/menu/home/clue/work_card_widget.dart';
import 'package:gen_crm/src/models/model_generator/work_clue.dart';
import 'package:gen_crm/widgets/widget_button.dart';
import 'package:get/get.dart';

import '../../../../bloc/clue/clue_bloc.dart';
import '../../../../bloc/contract/detail_contract_bloc.dart';
import '../../../../src/models/model_generator/file_response.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_appbar.dart';
import '../../../../widgets/widget_dialog.dart';
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

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100), () {
      DetailContractBloc.of(context).getFile(int.parse(id), Module.DAU_MOI);
      GetDetailClueBloc.of(context).add(InitGetDetailClueEvent(id));
      WorkClueBloc.of(context).add(GetWorkClue(id: id));
    });
    super.initState();
  }

  void callApiUploadFile() {
    DetailContractBloc.of(context).getFile(int.parse(id), Module.DAU_MOI);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<GetDetailClueBloc, DetailClueState>(
        listener: (context, state) async {
          if (state is SuccessDeleteClueState) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return WidgetDialog(
                  title: MESSAGES.NOTIFICATION,
                  content: "Thành công",
                  textButton1: "OK",
                  backgroundButton1: COLORS.PRIMARY_COLOR,
                  onTap1: () {
                    Get.back();
                    Get.back();
                    Get.back();
                    Get.back();
                    GetListClueBloc.of(context)
                        .add(InitGetListClueEvent('', 1, ''));
                  },
                );
              },
            );
          } else if (state is ErrorDeleteClueState) {
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
            )
          ],
        ),
      ),
      bottomNavigationBar: WidgetButton(
        text: 'Thao Tác',
        onTap: () {
          showModalBottomSheet(
              // isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: AppValue.heights * 0.35,
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppValue.hSpaceLarge,
                          Image.asset('assets/icons/addWork.png'),
                          SizedBox(width: 10),
                          InkWell(
                              onTap: () {
                                AppNavigator.navigateFormAdd(
                                    'Thêm công việc', 21,
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
                          AppNavigator.navigateAddNoteScreen(2, id);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppValue.hSpaceLarge,
                            Image.asset('assets/icons/addContent.png'),
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
                                        typeModule: Module.DAU_MOI,
                                      )))
                              .whenComplete(() => callApiUploadFile());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppValue.hSpaceLarge,
                            SvgPicture.asset('assets/icons/attack.svg'),
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
                          AppNavigator.navigateEditDataScreen(id, 2);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppValue.hSpaceLarge,
                            Image.asset('assets/icons/edit.png'),
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
                              onTap2: () => GetDetailClueBloc.of(context)
                                  .add(InitDeleteClueEvent(id)),
                              content: "Bạn chắc chắn muốn xóa không ?");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppValue.hSpaceLarge,
                            Image.asset('assets/icons/remove.png'),
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
        ICONS.ICON_BACK,
        height: 28,
        width: 28,
        color: COLORS.BLACK,
      ),
    );
  }
}
