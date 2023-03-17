import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/list_note/list_note_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/list_note.dart';
import 'package:gen_crm/widgets/widget_button.dart';
import 'package:gen_crm/widgets/widget_input.dart';
import 'package:gen_crm/widgets/widget_line.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../../../../bloc/blocs.dart';
import '../../../../src/models/model_generator/job_chance.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_appbar.dart';
import '../../../../widgets/widget_dialog.dart';
import '../../../../widgets/widget_text.dart';
import 'job_chance_item.dart';

class InfoChancePage extends StatefulWidget {
  const InfoChancePage({Key? key}) : super(key: key);

  @override
  State<InfoChancePage> createState() => _InfoChancePageState();
}

class _InfoChancePageState extends State<InfoChancePage> {
  // late ListChanceData listChanceData;
  // late DataDetailChance dataDetailChance;
  List<DataDetailChance> dataChance = [];
  String id = Get.arguments[0];
  String name = Get.arguments[1];

  @override
  void initState() {
    GetListDetailChanceBloc.of(context)
        .add(InitGetListDetailEvent(int.parse(id)));
    ListNoteBloc.of(context).add(InitNoteOppEvent(id, "1"));
    GetJobChanceBloc.of(context).add(InitGetJobEventChance(int.parse(id)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = GetListDetailChanceBloc.of(context);
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
                  textButton1: "OK",
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
                    child: Scaffold(
                      appBar: const TabBar(
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
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WidgetLine(
                                    color: Colors.grey,
                                  ),
                                  BlocBuilder<GetListDetailChanceBloc,
                                          DetailChanceState>(
                                      builder: (context, state) {
                                    if (state
                                        is UpdateGetListDetailChanceState) {
                                      return ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            if (state.data[index].data != null)
                                              return Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AppValue.vSpaceTiny,
                                                    WidgetText(
                                                      title: state.data[index]
                                                              .group_name ??
                                                          "",
                                                      style: AppStyle
                                                          .DEFAULT_16_BOLD,
                                                    ),
                                                    AppValue.vSpaceTiny,
                                                    Column(
                                                      children: List.generate(
                                                        state.data[index].data!
                                                            .length,
                                                        (index1) => state
                                                                    .data[index]
                                                                    .data![
                                                                        index1]
                                                                    .value_field !=
                                                                ''
                                                            ? Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            5),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            WidgetText(
                                                                          title:
                                                                              state.data[index].data![index1].label_field ?? '',
                                                                          style: AppStyle
                                                                              .DEFAULT_14
                                                                              .copyWith(color: Colors.grey),
                                                                        )),
                                                                    Expanded(
                                                                        flex: 2,
                                                                        child: WidgetText(
                                                                            title: state.data[index].data![index1].value_field ??
                                                                                '',
                                                                            textAlign:
                                                                                TextAlign.right,
                                                                            style: AppStyle.DEFAULT_14))
                                                                  ],
                                                                ),
                                                              )
                                                            : SizedBox(),
                                                      ),
                                                    ),
                                                    AppValue.vSpaceTiny,
                                                    AppValue.vSpaceTiny,
                                                    AppValue.vSpaceTiny,
                                                    WidgetLine(
                                                      color: Colors.grey,
                                                    )
                                                  ],
                                                ),
                                              );
                                            else
                                              return Container();
                                          },
                                          separatorBuilder: (context, index) {
                                            return SizedBox();
                                          },
                                          itemCount: state.data.length);
                                    } else
                                      return Container();
                                  }),
                                  // Text('Thảo luận',style: AppStyle.DEFAULT_16.copyWith(fontWeight: FontWeight.w900),),
                                  AppValue.vSpaceTiny,
                                  ListNote(type: 3, id: id)
                                ],
                              ),
                            ),
                          ),
                          JobListChance(
                            id: id,
                          )
                        ],
                      ),
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
                          Image.asset('assets/icons/hopdong.png'),
                          SizedBox(width: 10),
                          InkWell(
                              onTap: () {
                                Get.back();
                                AppNavigator.navigateAddContract(id: id);
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
                          Image.asset('assets/icons/addWork.png'),
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
                          AppNavigator.navigateEditDataScreen(id, 3);
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
                              onTap2: () => GetListDetailChanceBloc.of(context)
                                  .add(InitDeleteChanceEvent(id)),
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

  _buildContent1(GetListDetailChanceBloc bloc) {
    return BlocBuilder<GetListDetailChanceBloc, DetailChanceState>(
        builder: (context, state) {
      if (state is UpdateGetListDetailChanceState) {
        return Container(
          height: AppValue.heights * 0.22,
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WidgetLine(
                color: Colors.grey,
              ),
              // WidgetText(title: state.data[0].group_name ??'',style: AppStyle.DEFAULT_16_BOLD,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Khách hàng',
                    style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),
                  ),
                  Text('Công ty Hồ Gươm Audio', style: AppStyle.DEFAULT_14)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Doanh số',
                    style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),
                  ),
                  Text('123.456.789vnđ',
                      style: AppStyle.DEFAULT_14.copyWith(color: Colors.red))
                ],
              ),
              WidgetLine(
                color: Colors.grey,
              )
            ],
          ),
        );
      } else
        return Center(
            child: Text(
          'Không có dữ liệu',
          style: AppStyle.DEFAULT_16_BOLD,
        ));
    });
  }

  _buildContent2() {
    return Container(
      height: AppValue.heights * 0.18,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nhóm nội dung 2',
            style: AppStyle.DEFAULT_16_BOLD,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Địa chỉ',
                style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),
              ),
              Text('298 Cầu giấy', style: AppStyle.DEFAULT_14)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Điện thoại',
                style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),
              ),
              Text('0983 123 456', style: AppStyle.DEFAULT_14)
            ],
          ),
          WidgetLine(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  _discuss() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 2,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: AppValue.heights * 0.1),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/img-1.png'),
              ),
            ),
            AppValue.hSpaceTiny,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nguyễn Hoàng Nam',
                    style: AppStyle.DEFAULT_14
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '20/03/2022 lúc 05:15 PM',
                    style:
                        AppStyle.DEFAULT_12.copyWith(color: Color(0xff838A91)),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Chị Thảo muốn nhận báo giá có ưu đãi. Nếu giá tốt sẽ bắt đầu triển khai ngay vào đầu tháng tới. Chú ý: gửi báo giá cả bản cứng và bản mềm cho chị.',
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
