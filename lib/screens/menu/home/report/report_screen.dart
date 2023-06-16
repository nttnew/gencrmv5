import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/report/report_contact/report_contact_bloc.dart';
import 'package:gen_crm/bloc/report/report_general/report_general_bloc.dart';
import 'package:gen_crm/bloc/report/report_option/option_bloc.dart';
import 'package:gen_crm/bloc/report/report_product/report_product_bloc.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/src/models/model_generator/response_bao_cao.dart';
import 'package:gen_crm/storages/share_local.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../bloc/car_list_report/car_list_report_bloc.dart';
import '../../../../bloc/car_report/car_report_bloc.dart';
import '../../../../bloc/report/report_employee/report_employee_bloc.dart';
import '../../../../bloc/report/report_option/report_bloc.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/report_general.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/image_default.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  String? money = Get.arguments;
  String total = "0";
  int length = 0;
  int page = 1;
  int? _id;
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController1 = ScrollController();
  ScrollController _scrollCarController = ScrollController();
  late int timeInit;
  late int timeFilter;
  bool isFirst = false;
  String? gt;
  String valueTime = "Lựa chọn";
  String? valueLocation;
  int step = 1;
  String location = "";
  String _range = '';
  String? timeFrom;
  String? timeTo;
  late final List<Map<String, dynamic>> typeReport;
  late final List<String> items;
  late String select;

  List<Map<String, dynamic>> typeDoanhSo = [
    {"name": 'Doanh số', "gt": 'doanh_so'}, // label is required and unique
    {"name": 'Thực thu', "gt": 'thuc_thu'},
    {"name": 'Số hợp đồng', "gt": 'so_hop_dong'},
  ];

  String checkDataDoanhSo(DataList data, String gt) {
    if (gt == 'doanh_so') {
      return '${data.doanh_so}${money}';
    } else if (gt == 'thuc_thu') {
      return '${data.thuc_thu}${money}';
    } else if (gt == 'so_hop_dong') {
      return '${data.so_hop_dong}';
    }
    return '';
  }

  @override
  void initState() {
    final nameReport = shareLocal.getString(PreferencesKey.NAME_REPORT);
    typeReport = [
      {"name": 'Doanh số chung', "index": 1}, // label is required and unique
      {"name": 'Doanh số sản phẩm', "index": 2},
      {"name": 'Doanh số nhân viên', "index": 3},
      {"name": nameReport.toString(), "index": 4},
    ];
    items = [
      'Toàn công ty',
    ];
    select = typeReport[0]['name'];
    timeInit = 0;
    timeFilter = 0;
    GetNotificationBloc.of(context).add(CheckNotification());
    ReportBloc.of(context).add(InitReportEvent());
    scroll();
    super.initState();
  }

  scroll() {
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          length < int.parse(total)) {
        ReportContactBloc.of(context).add(InitReportContactEvent(
            gt: gt, page: page + 1, location: location, time: timeFilter));
        page = page + 1;
      }
    });
    _scrollController1.addListener(() {
      if (_scrollController1.offset ==
          _scrollController1.position.maxScrollExtent) {
        ReportContactBloc.of(context).add(InitReportContactEvent(
            id: _id, page: page + 1, location: location, time: timeFilter));
        page = page + 1;
      }
    });
    _scrollCarController.addListener(() {
      if (_scrollCarController.offset ==
              _scrollCarController.position.maxScrollExtent &&
        CarListReportBloc.of(context).isTotal) {
        CarListReportBloc.of(context).page += 1;
        CarListReportBloc.of(context).add(GetListReportCar(
            time: timeFilter.toString(),
            timeFrom: timeFrom,
            timeTo: timeTo,
            diemBan: location,
            page: (CarListReportBloc.of(context).page).toString(),
            trangThai: ReportBloc.of(context).selectReport.value));
      }
    });
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
        timeFrom = DateFormat('dd/MM/yyyy').format(args.value.startDate);
        timeTo = DateFormat('dd/MM/yyyy')
            .format(args.value.endDate ?? args.value.startDate);
      }
    });
  }

  @override
  void didChangeDependencies() {
    ReportBloc.of(context).selectReport.add('');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: _drawerKey,
        drawer:
            MainDrawer(onPress: (v) => handleOnPressItemMenu(_drawerKey, v)),
        appBar: AppbarBase(_drawerKey, 'Báo cáo'),
        body: Padding(
          padding: EdgeInsets.only(
              left: 15, right: 15, top: AppValue.heights * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _filterRow1(),
              _filterRow2(),
              step == 1
                  ? _step1()
                  : step == 2
                      ? _step2()
                      : step == 3
                          ? _step3()
                          : _step4()
            ],
          ),
        ));
  }

  _filterRow1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton2(
          value: select,
          icon: const Icon(Icons.arrow_drop_down_outlined),
          dropdownWidth: Get.width / 2,
          underline: Container(),
          onChanged: (String? value) {
            setState(() {
              select = value!;
            });
          },
          items: typeReport
              .map((items) => DropdownMenuItem<String>(
                    onTap: () {
                      valueLocation = 'Tất cả';
                      location = '';
                      step = items['index'];
                      valueTime = 'Lựa chọn';
                      timeFrom = timeTo = null;
                      _range = "";
                      isFirst = false;
                      ReportBloc.of(context).selectReport.add('');
                      if (step == 1) {
                        ReportBloc.of(context).add(InitReportEvent());
                      } else if (step == 2) {
                        OptionBloc.of(context).add(InitOptionEvent(1));
                      } else if (step == 3) {
                        OptionBloc.of(context).add(InitOptionEvent(2));
                      } else if (step == 4) {
                        OptionBloc.of(context).add(InitOptionEvent(4));
                      }
                    },
                    value: items['name'],
                    child: Text(
                      items['name'],
                      style: AppStyle.DEFAULT_16_BOLD,
                    ),
                  ))
              .toList(),
        ),
        (step == 1)
            ? BlocBuilder<ReportBloc, ReportState>(
                builder: (context, state) {
                  if (state is SuccessReportWorkState) {
                    for (int i = 0; i < state.dataTime.length; i++) {
                      if (state.dataTime[i][0] ==
                              state.thoi_gian_mac_dinh.toString() &&
                          isFirst == false) {
                        valueTime = state.dataTime[i][1];
                        timeInit = state.thoi_gian_mac_dinh;
                        timeFilter = timeInit;
                        isFirst = true;
                        break;
                      }
                    }
                    return DropdownButton2(
                      alignment: Alignment.centerRight,
                      value: valueTime,
                      dropdownWidth: 150,
                      dropdownMaxHeight: 275,
                      itemHeight: 40,
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      underline: Container(),
                      onChanged: (String? value) {
                        setState(() {
                          valueTime = value!;
                        });
                      },
                      items: state.dataTime
                          .map((items) => DropdownMenuItem<String>(
                                onTap: () {
                                  if (items[0] == "") {
                                    timeFilter = 0;
                                  } else {
                                    timeFilter = int.parse(items[0]);
                                  }
                                  ReportBloc.of(context).selectReport.add('');
                                  ReportGeneralBloc.of(context).add(
                                      SelectReportGeneralEvent(
                                          page, location, timeFilter));
                                },
                                value: items[1],
                                child: Text(
                                  items[1],
                                  style: AppStyle.DEFAULT_14,
                                ),
                              ))
                          .toList(),
                    );
                  } else {
                    return Container();
                  }
                },
              )
            : BlocBuilder<OptionBloc, OptionState>(
                builder: (context, state) {
                  if (state is SuccessOptionState) {
                    for (int i = 0; i < state.dataTime.length; i++) {
                      if (state.dataTime[i][0] ==
                              state.thoi_gian_mac_dinh.toString() &&
                          isFirst == false) {
                        valueTime = state.dataTime[i][1];
                        timeInit = state.thoi_gian_mac_dinh;
                        timeFilter = timeInit;
                        isFirst = true;
                        break;
                      }
                    }
                    return DropdownButton2(
                      alignment: Alignment.centerRight,
                      value: valueTime,
                      dropdownWidth: 150,
                      dropdownMaxHeight: 275,
                      itemHeight: 40,
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      underline: Container(),
                      onChanged: (String? value) {
                        setState(() {
                          valueTime = value!;
                        });
                        if (timeFilter == 6) {
                          Get.dialog(_dateRangeSelect());
                        }
                      },
                      items: state.dataTime
                          .map((items) => DropdownMenuItem<String>(
                                onTap: () {
                                  if (items[0] == "") {
                                    timeFilter = 0;
                                  } else {
                                    timeFilter = int.parse(items[0]);
                                  }
                                  ReportBloc.of(context).selectReport.add('');
                                  if (step == 2 && timeFilter != 6) {
                                    ReportProductBloc.of(context).add(
                                        InitReportProductEvent(
                                            location: location,
                                            time: timeFilter));
                                  } else if (step == 3 && timeFilter != 6) {
                                    ReportEmployeeBloc.of(context).add(
                                        InitReportEmployeeEvent(
                                            diemBan: location == ''
                                                ? null
                                                : int.parse(location),
                                            time: timeFilter));
                                  } else if (step == 4) {
                                    CarReportBloc.of(context).add(
                                        GetDashboardCar(
                                            time: timeFilter.toString(),
                                            diemBan: location));
                                  }
                                },
                                value: items[1],
                                child: Text(
                                  items[1],
                                  style: AppStyle.DEFAULT_14,
                                ),
                              ))
                          .toList(),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
      ],
    );
  }

  _filterRow2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        (step == 1)
            ? BlocBuilder<ReportBloc, ReportState>(
                builder: (context, state) {
                  if (state is SuccessReportWorkState) {
                    if (state.dataLocation.isNotEmpty) {
                      return DropdownButton2(
                          value: valueLocation ?? state.dataLocation[0][1],
                          icon: const Icon(Icons.arrow_drop_down_outlined),
                          underline: Container(),
                          dropdownWidth: 150,
                          dropdownMaxHeight: 250,
                          onChanged: (String? value) {
                            valueLocation = value ?? '';
                            setState(() {});
                          },
                          items: state.dataLocation.isNotEmpty
                              ? state.dataLocation
                                  .map((items) => DropdownMenuItem<String>(
                                        onTap: () {
                                          location = items[0];
                                          ReportBloc.of(context)
                                              .selectReport
                                              .add('');
                                          ReportGeneralBloc.of(context).add(
                                              SelectReportGeneralEvent(
                                                  page, location, timeFilter));
                                        },
                                        value: items[1],
                                        child: Text(
                                          items[1],
                                          style: AppStyle.DEFAULT_16_BOLD,
                                        ),
                                      ))
                                  .toList()
                              : items
                                  .map((items) => DropdownMenuItem<String>(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: AppStyle.DEFAULT_16_BOLD,
                                        ),
                                      ))
                                  .toList());
                    } else
                      return SizedBox();
                  } else {
                    return Container();
                  }
                },
              )
            : BlocBuilder<OptionBloc, OptionState>(
                builder: (context, state) {
                  if (state is SuccessOptionState) {
                    if (state.dataLocation.isNotEmpty) {
                      return DropdownButton2(
                          value: valueLocation ?? state.dataLocation[0][1],
                          icon: const Icon(Icons.arrow_drop_down_outlined),
                          underline: Container(),
                          dropdownWidth: 150,
                          dropdownMaxHeight: 250,
                          onChanged: (String? value) {
                            valueLocation = value ?? '';
                            setState(() {});
                          },
                          items: state.dataLocation.isNotEmpty
                              ? state.dataLocation
                                  .map((items) => DropdownMenuItem<String>(
                                        onTap: () {
                                          location = items[0];
                                          ReportBloc.of(context)
                                              .selectReport
                                              .add('');
                                          if (step == 2) {
                                            ReportProductBloc.of(context).add(
                                                InitReportProductEvent(
                                                    location: location,
                                                    time: timeFilter));
                                          } else if (step == 3) {
                                            ReportEmployeeBloc.of(context).add(
                                                InitReportEmployeeEvent(
                                                    time: timeFilter,
                                                    diemBan: location == ''
                                                        ? null
                                                        : int.parse(location)));
                                          } else if (step == 4) {
                                            CarReportBloc.of(context)
                                                .add(GetDashboardCar(
                                              time: timeFilter.toString(),
                                              diemBan: location,
                                            ));
                                          }
                                        },
                                        value: items[1],
                                        child: Text(
                                          items[1],
                                          style: AppStyle.DEFAULT_16_BOLD,
                                        ),
                                      ))
                                  .toList()
                              : items
                                  .map((items) => DropdownMenuItem<String>(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: AppStyle.DEFAULT_16_BOLD,
                                        ),
                                      ))
                                  .toList());
                    } else
                      return SizedBox();
                  } else {
                    return Container();
                  }
                },
              ),
        (timeFilter == 6 && _range != '')
            ? Padding(padding: EdgeInsets.only(right: 10), child: Text(_range))
            : Container(),
      ],
    );
  }

  _step1() {
    return BlocBuilder<ReportGeneralBloc, ReportGeneralState>(
        builder: (context, state) {
      if (state is SuccessReportGeneralState) {
        return StreamBuilder<String>(
            stream: ReportBloc.of(context).selectReport,
            builder: (context, snapshot) {
              final selectDoanhSoChung = snapshot.data ?? '';
              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView(
                        children: typeDoanhSo
                            .map(
                              (e) => Container(
                                padding: EdgeInsets.only(bottom: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    gt = e['gt'];
                                    ReportBloc.of(context)
                                        .selectReport
                                        .add(gt ?? '');
                                    page = BASE_URL.PAGE_DEFAULT;
                                    ReportContactBloc.of(context)
                                        .add(InitReportContactEvent(
                                      page: page,
                                      location: location,
                                      time: timeFilter,
                                      gt: gt,
                                    ));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: selectDoanhSoChung == e['gt']
                                            ? Color(0xffFDEEC8)
                                            : Color(0xffC8E5FD),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(e['name'],
                                            style: AppStyle.DEFAULT_18_BOLD
                                                .copyWith(
                                                    color:
                                                        COLORS.TEXT_BLUE_BOLD)),
                                        Text(checkDataDoanhSo(
                                            state.data!.list!, e['gt']))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    if (selectDoanhSoChung != '') _bodyStep1()
                  ],
                ),
              );
            });
      } else {
        return Container();
      }
    });
  }

  _hideDetail(Function() onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Ẩn chi tiết',
              style:
                  AppStyle.DEFAULT_14.copyWith(color: COLORS.TEXT_BLUE_BOLD)),
          Icon(Icons.arrow_drop_down_sharp, color: COLORS.TEXT_BLUE_BOLD)
        ],
      ),
    );
  }

  _bodyStep1() {
    return BlocBuilder<ReportContactBloc, ReportContactState>(
      builder: (context, state) {
        if (state is SuccessReportContactState) {
          total = state.total;
          length = state.data.length;
          return length == 0
              ? SizedBox()
              : Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _hideDetail(() {
                        ReportBloc.of(context).selectReport.add('');
                        ReportContactBloc.of(context)
                            .add(LoadingReportContactEvent());
                      }),
                      Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              controller: _scrollController,
                              itemCount: state.data.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    AppNavigator.navigateInfoContract(
                                        state.data[index].id ?? '',
                                        state.data[index].name ?? '');
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 4, right: 4, bottom: 20, top: 10),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
                                    decoration: BoxDecoration(
                                      color: COLORS.WHITE,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          width: 1, color: Colors.white),
                                      boxShadow: [
                                        BoxShadow(
                                          color: COLORS.BLACK.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            ImageBaseDefault(
                                                icon: ICONS.IC_CONTRACT_3X_PNG),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                                width: AppValue.widths * 0.5,
                                                child: WidgetText(
                                                  title:
                                                      state.data[index].name ??
                                                          "",
                                                  style: AppStyle
                                                      .DEFAULT_TITLE_PRODUCT
                                                      .copyWith(
                                                          color: COLORS
                                                              .TEXT_COLOR),
                                                )),
                                            Spacer(),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: state.data[index]
                                                              .status_color !=
                                                          ""
                                                      ? HexColor(state
                                                          .data[index]
                                                          .status_color!)
                                                      : COLORS.RED,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          99)),
                                              width: AppValue.widths * 0.08,
                                              height: AppValue.heights * 0.02,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              ICONS.IC_USER2_SVG,
                                              color: Color(0xffE75D18),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: WidgetText(
                                                title: state.data[index]
                                                        .customer?.name ??
                                                    'Chưa có',
                                                style: AppStyle
                                                    .DEFAULT_LABEL_PRODUCT,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              ICONS.IC_DANG_XU_LY_SVG,
                                              color: state.data[index]
                                                          .status_color !=
                                                      ''
                                                  ? HexColor(state.data[index]
                                                      .status_color!)
                                                  : COLORS.RED,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            WidgetText(
                                                title: state.data[index].status,
                                                style: AppStyle
                                                    .DEFAULT_LABEL_PRODUCT
                                                    .copyWith(
                                                  color: state.data[index]
                                                              .status_color !=
                                                          ''
                                                      ? HexColor(state
                                                          .data[index]
                                                          .status_color!)
                                                      : COLORS.RED,
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              ICONS.IC_MAIL_SVG,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            WidgetText(
                                              title: 'Doanh số: ' +
                                                  state.data[index].price
                                                      .toString() +
                                                  (money ?? ''),
                                              style: AppStyle
                                                  .DEFAULT_LABEL_PRODUCT
                                                  .copyWith(color: COLORS.GREY),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        AppValue.hSpaceTiny,
                                      ],
                                    ),
                                  ),
                                );
                              })),
                    ],
                  ),
                );
        } else {
          return Container();
        }
      },
    );
  }

  _step2() {
    return BlocBuilder<ReportProductBloc, ReportProductState>(
        builder: (context, state) {
      if (state is SuccessReportProductState) {
        return StreamBuilder<String>(
            stream: ReportBloc.of(context).selectReport,
            builder: (context, snapshot) {
              final indexSelect = snapshot.data ?? '';
              return Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppValue.vSpaceTiny,
                  Expanded(
                    flex: 2,
                    child: state.list.length > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      ReportBloc.of(context)
                                          .selectReport
                                          .add('$index');
                                      ReportSelectProductBloc.of(context).add(
                                          SelectReportProductEvent(
                                              cl: state.list[index].id,
                                              location: location,
                                              time: timeFilter,
                                              timeFrom: timeFrom,
                                              timeTo: timeTo));
                                    },
                                    child: Container(
                                      // height: 45,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 11),
                                      decoration: BoxDecoration(
                                          color: indexSelect == index
                                              ? Colors.lime
                                              : Colors.blue.withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            state.list[index].name ?? "Chưa có",
                                            style: AppStyle.DEFAULT_16_BOLD
                                                .copyWith(
                                                    color:
                                                        COLORS.TEXT_BLUE_BOLD),
                                          ),
                                          Text(
                                              "${state.list[index].doanh_so ?? 'Chưa có'}$money")
                                        ],
                                      ),
                                    ),
                                  ),
                                  AppValue.vSpaceTiny,
                                ],
                              );
                            },
                            itemCount: state.list.length,
                          )
                        : noData(),
                  ),
                  if (indexSelect != '') _bodyStep2()
                ],
              ));
            });
      } else {
        return Container();
      }
    });
  }

  _bodyStep2() {
    return BlocBuilder<ReportSelectProductBloc, ReportProductState>(
        builder: (context, state) {
      if (state is SuccessReportSelectState) {
        return state.listSelect.length == 0
            ? SizedBox()
            : Expanded(
                flex: 4,
                child: Column(
                  children: [
                    _hideDetail(() {
                      ReportBloc.of(context).selectReport.add('');
                    }),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: ListView.separated(
                        itemCount: state.listSelect.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 4),
                                        child: Text(
                                            state.listSelect[index].name ??
                                                "Chưa xác định",
                                            style: AppStyle.DEFAULT_18))),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${state.listSelect[index].doanh_so ?? 'Chưa xác định'}$money",
                                  style: AppStyle.DEFAULT_16,
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Container(height: 10);
                        },
                      ),
                    )),
                  ],
                ),
              );
      } else {
        return Container();
      }
    });
  }

  _step3() {
    return BlocBuilder<ReportEmployeeBloc, ReportEmployeeState>(
        builder: (context, state) {
      if (state is SuccessReportEmployeeState) {
        return StreamBuilder<String>(
            stream: ReportBloc.of(context).selectReport,
            builder: (context, snapshot) {
              final indexSelect = snapshot.data ?? '';
              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppValue.vSpaceSmall,
                    Expanded(
                      flex: 2,
                      child: state.data.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        ReportBloc.of(context)
                                            .selectReport
                                            .add('$index');
                                        _id = int.parse(state.data[index].id!);
                                        page = BASE_URL.PAGE_DEFAULT;
                                        ReportContactBloc.of(context).add(
                                            InitReportContactEvent(
                                                id: _id,
                                                page: page,
                                                location: location,
                                                time: timeFilter));
                                      },
                                      child: Container(
                                        height: 45,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        decoration: BoxDecoration(
                                            color: indexSelect == index
                                                ? Colors.lime
                                                : Colors.blue.withOpacity(0.4),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              state.data[index].name ??
                                                  "Chưa có",
                                              style: AppStyle.DEFAULT_18_BOLD
                                                  .copyWith(
                                                      color: COLORS
                                                          .TEXT_BLUE_BOLD),
                                            ),
                                            Text(
                                                "${state.data[index].total_contract ?? "0"} hợp đồng")
                                          ],
                                        ),
                                      ),
                                    ),
                                    AppValue.vSpaceTiny,
                                    Row(
                                      children: [
                                        Spacer(),
                                        Text(
                                            "${state.data[index].total_sales ?? "0"}$money",
                                            style: AppStyle.DEFAULT_18_BOLD),
                                      ],
                                    ),
                                    AppValue.vSpaceSmall,
                                  ],
                                );
                              },
                              itemCount: state.data.length,
                            )
                          : noData(),
                    ),
                    if (indexSelect != '') _bodyStep3()
                  ],
                ),
              );
            });
      } else {
        return Container();
      }
    });
  }

  _bodyStep3() {
    return BlocBuilder<ReportContactBloc, ReportContactState>(
        builder: (context, state) {
      if (state is SuccessReportContactState) {
        return state.data.length == 0
            ? SizedBox()
            : Expanded(
                flex: 4,
                child: Column(
                  children: [
                    _hideDetail(() {
                      ReportBloc.of(context).selectReport.add('');
                    }),
                    Expanded(
                        child: ListView.builder(
                            controller: _scrollController1,
                            itemCount: state.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  AppNavigator.navigateInfoContract(
                                      state.data[index].id!,
                                      state.data[index].name!);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 4, right: 4, bottom: 20, top: 10),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: COLORS.WHITE,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        width: 1, color: Colors.white),
                                    boxShadow: [
                                      BoxShadow(
                                        color: COLORS.BLACK.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          ImageBaseDefault(
                                              icon: ICONS.IC_CONTRACT_3X_PNG),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                              width: AppValue.widths * 0.5,
                                              child: WidgetText(
                                                title: state.data[index].name ??
                                                    "Chưa có",
                                                style: AppStyle
                                                    .DEFAULT_TITLE_PRODUCT
                                                    .copyWith(
                                                        color:
                                                            COLORS.TEXT_COLOR),
                                              )),
                                          Spacer(),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: state.data[index]
                                                            .status_color !=
                                                        ""
                                                    ? HexColor(state.data[index]
                                                        .status_color!)
                                                    : COLORS.RED,
                                                borderRadius:
                                                    BorderRadius.circular(99)),
                                            width: AppValue.widths * 0.08,
                                            height: AppValue.heights * 0.02,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            ICONS.IC_USER2_SVG,
                                            color: Color(0xffE75D18),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: WidgetText(
                                              title: state.data[index].customer!
                                                      .name ??
                                                  "chưa có",
                                              style: AppStyle
                                                  .DEFAULT_LABEL_PRODUCT,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            ICONS.IC_DANG_XU_LY_SVG,
                                            color: state.data[index]
                                                        .status_color !=
                                                    ""
                                                ? HexColor(state
                                                    .data[index].status_color!)
                                                : COLORS.RED,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          WidgetText(
                                              title: state.data[index].status,
                                              style: AppStyle
                                                  .DEFAULT_LABEL_PRODUCT
                                                  .copyWith(
                                                color: state.data[index]
                                                            .status_color !=
                                                        ""
                                                    ? HexColor(state.data[index]
                                                        .status_color!)
                                                    : COLORS.RED,
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            ICONS.IC_MAIL_SVG,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          WidgetText(
                                            title: 'Doanh số: ' +
                                                state.data[index].price
                                                    .toString() +
                                                money!,
                                            style: AppStyle
                                                .DEFAULT_LABEL_PRODUCT
                                                .copyWith(color: COLORS.GREY),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      AppValue.hSpaceTiny,
                                    ],
                                  ),
                                ),
                              );
                            })),
                  ],
                ),
              );
      } else if (state is LoadingReportContactState) {
        return SizedBox();
      } else
        return SizedBox();
    });
  }

  _dateRangeSelect() {
    return Container(
      color: COLORS.WHITE,
      child: Column(
        children: [
          Expanded(
            child: SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: PickerDateRange(
                  DateTime.now().subtract(const Duration(days: 0)),
                  DateTime.now().add(const Duration(days: 1))),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: WidgetButton(
              height: 40,
              onTap: () {
                Get.back();
                setState(() {
                  step == 2
                      ? ReportProductBloc.of(context).add(
                          InitReportProductEvent(
                              location: location,
                              time: timeFilter,
                              timeFrom: timeFrom,
                              timeTo: timeTo))
                      : step == 3
                          ? ReportEmployeeBloc.of(context)
                              .add(InitReportEmployeeEvent(
                              time: timeFilter,
                              timeFrom: timeFrom,
                              timeTo: timeTo,
                              diemBan: int.parse(location),
                            ))
                          : CarReportBloc.of(context).add(GetDashboardCar(
                              time: timeFilter.toString(),
                              timeFrom: timeFrom,
                              timeTo: timeTo,
                              diemBan: location,
                            ));
                });
              },
              text: "Done",
              backgroundColor: COLORS.BLUE,
            ),
          )
        ],
      ),
    );
  }

  _step4() {
    return Expanded(
      child:
          BlocBuilder<CarReportBloc, CarReportState>(builder: (context, state) {
        if (state is SuccessCarReportState) {
          return state.responseCarDashboard != null
              ? StreamBuilder<String>(
                  stream: ReportBloc.of(context).selectReport,
                  builder: (context, snapshot) {
                    final statusCar = snapshot.data ?? '';
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                  child: Center(
                                    child: Image.asset(
                                      IMAGES.IMAGE_CAR_REPORT,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Center(
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      textScaleFactor: MediaQuery.of(context)
                                          .textScaleFactor,
                                      text: TextSpan(
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  '${state.responseCarDashboard?.total ?? '0'}',
                                              style: AppStyle.DEFAULT_18_BOLD
                                                  .copyWith(
                                                      color:
                                                          COLORS.TEXT_BLUE_BOLD,
                                                      fontSize: 36,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                          TextSpan(
                                              text: ' xe',
                                              style: AppStyle.DEFAULT_18
                                                  .copyWith(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.only(top: 16),
                                    itemCount: state
                                        .responseCarDashboard?.status?.length,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                          onTap: () {
                                            String? id = state
                                                .responseCarDashboard
                                                ?.status?[index]
                                                .id
                                                .toString();
                                            ReportBloc.of(context)
                                                .selectReport
                                                .add(id ?? '');
                                            CarListReportBloc.of(context).add(
                                                GetListReportCar(
                                                    time: timeFilter.toString(),
                                                    timeFrom: timeFrom,
                                                    timeTo: timeTo,
                                                    diemBan: location,
                                                    page: BASE_URL.PAGE_DEFAULT
                                                        .toString(),
                                                    trangThai:
                                                        ReportBloc.of(context)
                                                            .selectReport
                                                            .value));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              bottom: 16,
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                30,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                                color: statusCar ==
                                                        state
                                                            .responseCarDashboard
                                                            ?.status?[index]
                                                            .id
                                                            .toString()
                                                    ? Color(0xffFDEEC8)
                                                    : Color(0xffC8E5FD),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  state
                                                          .responseCarDashboard
                                                          ?.status?[index]
                                                          .name ??
                                                      '',
                                                ),
                                                Text(
                                                  (state
                                                              .responseCarDashboard
                                                              ?.status?[index]
                                                              .total ??
                                                          0)
                                                      .toString(),
                                                  style: AppStyle
                                                      .DEFAULT_18_BOLD
                                                      .copyWith(
                                                          color: COLORS
                                                              .TEXT_BLUE_BOLD),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                              ],
                            ),
                          ),
                        ),
                        if (statusCar != '') _bodyStep4()
                      ],
                    );
                  })
              : noData();
        } else {
          return Container();
        }
      }),
    );
  }

  _bodyStep4() {
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          _hideDetail(() {
            ReportBloc.of(context).selectReport.add('');
          }),
          BlocBuilder<CarListReportBloc, CarListReportState>(
              builder: (context, state) {
            if (state is SuccessGetCarListReportState) {
              return Expanded(
                child: ListView.builder(
                    controller: _scrollCarController,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: state.itemResponseReportCars.length,
                    itemBuilder: (context, index) =>
                        _buildCustomer(state.itemResponseReportCars[index])),
              );
            }
            return SizedBox();
          }),
        ],
      ),
    );
  }

  _buildCustomer(ItemResponseReportCar data) {
    return GestureDetector(
      onTap: () {
        AppNavigator.navigateInfoContract(data.id!, data.name!);
      },
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: COLORS.WHITE,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: COLORS.BLACK.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ImageBaseDefault(
                  icon: ICONS.IC_CONTRACT_3X_PNG,
                  width: 36,
                  height: 36,
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                    width: AppValue.widths * 0.5,
                    child: WidgetText(
                      title: data.name ?? '',
                      style: AppStyle.DEFAULT_TITLE_PRODUCT
                          .copyWith(color: COLORS.TEXT_COLOR),
                    )),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color:
                          data.color != "" ? HexColor(data.color!) : COLORS.RED,
                      borderRadius: BorderRadius.circular(99)),
                  width: AppValue.widths * 0.08,
                  height: AppValue.heights * 0.02,
                )
              ],
            ),
            itemTextIcon(
              text: data.customer?.name?.trim() ?? '',
              icon: ICONS.IC_USER2_SVG,
              colorIcon: HexColor('E75D18'),
            ),
            itemTextIcon(
              isSVG: false,
              text: data.bienSo?.trim() ?? '',
              icon: ICONS.IC_LICENSE_PLATE_PNG,
            ),
            itemTextIcon(
              text: data.status?.trim() ?? '',
              icon: ICONS.IC_DANG_XU_LY_SVG,
              colorIcon: data.color != "" ? HexColor(data.color!) : COLORS.RED,
              colorText: data.color != "" ? HexColor(data.color!) : COLORS.RED,
            ),
            itemTextIcon(
                text: 'Tổng tiền: ' + '${data.giaTriHopDong ?? 0}' + 'đ',
                icon: ICONS.IC_MAIL_SVG,
                colorIcon: Colors.grey,
                colorText: Colors.grey),
            SizedBox(
              height: 8,
            ),
            AppValue.hSpaceTiny,
          ],
        ),
      ),
    );
  }
}
