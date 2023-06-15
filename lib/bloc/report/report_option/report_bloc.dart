import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import '../../../api_resfull/user_repository.dart';
import '../../../src/app_const.dart';
import '../../../src/base.dart';
import '../../../src/messages.dart';
import '../../../widgets/loading_api.dart';
import '../report_general/report_general_bloc.dart';

part 'report_state.dart';
part 'report_event.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final UserRepository userRepository;
  BehaviorSubject<String> selectReport = BehaviorSubject.seeded('');

  ReportBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetReportWorkState());

  @override
  Stream<ReportState> mapEventToState(ReportEvent event) async* {
    if (event is InitReportEvent) {
      yield* _getReportGeneral();
    }
  }

  Stream<ReportState> _getReportGeneral() async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getReportOption();
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessReportWorkState(response.data!.thoi_gian!,
            response.data!.diem_ban!, response.data!.thoi_gian_mac_dinh!);
        ReportGeneralBloc.of(Get.context!).add(SelectReportGeneralEvent(
            1, null, response.data!.thoi_gian_mac_dinh!));
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else
        yield ErrorReportWorkState(response.msg ?? '');
    } catch (e) {
      yield ErrorReportWorkState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static ReportBloc of(BuildContext context) =>
      BlocProvider.of<ReportBloc>(context);
}
