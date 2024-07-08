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
  String? money = shareLocal.getString(PreferencesKey.MONEY) ?? '';
  String? _labelTime;
  String? _labelLocation;
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
      'name': getT(KeyT.sales),
      'gt': 'doanh_so',
    }, // label is required and unique
    {
      'name': getT(KeyT.real_revenue),
      'gt': 'thuc_thu',
    },
    {
      'name': getT(KeyT.number_contract),
      'gt': 'so_hop_dong',
    },
  ];

  String checkDataDoanhSo(DataList? dataN, String gt) {
    final data = dataN ?? DataList('0', '0', '0');
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
        'name': getT(KeyT.turn_over),
        'index': 1,
      }, // label is required and unique
      {
        'name': getT(KeyT.sales_product),
        'index': 2,
      },
      {
        'name': getT(KeyT.employee_turnover),
        'index': 3,
      },
      {
        'name': nameReport.toString(),
        'index': 4,
      },
      {
        'name': getT(KeyT.treasury_book),
        'index': 5,
      },
    ];
    items = [getT(KeyT.all_company)];
    select = typeReport[0]['name'];
    GetNotificationBloc.of(context).add(CheckNotification(isLoading: false));
    _initApiTime();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.starDate)} -'
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.starDate)}';
        timeFrom = DateFormat('dd/MM/yyyy').format(args.value.starDate);
        timeTo = DateFormat('dd/MM/yyyy')
            .format(args.value.endDate ?? args.value.starDate);
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
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: COLORS.WHITE,
        key: _drawerKey,
        drawer: MainDrawer(
          moduleMy: ModuleMy.REPORT,
          drawerKey: _drawerKey,
          onReload: () {
            init();
          },
        ),
        appBar: AppbarBase(_drawerKey, getT(KeyT.report)),
        body: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
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
    double w = MediaQuery.of(context).size.width - 32;
    return Row(
      children: [
        DropdownButton2(
          value: select,
          icon: SizedBox.shrink(),
          underline: SizedBox.shrink(),
          onChanged: (String? value) {
            setState(() {
              select = value ?? '';
            });
          },
          dropdownWidth: w * 0.65,
          dropdownMaxHeight: 300,
          selectedItemBuilder: (c) => typeReport
              .map(
                (items) => itemSelectDrop(
                  items['name'] ?? '',
                  wC: 0.65,
                  sizeT: 16,
                ),
              )
              .toList(),
          items: typeReport
              .map((items) => DropdownMenuItem<String>(
                    onTap: () {
                      step = items['index'];
                      timeFrom = timeTo = null;
                      _range = '';
                      _bloc.selectReport.add('');
                      OptionBloc.of(context).add(
                        InitOptionEvent(
                          step,
                          kyDf: _bloc.kyTaiChinh?.id,
                          time: _bloc.time,
                          location: _bloc.location,
                        ),
                      );
                    },
                    value: items['name'],
                    child: Text(
                      items['name'],
                      style: AppStyle.DEFAULT_14_BOLD,
                    ),
                  ))
              .toList(),
        ),
        (step == 5)
            ? Container(width: w * 0.35, child: _pickDateStep5(w * 0.35))
            : BlocBuilder<ReportBloc, ReportState>(
                builder: (context, state) {
                  if (state is SuccessReportWorkState) {
                    if (state.dataTime.length > 0) _initTime(state);
                    return DropdownButton2<String?>(
                      value: _labelTime,
                      alignment: Alignment.centerRight,
                      icon: SizedBox.shrink(),
                      underline: SizedBox.shrink(),
                      dropdownWidth: w * 0.35,
                      dropdownMaxHeight: 300,
                      selectedItemBuilder: (c) => state.dataTime
                          .map(
                            (items) => itemSelectDrop(items[1],
                                wC: 0.35, alignment: Alignment.centerRight),
                          )
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _labelTime = value;
                        });
                      },
                      items: state.dataTime
                          .map(
                            (items) => DropdownMenuItem<String?>(
                              onTap: () {
                                _bloc.time = int.tryParse(items.first) ?? -1;
                                shareLocal.putString(PreferencesKey.TIME_REPORT,
                                    _bloc.time.toString());

                                _bloc.selectReport.add('');
                                if (_bloc.time == 6) {
                                  Get.dialog(_dateRangeSelect());
                                } else if (items.first != 6) if (step == 1) {
                                  ReportGeneralBloc.of(context).add(
                                    SelectReportGeneralEvent(
                                      _bloc.location,
                                      _bloc.time,
                                    ),
                                  );
                                } else if (step == 2) {
                                  ReportProductBloc.of(context).add(
                                    InitReportProductEvent(
                                      location: _bloc.location,
                                      time: _bloc.time,
                                    ),
                                  );
                                } else if (step == 3) {
                                  ReportEmployeeBloc.of(context).add(
                                    InitReportEmployeeEvent(
                                      diemBan: _bloc.location == ''
                                          ? null
                                          : int.parse(_bloc.location),
                                      time: _bloc.time,
                                    ),
                                  );
                                } else if (step == 4) {
                                  CarReportBloc.of(context).add(
                                    GetDashboardCar(
                                      time: _bloc.time,
                                      diemBan: _bloc.location,
                                    ),
                                  );
                                }
                              },
                              value: items[1],
                              child: FittedBox(
                                child: Text(
                                  items[1],
                                  style: AppStyle.DEFAULT_14,
                                ),
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

  _initApiTime() {
    final dataTimeLocal = shareLocal.getString(PreferencesKey.TIME_REPORT);
    _bloc.add(
      InitReportEvent(
        int.tryParse(dataTimeLocal ?? ''),
      ),
    );
  }

  _initTime(SuccessReportWorkState state) {
    if (_labelTime == null) {
      String? dataTimeLocal = shareLocal.getString(PreferencesKey.TIME_REPORT);
      _setTimeDefault(
        state,
        timeDF: dataTimeLocal == 'null' ? null : dataTimeLocal,
      );
    }
  }

  _setTimeDefault(
    SuccessReportWorkState state, {
    String? timeDF,
  }) {
    for (int i = 0; i < state.dataTime.length; i++) {
      if (state.dataTime[i].first ==
          (timeDF ?? state.thoi_gian_mac_dinh.toString())) {
        _labelTime = state.dataTime[i][1];
        _bloc.time = int.tryParse(state.dataTime[i].first);
        shareLocal.putString(PreferencesKey.TIME_REPORT, _bloc.time.toString());
        break;
      }
    }
    if (_labelTime == null && timeDF == '-1') {
      //'-1' là id_time== null
      _labelTime = state.dataTime.firstOrNull?[1] ?? '';
    }
  }

  _pickDateStep5(double w) {
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 4,
                          ),
                          child: Image.asset(
                            ICONS.IC_DROP_DOWN_PNG,
                            height: 10,
                            width: 10,
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: w - 14,
                          ),
                          child: FittedBox(
                            child: Text(
                              snapshot.data ?? '',
                              style: AppStyle.DEFAULT_14_BOLD,
                            ),
                          ),
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
    double w = MediaQuery.of(context).size.width - 32;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BlocBuilder<ReportBloc, ReportState>(builder: (context, state) {
          if (state is SuccessReportWorkState) {
            if (state.dataLocation.isNotEmpty) {
              if (_labelLocation == null) {
                _labelLocation = state.dataLocation.first[1];
                _bloc.location = state.dataLocation.first[0];
              }
              return DropdownButton2<String?>(
                  value: _labelLocation,
                  icon: SizedBox.shrink(),
                  underline: SizedBox.shrink(),
                  dropdownMaxHeight: 300,
                  dropdownWidth: w,
                  onChanged: (String? value) {
                    _labelLocation = value;
                    setState(() {});
                  },
                  selectedItemBuilder: (c) => state.dataLocation
                      .map((items) => itemSelectDrop(
                            items[1],
                          ))
                      .toList(),
                  items: state.dataLocation
                      .map(
                        (items) => DropdownMenuItem<String?>(
                          onTap: () {
                            _bloc.location = items.first;
                            _bloc.selectReport.add('');
                            if (step == 1) {
                              ReportGeneralBloc.of(context).add(
                                SelectReportGeneralEvent(
                                  _bloc.location,
                                  _bloc.time,
                                ),
                              );
                            } else if (step == 2) {
                              ReportProductBloc.of(context).add(
                                InitReportProductEvent(
                                  location: _bloc.location,
                                  time: _bloc.time,
                                ),
                              );
                            } else if (step == 3) {
                              ReportEmployeeBloc.of(context).add(
                                InitReportEmployeeEvent(
                                  time: _bloc.time,
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
                                  time: _bloc.time,
                                  diemBan: _bloc.location,
                                ),
                              );
                            } else if (step == 5) {
                              QuySoReportBloc.of(context).add(
                                GetDashboardQuySo(
                                  nam: _bloc.ntcFilter?.nam ?? '',
                                  kyTaiChinh: _bloc.kyTaiChinh?.id ?? '',
                                  location: _bloc.location,
                                ),
                              );
                            }
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
                      .toList());
            } else
              return SizedBox();
          } else {
            return SizedBox.shrink();
          }
        }),
        (_bloc.time == 6 && _range != '')
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
                  children: typeDoanhSo.map((e) {
                    bool isCheckShowSelect = int.tryParse(checkDataDoanhSo(
                          state.data?.list,
                          e['gt'],
                        ).replaceAll(money ?? '', '')) ==
                        0;
                    return Container(
                      padding: EdgeInsets.only(
                        bottom: 8,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (!isCheckShowSelect) {
                            _bloc.gt = e['gt'];
                            _bloc.selectReport.add(_bloc.gt ?? '');
                            _showBodyReportOne();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isCheckShowSelect
                                ? COLORS.LIGHT_GREY
                                : selectDoanhSoChung == e['gt']
                                    ? Color(0xffFDEEC8)
                                    : Color(0xffC8E5FD),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e['name'],
                                style: AppStyle.DEFAULT_18_BOLD.copyWith(
                                  color: COLORS.TEXT_BLUE_BOLD,
                                ),
                              ),
                              Text(
                                checkDataDoanhSo(
                                  state.data?.list,
                                  e['gt'],
                                ),
                                style: AppStyle.DEFAULT_16,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            });
      } else if (state is ErrorReportGeneralState) {
        return Text(
          state.msg,
          style: AppStyle.DEFAULT_16_T,
        );
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
                          bool isCheckShowSelect =
                              int.tryParse(state.list[index].doanh_so ?? '') ==
                                  0;
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (!isCheckShowSelect) {
                                    _bloc.cl = state.list[index].id;
                                    _bloc.timeFrom = timeFrom;
                                    _bloc.timeTo = timeTo;
                                    _bloc.selectReport.add('$index');
                                    _showBodyReportTwo();
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isCheckShowSelect
                                        ? COLORS.LIGHT_GREY
                                        : indexSelect == index
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
      } else if (state is ErrorReportProductState) {
        return Text(
          state.msg,
          style: AppStyle.DEFAULT_16_T,
        );
      } else
        return SizedBox.shrink();
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
                          final bool isCheckShowSelect =
                              (state.data[index].total_contract ?? 0) == 0;
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (!isCheckShowSelect) {
                                    _bloc.selectReport.add('$index');
                                    _bloc.id =
                                        int.parse(state.data[index].id ?? '0');
                                    _showBodyReportOne();
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isCheckShowSelect
                                        ? COLORS.LIGHT_GREY
                                        : indexSelect == index
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
                                      Expanded(
                                        child: Text(
                                          state.data[index].name ??
                                              getT(KeyT.not_yet),
                                          style:
                                              AppStyle.DEFAULT_16_BOLD.copyWith(
                                            color: COLORS.TEXT_BLUE_BOLD,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '${state.data[index].total_contract ?? '0'} ${getT(KeyT.contract)}',
                                        style: AppStyle.DEFAULT_14,
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
      } else if (state is ErrorReportEmployeeState) {
        return Text(
          state.msg,
          style: AppStyle.DEFAULT_16_T,
        );
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
                            time: _bloc.time,
                            timeFrom: timeFrom,
                            timeTo: timeTo,
                          ),
                        )
                      : step == 3
                          ? ReportEmployeeBloc.of(context).add(
                              InitReportEmployeeEvent(
                                time: _bloc.time,
                                timeFrom: timeFrom,
                                timeTo: timeTo,
                                diemBan: int.parse(_bloc.location),
                              ),
                            )
                          : CarReportBloc.of(context).add(
                              GetDashboardCar(
                                time: _bloc.time,
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
                              itemBuilder: (context, index) {
                                final isCheckShowSelect = (state
                                            .responseCarDashboard
                                            ?.status?[index]
                                            .total ??
                                        0) ==
                                    0;
                                return GestureDetector(
                                  onTap: () {
                                    if (!isCheckShowSelect) {
                                      String? id = state.responseCarDashboard
                                          ?.status?[index].id
                                          .toString();
                                      _bloc.selectReport.add(id ?? '');
                                      _bloc.timeTo = timeTo;
                                      _bloc.timeFrom = timeFrom;
                                      _showBodyReportFour();
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      bottom: 16,
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width - 32,
                                    padding: EdgeInsets.all(
                                      10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isCheckShowSelect
                                          ? COLORS.LIGHT_GREY
                                          : statusCar ==
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
                                          state.responseCarDashboard
                                                  ?.status?[index].name ??
                                              '',
                                        ),
                                        Text(
                                          (state.responseCarDashboard
                                                      ?.status?[index].total ??
                                                  0)
                                              .toString(),
                                          style:
                                              AppStyle.DEFAULT_18_BOLD.copyWith(
                                            color: COLORS.TEXT_BLUE_BOLD,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    );
                  })
              : noData();
        } else if (state is ErrorGetListCarReportState) {
          return Text(
            state.msg,
            style: AppStyle.DEFAULT_16_T,
          );
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
      } else if (state is ErrorGetListQuySoReportState) {
        return Text(
          state.msg,
          style: AppStyle.DEFAULT_16_T,
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
                  Text(AppValue.formatMoney(content),
                      style: AppStyle.DEFAULT_18_BOLD),
                ],
              ),
            );
}

Widget itemSelectDrop(
  String title, {
  double wC = 1,
  double? sizeT,
  AlignmentGeometry? alignment,
}) {
  double w = MediaQuery.of(Get.context!).size.width - 32;
  return Container(
    width: w * wC,
    alignment: alignment,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 4,
          ),
          child: Image.asset(
            ICONS.IC_DROP_DOWN_PNG,
            height: 10,
            width: 10,
          ),
        ),
        Container(
          constraints: BoxConstraints(
            maxWidth: w * wC - 14,
          ),
          child: Text(
            title,
            style: AppStyle.DEFAULT_14_BOLD.copyWith(fontSize: sizeT),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    ),
  );
}
