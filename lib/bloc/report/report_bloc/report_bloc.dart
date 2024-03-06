import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/report/report_bloc/report_event.dart';
import 'package:gen_crm/bloc/report/report_bloc/report_state.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import '../../../api_resfull/user_repository.dart';
import '../../../l10n/key_text.dart';
import '../../../src/app_const.dart';
import '../../../src/base.dart';
import '../../../src/models/model_generator/response_ntc_filter.dart';
import '../../../widgets/listview/list_load_infinity.dart';
import '../../../widgets/loading_api.dart';
import '../report_general/report_general_bloc.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final UserRepository userRepository;

  LoadMoreController controllerContact = LoadMoreController();
  LoadMoreController controllerGeneralSelect = LoadMoreController();
  LoadMoreController controllerGara = LoadMoreController();
  LoadMoreController controllerSoQuy = LoadMoreController();
  BehaviorSubject<String> selectReport = BehaviorSubject.seeded('');
  BehaviorSubject<List<DataNTCFilter>> filterSoQuyStream =
      BehaviorSubject.seeded([]);
  BehaviorSubject<String> textNtcFilter =
      BehaviorSubject.seeded(getT(KeyT.choose_time));
  DataNTCFilter? ntcFilter;
  KyTaiChinh? kyTaiChinh;
  String location = '';
  int? id;
  int? time;
  String? gt;
  int? cl;
  String? timeFrom;
  String? timeTo;


  init() {
    location = '';
    kyTaiChinh = null;
    ntcFilter = null;
    textNtcFilter.add(getT(KeyT.choose_time));
  }

  ReportBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetReportWorkState());

  @override
  Stream<ReportState> mapEventToState(ReportEvent event) async* {
    if (event is InitReportEvent) {
      getNTCFilter();
      time = event.time;
      yield* _getReportGeneral();
    }
  }

  Future<dynamic> getReportContact({
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    LoadingApi().pushLoading();
    dynamic resDynamic = '';
    try {
      final response = await userRepository.reportContact(
        id,
        time,
        location,
        page,
        gt,
      );
      if (isSuccess(response.code)) {
        resDynamic = response.data?.list ?? [];
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else {
        resDynamic = response.msg ?? '';
      }
    } catch (e) {
      resDynamic = getT(KeyT.an_error_occurred);
      LoadingApi().popLoading();
      return resDynamic;
    }
    LoadingApi().popLoading();
    return resDynamic;
  }

  Future<dynamic> getListReportCar({
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    LoadingApi().pushLoading();
    dynamic resDynamic = '';
    try {
      final response = await userRepository.getListBaoCao(
        time: '$time',
        timeFrom: timeFrom,
        timeTo: timeTo,
        diemBan: location,
        page: page.toString(),
        trangThai: selectReport.valueOrNull,
      );
      if (isSuccess(response.code)) {
        resDynamic = response.data?.lists ?? [];
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else {
        resDynamic = response.msg ?? '';
      }
    } catch (e) {
      resDynamic = getT(KeyT.an_error_occurred);
      LoadingApi().popLoading();
      return resDynamic;
    }
    LoadingApi().popLoading();
    return resDynamic;
  }

  Future<dynamic> getReportGeneralSelect({
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    LoadingApi().pushLoading();
    dynamic resDynamic = '';
    try {
      final response = await userRepository.reportProduct(
        time ?? 0,
        location,
        cl,
        timeFrom,
        timeTo,
      );
      if (isSuccess(response.code)) {
        resDynamic = response.data?.list ?? [];
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else
        resDynamic = response.msg ?? '';
    } catch (e) {
      resDynamic = getT(KeyT.an_error_occurred);
      LoadingApi().popLoading();
      return resDynamic;
    }
    LoadingApi().popLoading();
    return resDynamic;
  }

  Future<void> getNTCFilter() async {
    try {
      final response = await userRepository.getNTCFilter();
      if (isSuccess(response.code)) {
        ntcFilter = DataNTCFilter(nam: response.data?.namDf);
        kyTaiChinh =
            KyTaiChinh(name: response.data?.tenKyDf, id: response.data?.kyDf);
        textNtcFilter.add('${kyTaiChinh?.name ?? ''} ${ntcFilter?.nam}');
        filterSoQuyStream.add(response.data?.dataNTC ?? []);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> getBaoCaoSoQuy({
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    LoadingApi().pushLoading();
    dynamic resDynamic = '';
    try {
      final response = await userRepository.getBaoCaoSoQuy(
        ntcFilter?.nam ?? '',
        kyTaiChinh?.id ?? '',
        location,
        page.toString(),
      );
      if (isSuccess(response.code)) {
        resDynamic = response.data?.data ?? [];
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else
        resDynamic = response.msg ?? '';
    } catch (e) {
      resDynamic = getT(KeyT.an_error_occurred);
      LoadingApi().popLoading();
      return resDynamic;
    }
    LoadingApi().popLoading();
    return resDynamic;
  }

  Stream<ReportState> _getReportGeneral() async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getReportOption();
      if (isSuccess(response.code)) {
        yield SuccessReportWorkState(
          response.data!.thoi_gian!,
          response.data!.diem_ban!,
          time ?? response.data!.thoi_gian_mac_dinh!,
        );
        ReportGeneralBloc.of(Get.context!).add(
          SelectReportGeneralEvent(
            null,
            time ?? response.data!.thoi_gian_mac_dinh!,
          ),
        );
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        yield ErrorReportWorkState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorReportWorkState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  static ReportBloc of(BuildContext context) =>
      BlocProvider.of<ReportBloc>(context);
}
