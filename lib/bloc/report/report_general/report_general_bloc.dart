import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../api_resfull/user_repository.dart';
import '../../../l10n/key_text.dart';
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
      yield* _getReportContact(
        event.time,
        event.location,
      );
    }
  }

  Stream<ReportGeneralState> _getReportContact(
    int? time,
    String? location, {
    int? page = BASE_URL.PAGE_DEFAULT,
  }) async* {
    Loading().showLoading();
    try {
      yield LoadingReportGeneralState();
      final response = await userRepository.reportGeneral(
        time,
        location,
        page,
      );
      if (isSuccess(response.code)) {
        yield SuccessReportGeneralState(response.data);
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else
        yield ErrorReportGeneralState(response.msg ?? '');
    } catch (e) {
      Loading().popLoading();
      yield ErrorReportGeneralState(getT(KeyT.an_error_occurred));
      throw e;
    }
    Loading().popLoading();
  }

  static ReportGeneralBloc of(BuildContext context) =>
      BlocProvider.of<ReportGeneralBloc>(context);
}
