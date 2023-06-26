import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../api_resfull/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../../src/app_const.dart';
import '../../../src/base.dart';
import '../../../src/models/model_generator/report_general.dart';
import '../../../widgets/loading_api.dart';

part 'report_general_event.dart';
part 'report_general_state.dart';

class ReportGeneralBloc extends Bloc<ReportGeneralEvent, ReportGeneralState> {
  final UserRepository userRepository;

  ReportGeneralBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitReportGeneralState());

  @override
  Stream<ReportGeneralState> mapEventToState(ReportGeneralEvent event) async* {
    if (event is SelectReportGeneralEvent) {
      yield* _getReportContact(event.time, event.location, event.page);
    }
  }

  Stream<ReportGeneralState> _getReportContact(
      int? time, String? location, int? page) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingReportGeneralState();
      final response = await userRepository.reportGeneral(
          time, location == '' ? null : location, page);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessReportGeneralState(response.data);
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else
        yield ErrorReportGeneralState(response.msg ?? '');
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorReportGeneralState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
    LoadingApi().popLoading();
  }

  static ReportGeneralBloc of(BuildContext context) =>
      BlocProvider.of<ReportGeneralBloc>(context);
}
