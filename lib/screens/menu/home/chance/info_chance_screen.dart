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
                  content: "Th??nh c??ng",
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
                  textButton1: "Quay l???i",
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
                            text: 'Th??ng tin chung',
                          ),
                          Tab(
                            text: 'C??ng vi???c',
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
                                                        (index1) => Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 5),
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
                                                                    title: state
                                                                            .data[index]
                                                                            .data![index1]
                                                                            .label_field ??
                                                                        '',
                                                                    style: AppStyle
                                                                        .DEFAULT_14
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.grey),
                                                                  )),
                                                              Expanded(
                                                                  flex: 2,
                                                                  child: WidgetText(
                                                                      title:
                                                                          state.data[index].data![index1].value_field ??
                                                                              '',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                      style: AppStyle
                                                                          .DEFAULT_14))
                                                            ],
                                                          ),
                                                        ),
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
                                  // Text('Th???o lu???n',style: AppStyle.DEFAULT_16.copyWith(fontWeight: FontWeight.w900),),
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
                                'Th??m h???p ?????ng',
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
                                    'Th??m c??ng vi???c', 31,
                                    id: int.parse(id));
                              },
                              child: Text(
                                'Th??m c??ng vi???c',
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
                              'Th??m th???o lu???n',
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
                              'S???a',
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
                              content: "B???n ch???c ch???n mu???n x??a kh??ng ?");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppValue.hSpaceLarge,
                            Image.asset('assets/icons/remove.png'),
                            SizedBox(width: 10),
                            Text(
                              'X??a',
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
                                Text('????ng', style: AppStyle.DEFAULT_16_BOLD),
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
                    'Kh??ch h??ng',
                    style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),
                  ),
                  Text('C??ng ty H??? G????m Audio', style: AppStyle.DEFAULT_14)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Doanh s???',
                    style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),
                  ),
                  Text('123.456.789vn??',
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
          'Kh??ng c?? d??? li???u',
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
            'Nh??m n???i dung 2',
            style: AppStyle.DEFAULT_16_BOLD,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '?????a ch???',
                style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),
              ),
              Text('298 C???u gi???y', style: AppStyle.DEFAULT_14)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '??i???n tho???i',
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
                    'Nguy???n Ho??ng Nam',
                    style: AppStyle.DEFAULT_14
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '20/03/2022 l??c 05:15 PM',
                    style:
                        AppStyle.DEFAULT_12.copyWith(color: Color(0xff838A91)),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Ch??? Th???o mu???n nh???n b??o gi?? c?? ??u ????i. N???u gi?? t???t s??? b???t ?????u tri???n khai ngay v??o ?????u th??ng t???i. Ch?? ??: g???i b??o gi?? c??? b???n c???ng v?? b???n m???m cho ch???.',
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
