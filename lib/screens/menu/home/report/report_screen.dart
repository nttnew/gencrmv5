import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/report/report_general/report_general_bloc.dart';
import 'package:gen_crm/bloc/report/report_option/option_bloc.dart';
import 'package:gen_crm/bloc/report/report_product/report_product_bloc.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/screens/menu/home/report/widget/body_report_one.dart';
import 'package:gen_crm/screens/menu/home/report/widget/body_report_two.dart';
import 'package:gen_crm/screens/menu/home/report/widget/body_step_five.dart';
import 'package:gen_crm/screens/menu/home/report/widget/body_step_four.dart';
import 'package:gen_crm/screens/menu/home/report/widget/select_ky_tai_chinh.dart';
import 'package:gen_crm/storages/share_local.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../bloc/report/car_report/car_report_bloc.dart';
import '../../../../bloc/report/quy_so_report/quy_so_report_bloc.dart';
import '../../../../bloc/report/report_bloc/report_event.dart';
import '../../../../bloc/report/report_bloc/report_state.dart';
import '../../../../bloc/report/report_employee/report_employee_bloc.dart';
import '../../../../bloc/report/report_bloc/report_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/report_general.dart';
import '../../../../src/models/model_generator/response_bao_cao_so_quy.dart';
import '../../../../src/models/model_generator/response_ntc_filter.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
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
  String timeInitFinal = '';
  String locationInitFinal = '';
  int length = 0;
  int page = 1;
  late int timeInit;
  late int timeFilter;
  bool isFirst = false;
  String valueTime = '';
  String? valueLocation;
  int step = 1;
  String _range = '';
  String? timeFrom;
  String? timeTo;
  List<Map<String, dynamic>> typeReport = [];
  List<String> items = [];
  String select = '';
  late final ReportBloc _bloc;

  List<Map<String, dynamic>> typeDoanhSo = [
    {
      "name": getT(KeyT.sales),
      "gt": 'doanh_so'
    }, // label is required and unique
    {"name": getT(KeyT.real_revenue), "gt": 'thuc_thu'},
    {"name": getT(KeyT.number_contract), "gt": 'so_hop_dong'},
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
    init();
    super.initState();
  }

  init() {
    _bloc = ReportBloc.of(context);
    final nameReport = shareLocal.getString(PreferencesKey.NAME_REPORT);
    typeReport = [
      {
        "name": getT(KeyT.turn_over),
        "index": 1
      }, // label is required and unique
      {"name": getT(KeyT.sales_product), "index": 2},
      {"name": getT(KeyT.employee_turnover), "index": 3},
      {"name": nameReport.toString(), "index": 4},
      {"name": getT(KeyT.treasury_book), "index": 5},
    ];
    items = [getT(KeyT.all_company)];
    select = typeReport[0]['name'];
    timeInit = 0;
    timeFilter = 0;
    GetNotificationBloc.of(context).add(CheckNotification());
    _bloc.init();
    _bloc.add(InitReportEvent());
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
    _bloc.selectReport.add('');
    super.didChangeDependencies();
  }

  _showBodyReportOne() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      builder: (context) => BodyReportOne(
        money: money ?? '',
        bloc: _bloc,
      ),
    );
  }

  _showBodyReportFive() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      builder: (context) => BodyReportFive(
        money: money ?? '',
        bloc: _bloc,
      ),
    );
  }

  _showBodyReportFour() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      builder: (context) => BodyReportFour(
        money: money ?? '',
        bloc: _bloc,
      ),
    );
  }

  _showBodyReportTwo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      builder: (context) => BodyReportTwo(
        money: money ?? '',
        bloc: _bloc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: COLORS.WHITE,
        key: _drawerKey,
        drawer: MainDrawer(
          onPress: (v) => handleOnPressItemMenu(_drawerKey, v),
          onReload: () {
            init();
          },
        ),
        appBar: AppbarBase(_drawerKey, getT(KeyT.report)),
        body: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
          ),
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
                          : step == 4
                              ? _step4()
                              : _step5(),
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
          underline: SizedBox.shrink(),
          onChanged: (String? value) {
            setState(() {
              select = value!;
            });
          },
          items: typeReport
              .map((items) => DropdownMenuItem<String>(
                    onTap: () {
                      valueLocation = locationInitFinal;
                      _bloc.location = '';
                      step = items['index'];
                      valueTime = timeInitFinal;
                      timeFrom = timeTo = null;
                      _range = "";
                      isFirst = false;
                      _bloc.selectReport.add('');
                      if (step == 1) {
                        _bloc.add(InitReportEvent());
                      } else if (step == 2) {
                        OptionBloc.of(context).add(InitOptionEvent(1));
                      } else if (step == 3) {
                        OptionBloc.of(context).add(InitOptionEvent(2));
                      } else if (step == 4) {
                        OptionBloc.of(context).add(InitOptionEvent(4));
                      } else if (step == 5) {
                        OptionBloc.of(context).add(InitOptionEvent(
                          5,
                          kyDf: _bloc.kyTaiChinh?.id,
                        ));
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
        (step == 5)
            ? _pickDateStep5()
            : (step == 1)
                ? BlocBuilder<ReportBloc, ReportState>(
                    builder: (context, state) {
                      if (state is SuccessReportWorkState) {
                        for (int i = 0; i < state.dataTime.length; i++) {
                          if (state.dataTime[i][0] ==
                                  state.thoi_gian_mac_dinh.toString() &&
                              isFirst == false) {
                            timeInitFinal = state.dataTime.first[1];
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
                          underline: SizedBox.shrink(),
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
                                      _bloc.selectReport.add('');
                                      ReportGeneralBloc.of(context).add(
                                        SelectReportGeneralEvent(
                                          page,
                                          _bloc.location,
                                          timeFilter,
                                        ),
                                      );
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
                        return SizedBox.shrink();
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
                            timeInitFinal = state.dataTime.first[1];
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
                          underline: SizedBox.shrink(),
                          onChanged: (String? value) {
                            setState(() {
                              valueTime = value!;
                            });
                            if (timeFilter == 6) {
                              Get.dialog(_dateRangeSelect());
                            }
                          },
                          items: state.dataTime
                              .map(
                                (items) => DropdownMenuItem<String>(
                                  onTap: () {
                                    if (items[0] == "") {
                                      timeFilter = 0;
                                    } else {
                                      timeFilter = int.parse(items[0]);
                                    }
                                    _bloc.selectReport.add('');
                                    if (step == 2 && timeFilter != 6) {
                                      ReportProductBloc.of(context).add(
                                          InitReportProductEvent(
                                              location: _bloc.location,
                                              time: timeFilter));
                                    } else if (step == 3 && timeFilter != 6) {
                                      ReportEmployeeBloc.of(context).add(
                                          InitReportEmployeeEvent(
                                              diemBan: _bloc.location == ''
                                                  ? null
                                                  : int.parse(_bloc.location),
                                              time: timeFilter));
                                    } else if (step == 4) {
                                      CarReportBloc.of(context).add(
                                        GetDashboardCar(
                                          time: timeFilter.toString(),
                                          diemBan: _bloc.location,
                                        ),
                                      );
                                    }
                                  },
                                  value: items[1],
                                  child: Text(
                                    items[1],
                                    style: AppStyle.DEFAULT_14,
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
      ],
    );
  }

  _pickDateStep5() {
    return StreamBuilder<List<DataNTCFilter>>(
        stream: _bloc.filterSoQuyStream,
        builder: (context, snapshot) {
          final soQuy = snapshot.data ?? [];
          if (soQuy.length > 0) {
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return SelectKyTaiChinh(
                        soQuy: soQuy,
                        kyTaiChinhSelect: _bloc.kyTaiChinh,
                        yearSelect: _bloc.ntcFilter,
                        onSelect:
                            (DataNTCFilter? ntcFilter, KyTaiChinh? kyTaiChinh) {
                          _bloc.kyTaiChinh = kyTaiChinh;
                          _bloc.ntcFilter = ntcFilter;
                          _bloc.textNtcFilter.add(
                              '${kyTaiChinh?.name ?? ''} ${ntcFilter?.nam}');
                          QuySoReportBloc.of(context).add(
                            GetDashboardQuySo(
                              nam: _bloc.ntcFilter?.nam ?? '',
                              kyTaiChinh: _bloc.kyTaiChinh?.id ?? '',
                              location: _bloc.location,
                            ),
                          );
                          Get.back();
                        },
                      );
                    });
              },
              child: StreamBuilder<String>(
                  stream: _bloc.textNtcFilter,
                  builder: (context, snapshot) {
                    return Row(
                      children: [
                        Text(
                          snapshot.data ?? '',
                          style: AppStyle.DEFAULT_14,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 4,
                          ),
                          child: Icon(Icons.arrow_drop_down_outlined),
                        ),
                      ],
                    );
                  }),
            );
          }
          return SizedBox();
        });
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
                      if (state.dataLocation.isNotEmpty) {
                        locationInitFinal = state.dataLocation.first[1];
                      }
                      return DropdownButton2(
                          value: valueLocation ?? state.dataLocation[0][1],
                          icon: const Icon(Icons.arrow_drop_down_outlined),
                          underline: SizedBox.shrink(),
                          dropdownMaxHeight: 250,
                          onChanged: (String? value) {
                            valueLocation = value ?? '';
                            setState(() {});
                          },
                          items: state.dataLocation.isNotEmpty
                              ? state.dataLocation
                                  .map(
                                    (items) => DropdownMenuItem<String>(
                                      onTap: () {
                                        _bloc.location = items[0];
                                        _bloc.selectReport.add('');
                                        ReportGeneralBloc.of(context).add(
                                          SelectReportGeneralEvent(
                                            page,
                                            _bloc.location,
                                            timeFilter,
                                          ),
                                        );
                                      },
                                      value: items[1],
                                      child: FittedBox(
                                        child: Text(
                                          items[1],
                                          style: AppStyle.DEFAULT_14_BOLD,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList()
                              : items
                                  .map(
                                    (items) => DropdownMenuItem<String>(
                                      value: items,
                                      child: Text(
                                        items,
                                        style: AppStyle.DEFAULT_16_BOLD,
                                      ),
                                    ),
                                  )
                                  .toList());
                    } else
                      return SizedBox();
                  } else {
                    return SizedBox.shrink();
                  }
                },
              )
            : BlocBuilder<OptionBloc, OptionState>(
                builder: (context, state) {
                  if (state is SuccessOptionState) {
                    if (state.dataLocation.isNotEmpty) {
                      if (state.dataLocation.isNotEmpty) {
                        locationInitFinal = state.dataLocation.first[1];
                      }
                      return DropdownButton2(
                        value: valueLocation ?? state.dataLocation[0][1],
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        underline: SizedBox.shrink(),
                        dropdownMaxHeight: 250,
                        onChanged: (String? value) {
                          valueLocation = value ?? '';
                          setState(() {});
                        },
                        items: state.dataLocation.isNotEmpty
                            ? state.dataLocation
                                .map((items) => DropdownMenuItem<String>(
                                      onTap: () {
                                        _bloc.location = items.first;
                                        _bloc.selectReport.add('');
                                        if (step == 2) {
                                          ReportProductBloc.of(context).add(
                                            InitReportProductEvent(
                                              location: _bloc.location,
                                              time: timeFilter,
                                            ),
                                          );
                                        } else if (step == 3) {
                                          ReportEmployeeBloc.of(context).add(
                                            InitReportEmployeeEvent(
                                              time: timeFilter,
                                              diemBan: _bloc.location == ''
                                                  ? null
                                                  : int.parse(
                                                      _bloc.location,
                                                    ),
                                            ),
                                          );
                                        } else if (step == 4) {
                                          CarReportBloc.of(context).add(
                                            GetDashboardCar(
                                              time: timeFilter.toString(),
                                              diemBan: _bloc.location,
                                            ),
                                          );
                                        } else if (step == 5) {
                                          QuySoReportBloc.of(context).add(
                                            GetDashboardQuySo(
                                              nam: _bloc.ntcFilter?.nam ?? '',
                                              kyTaiChinh:
                                                  _bloc.kyTaiChinh?.id ?? '',
                                              location: _bloc.location,
                                            ),
                                          );
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
                                .map(
                                  (items) => DropdownMenuItem<String>(
                                    value: items,
                                    child: Text(
                                      items,
                                      style: AppStyle.DEFAULT_16_BOLD,
                                    ),
                                  ),
                                )
                                .toList(),
                      );
                    } else
                      return SizedBox();
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
        (timeFilter == 6 && _range != '')
            ? Padding(padding: EdgeInsets.only(right: 10), child: Text(_range))
            : SizedBox.shrink(),
      ],
    );
  }

  _step1() {
    return BlocBuilder<ReportGeneralBloc, ReportGeneralState>(
        builder: (context, state) {
      if (state is SuccessReportGeneralState) {
        return StreamBuilder<String>(
            stream: _bloc.selectReport,
            builder: (context, snapshot) {
              final selectDoanhSoChung = snapshot.data ?? '';
              return Expanded(
                child: ListView(
                  padding: EdgeInsets.only(
                    top: 8,
                  ),
                  children: typeDoanhSo
                      .map(
                        (e) => Container(
                          padding: EdgeInsets.only(
                            bottom: 8,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _bloc.gt = e['gt'];
                              _bloc.selectReport.add(_bloc.gt ?? '');
                              _bloc.time = timeFilter;
                              _showBodyReportOne();
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: selectDoanhSoChung == e['gt']
                                    ? Color(0xffFDEEC8)
                                    : Color(0xffC8E5FD),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e['name'],
                                    style: AppStyle.DEFAULT_18_BOLD.copyWith(
                                      color: COLORS.TEXT_BLUE_BOLD,
                                    ),
                                  ),
                                  Text(
                                    checkDataDoanhSo(
                                      state.data!.list!,
                                      e['gt'],
                                    ),
                                    style: AppStyle.DEFAULT_16,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            });
      } else {
        return SizedBox.shrink();
      }
    });
  }

  _step2() {
    return BlocBuilder<ReportProductBloc, ReportProductState>(
        builder: (context, state) {
      if (state is SuccessReportProductState) {
        return StreamBuilder<String>(
            stream: _bloc.selectReport,
            builder: (context, snapshot) {
              final indexSelect = snapshot.data ?? '';
              return Expanded(
                child: state.list.length > 0
                    ? ListView.builder(
                        padding: EdgeInsets.only(
                          top: 8,
                        ),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _bloc.cl = state.list[index].id;
                                  _bloc.time = timeFilter;
                                  _bloc.timeFrom = timeFrom;
                                  _bloc.timeTo = timeTo;
                                  _bloc.selectReport.add('$index');
                                  _showBodyReportTwo();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: indexSelect == index
                                        ? Colors.lime
                                        : Colors.blue.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        state.list[index].name ??
                                            getT(KeyT.not_yet),
                                        style:
                                            AppStyle.DEFAULT_18_BOLD.copyWith(
                                          color: COLORS.TEXT_BLUE_BOLD,
                                        ),
                                      ),
                                      Text(
                                        '${state.list[index].doanh_so ?? getT(KeyT.not_yet)}$money',
                                        style: AppStyle.DEFAULT_16,
                                      ),
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
              );
            });
      } else {
        return SizedBox.shrink();
      }
    });
  }

  _step3() {
    return BlocBuilder<ReportEmployeeBloc, ReportEmployeeState>(
        builder: (context, state) {
      if (state is SuccessReportEmployeeState) {
        return StreamBuilder<String>(
            stream: _bloc.selectReport,
            builder: (context, snapshot) {
              final indexSelect = snapshot.data ?? '';
              return Expanded(
                child: state.data.length > 0
                    ? ListView.builder(
                        padding: EdgeInsets.only(
                          top: 8,
                        ),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _bloc.selectReport.add('$index');
                                  _bloc.id =
                                      int.parse(state.data[index].id ?? '0');
                                  page = BASE_URL.PAGE_DEFAULT;
                                  _bloc.time = timeFilter;
                                  _showBodyReportOne();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: indexSelect == index
                                        ? Colors.lime
                                        : Colors.blue.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        state.data[index].name ??
                                            getT(KeyT.not_yet),
                                        style:
                                            AppStyle.DEFAULT_18_BOLD.copyWith(
                                          color: COLORS.TEXT_BLUE_BOLD,
                                        ),
                                      ),
                                      Text(
                                        "${state.data[index].total_contract ?? "0"} ${getT(KeyT.contract)}",
                                        style: AppStyle.DEFAULT_16,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              AppValue.vSpaceTiny,
                              if (state.data[index].total_sales != '') ...[
                                Row(
                                  children: [
                                    Spacer(),
                                    Text(
                                      '${state.data[index].total_sales ?? '0'}$money',
                                      style: AppStyle.DEFAULT_16_BOLD,
                                    ),
                                  ],
                                ),
                                AppValue.vSpaceSmall,
                              ],
                            ],
                          );
                        },
                        itemCount: state.data.length,
                      )
                    : noData(),
              );
            });
      } else {
        return SizedBox.shrink();
      }
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
                            location: _bloc.location,
                            time: timeFilter,
                            timeFrom: timeFrom,
                            timeTo: timeTo,
                          ),
                        )
                      : step == 3
                          ? ReportEmployeeBloc.of(context).add(
                              InitReportEmployeeEvent(
                                time: timeFilter,
                                timeFrom: timeFrom,
                                timeTo: timeTo,
                                diemBan: int.parse(_bloc.location),
                              ),
                            )
                          : CarReportBloc.of(context).add(
                              GetDashboardCar(
                                time: timeFilter.toString(),
                                timeFrom: timeFrom,
                                timeTo: timeTo,
                                diemBan: _bloc.location,
                              ),
                            );
                });
              },
              text: getT(KeyT.done),
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
                  stream: _bloc.selectReport,
                  builder: (context, snapshot) {
                    final statusCar = snapshot.data ?? '';
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              bottom: 10,
                              top: 10,
                            ),
                            height: MediaQuery.of(context).size.height / 6,
                            child: Center(
                              child: Image.asset(
                                IMAGES.IMAGE_CAR_REPORT,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              textScaleFactor:
                                  MediaQuery.of(context).textScaleFactor,
                              text: TextSpan(
                                style: AppStyle.DEFAULT_18,
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        '${state.responseCarDashboard?.total ?? '0'}',
                                    style: AppStyle.DEFAULT_18_BOLD.copyWith(
                                      color: COLORS.TEXT_BLUE_BOLD,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ${getT(KeyT.car)}',
                                    style: AppStyle.DEFAULT_18.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(top: 16),
                            itemCount:
                                state.responseCarDashboard?.status?.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                String? id = state
                                    .responseCarDashboard?.status?[index].id
                                    .toString();
                                _bloc.selectReport.add(id ?? '');

                                _bloc.time = timeFilter;
                                _bloc.timeTo = timeTo;
                                _bloc.timeFrom = timeFrom;
                                _showBodyReportFour();
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  bottom: 16,
                                ),
                                width: MediaQuery.of(context).size.width - 32,
                                padding: EdgeInsets.all(
                                  10,
                                ),
                                decoration: BoxDecoration(
                                  color: statusCar ==
                                          state.responseCarDashboard
                                              ?.status?[index].id
                                              .toString()
                                      ? Color(0xffFDEEC8)
                                      : Color(0xffC8E5FD),
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      state.responseCarDashboard?.status?[index]
                                              .name ??
                                          '',
                                    ),
                                    Text(
                                      (state.responseCarDashboard
                                                  ?.status?[index].total ??
                                              0)
                                          .toString(),
                                      style: AppStyle.DEFAULT_18_BOLD.copyWith(
                                        color: COLORS.TEXT_BLUE_BOLD,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })
              : noData();
        } else {
          return SizedBox.shrink();
        }
      }),
    );
  }

  _step5() {
    return BlocBuilder<QuySoReportBloc, QuySoReportState>(
        builder: (context, state) {
      if (state is SuccessQuySoReportState) {
        final dataSoQuy = state.dataQuySo ?? DataBaoCaoSoQuy();
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                _showBodyReportFive();
              },
              child: Container(
                margin: EdgeInsets.only(
                  top: 8,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: COLORS.ffFCF1D4,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    AppValue.vSpaceTiny,
                    _rowText(getT(KeyT.first_period), dataSoQuy.dauKy ?? ''),
                    _rowText(getT(KeyT.total_revenue), dataSoQuy.tongThu ?? ''),
                    _rowText(
                        getT(KeyT.total_expenditure), dataSoQuy.tongChi ?? ''),
                    _rowText(
                        getT(KeyT.current_balance), dataSoQuy.tongDuCuoi ?? ''),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(
                top: 10,
                right: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  WidgetText(
                    title: getT(KeyT.click),
                    style: AppStyle.DEFAULT_14,
                  ),
                  AppValue.hSpaceTiny,
                  Image.asset(
                    ICONS.IC_CLICK_PNG,
                    color: COLORS.BLACK,
                    height: 24,
                    width: 24,
                  ),
                ],
              ),
            ),
          ],
        );
      }
      return SizedBox.shrink();
    });
  }

  Widget _rowText(
    String title,
    String content,
  ) =>
      content == ''
          ? SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: AppStyle.DEFAULT_16,
                  ),
                  Text(AppValue.format_money(content),
                      style: AppStyle.DEFAULT_18_BOLD),
                ],
              ),
            );
}
