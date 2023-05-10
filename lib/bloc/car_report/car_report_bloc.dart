import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/models/model_generator/response_car_dashboard.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/response_bao_cao.dart';

part 'car_report_event.dart';
part 'car_report_state.dart';

class CarReportBloc extends Bloc<CarReportEvent, CarReportState> {
  final UserRepository userRepository;
  final BehaviorSubject<String?> statusCar = BehaviorSubject();

  CarReportBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListCarReport());

  @override
  Stream<CarReportState> mapEventToState(CarReportEvent event) async* {
    if (event is GetDashboardCar) {
      yield* _getCarReport(
        timeTo: event.timeTo,
        timeFrom: event.timeFrom,
        time: event.time,
        diemBan: event.diemBan,
      );
    }
  }

  Stream<CarReportState> _getCarReport({
    String? time,
    String? timeFrom,
    String? timeTo,
    String? diemBan,
  }) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getHomeBaoCao(
        time: time,
        timeFrom: timeFrom,
        timeTo: timeTo,
        diemBan: diemBan == '' ? null : diemBan,
      );
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessCarReportState(response.data);
      } else if (response.code == 999) {
        loginSessionExpired();
      } else
        yield ErrorGetListCarReportState(response.msg ?? '');
    } catch (e) {
      yield ErrorGetListCarReportState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      loginSessionExpired();
      throw e;
    }
    LoadingApi().popLoading();
  }

  static CarReportBloc of(BuildContext context) =>
      BlocProvider.of<CarReportBloc>(context);
}