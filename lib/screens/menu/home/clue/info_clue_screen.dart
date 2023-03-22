import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/detail_clue/detail_clue_bloc.dart';
import 'package:gen_crm/bloc/note_clue/note_clue_bloc.dart';
import 'package:gen_crm/bloc/work_clue/work_clue_bloc.dart';
import 'package:gen_crm/screens/menu/home/clue/list_work_clue.dart';
import 'package:gen_crm/screens/menu/home/clue/work_card_widget.dart';
import 'package:gen_crm/screens/menu/home/customer/list_note.dart';
import 'package:gen_crm/src/models/model_generator/clue_detail.dart';
import 'package:gen_crm/src/models/model_generator/note_clue.dart';
import 'package:gen_crm/src/models/model_generator/work_clue.dart';
import 'package:gen_crm/widgets/widget_button.dart';
import 'package:gen_crm/widgets/widget_input.dart';
import 'package:gen_crm/widgets/widget_line.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../../../../bloc/clue/clue_bloc.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_appbar.dart';
import '../../../../widgets/widget_dialog.dart';
import '../../../../widgets/widget_text.dart';

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
    // TODO: implement initState
    Future.delayed(Duration(milliseconds: 100), () {
      GetDetailClueBloc.of(context).add(InitGetDetailClueEvent(id));
      WorkClueBloc.of(context).add(GetWorkClue(id: id));
    });

    // GetNoteClueBloc.of(context).add(InitGetNoteClueEvent(id));

    super.initState();
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
                    child: Scaffold(
                      appBar: TabBar(
                        isScrollable: true,
                        // automaticIndicatorColorAdjustment: true,
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
                      body: TabBarView(
                        children: [
                          buildGeneralInfor(),
                          // buildListWorkClue(context),
                          ListWorkClue(id: id)
                        ],
                      ),
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

  Container buildGeneralInfor() {
    return Container(
        padding: EdgeInsets.only(bottom: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<GetDetailClueBloc, DetailClueState>(
                  builder: (context, state) {
                if (state is UpdateGetDetailClueState) {
                  return Column(
                    children: List.generate(state.list.length,
                        (index) => _buildContent(state.list[index])),
                  );
                  //   ListView.separated(
                  //   shrinkWrap: true,
                  //   scrollDirection: Axis.vertical,
                  //   itemCount: state.list.length,
                  //   itemBuilder: (context, index) {
                  //     return _buildContent(state.list[index]);
                  //   },
                  //   separatorBuilder:
                  //       (BuildContext context, int index) =>
                  //   const SizedBox(),
                  // );
                } else {
                  return Center(
                    child: WidgetText(
                      title: 'Không có dữ liệu',
                      style: AppStyle.DEFAULT_18_BOLD,
                    ),
                  );
                }
              }),
              // Text(
              //   'Thảo luận',
              //   style: AppStyle.DEFAULT_16
              //       .copyWith(fontWeight: FontWeight.w900),
              // ),
              AppValue.vSpaceTiny,
              ListNote(type: 2, id: id)
            ],
          ),
        ));
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

  _buildContent(DetailClueGroupName detailClue) {
    if (detailClue.group_name == null &&
        detailClue.mup == null &&
        detailClue.data == null) {
      return Container();
    } else {
      return Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetLine(
              color: Colors.grey,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              detailClue.group_name!,
              style: AppStyle.DEFAULT_16_BOLD,
            ),
            SizedBox(
              height: 16,
            ),
            // ListView.separated(
            //   scrollDirection: Axis.vertical,
            //   shrinkWrap: true,
            //   itemCount: detailClue.data!.length,
            //   itemBuilder: (context, index) {
            //     return Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           detailClue.data![index].label_field!,
            //           style: AppStyle.DEFAULT_12.copyWith(fontWeight: FontWeight.w600,color: COLORS.TEXT_GREY),
            //         ),
            //         Text(detailClue.data![index].value_field!,
            //             style: AppStyle.DEFAULT_12_BOLD.copyWith(color:COLORS.TEXT_GREY_BOLD))
            //       ],
            //     );
            //   },
            //   separatorBuilder: (BuildContext context, int index) =>
            //   const SizedBox(
            //     height: 8,
            //   ),
            // ),
            Column(
              children: List.generate(
                  detailClue.data!.length,
                  (index) => detailClue.data![index].value_field != ''
                      ? Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              detailClue.data![index].label_field!,
                              style: AppStyle.DEFAULT_12.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: COLORS.TEXT_GREY),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                  detailClue.data![index].value_field ?? "",
                                  textAlign: TextAlign.right,
                                  style: AppStyle.DEFAULT_12_BOLD
                                      .copyWith(color: COLORS.TEXT_GREY_BOLD)),
                            ),
                          ],
                        ),
                      ): SizedBox()),
            ),
            const SizedBox(
              height: 8,
            ),
            WidgetLine(
              color: Colors.grey,
            )
          ],
        ),
      );
    }
  }

  _discuss(List<NoteClueData> listNoteClue) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: listNoteClue.length,
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: AppValue.heights * 0),
                child: WidgetNetworkImage(
                  image: (listNoteClue[index].avatar == "" ||
                          listNoteClue[index].avatar == null)
                      ? 'https://via.placeholder.com/150'
                      : listNoteClue[index].avatar!,
                  borderRadius: 30,
                  width: 50,
                  height: 50,
                )),
            AppValue.hSpaceTiny,
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listNoteClue[index].uname!,
                    style: AppStyle.DEFAULT_14
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    listNoteClue[index].createdtime! +
                        " " +
                        listNoteClue[index].passedtime!,
                    style:
                        AppStyle.DEFAULT_12.copyWith(color: Color(0xff838A91)),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    listNoteClue[index].content!,
                    style: AppStyle.DEFAULT_14
                        .copyWith(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            )
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: 8,
      ),
    );
  }
}
