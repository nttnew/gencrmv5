import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../api_resfull/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../../src/app_const.dart';
import '../../../src/base.dart';
import '../../../src/models/model_generator/report_contact.dart';
import '../../../src/models/model_generator/report_employee.dart';
import '../../../widgets/loading_api.dart';

part 'report_employee_event.dart';
part 'report_employee_state.dart';

class ReportEmployeeBloc
    extends Bloc<ReportEmployeeEvent, ReportEmployeeState> {
  final UserRepository userRepository;
  List<DataListContact>? list;

  ReportEmployeeBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitReportEmployeeState());

  @override
  Stream<ReportEmployeeState> mapEventToState(
      ReportEmployeeEvent event) async* {
    if (event is InitReportEmployeeEvent) {
      yield* _getReportContact(
          event.time, event.timeFrom, event.timeTo, event.diemBan);
    }
  }

  Stream<ReportEmployeeState> _getReportContact(
      int? time, String? timeFrom, String? timeTo, int? diemBan) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingReportEmployeeState();
      final response =
          await userRepository.reportEmployee(time!, diemBan, timeFrom, timeTo);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessReportEmployeeState(response.data?.list ?? []);
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        yield ErrorReportEmployeeState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorReportEmployeeState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
    LoadingApi().popLoading();
  }

  static ReportEmployeeBloc of(BuildContext context) =>
      BlocProvider.of<ReportEmployeeBloc>(context);
}
