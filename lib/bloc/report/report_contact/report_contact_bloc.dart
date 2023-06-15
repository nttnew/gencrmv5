import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../api_resfull/user_repository.dart';
import '../../../src/app_const.dart';
import '../../../src/base.dart';
import '../../../src/messages.dart';
import '../../../src/models/model_generator/report_contact.dart';
import '../../../widgets/loading_api.dart';

part 'report_contact_event.dart';
part 'report_contact_state.dart';

class ReportContactBloc extends Bloc<ReportContactEvent, ReportContactState> {
  final UserRepository userRepository;

  ReportContactBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitReportContactState());

  @override
  Stream<ReportContactState> mapEventToState(ReportContactEvent event) async* {
    if (event is InitReportContactEvent) {
      yield* _getReportContact(
          event.id, event.time, event.location, event.page, event.gt);
    } else if (event is LoadingReportContactEvent) {
      yield LoadingReportContactState();
    }
  }

  List<DataListContact>? list;
  Stream<ReportContactState> _getReportContact(
      int? id, int? time, String? location, int? page, String? gt) async* {
    LoadingApi().pushLoading();
    try {
      if (page == 1) yield LoadingReportContactState();
      final response =
          await userRepository.reportContact(id, time, location, page, gt);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (page == 1) {
          list = response.data!.list!;
          yield SuccessReportContactState(
              response.data!.list!, response.data!.total ?? "");
        } else {
          list = [...list!, ...response.data!.list!];
          yield SuccessReportContactState(list!, response.data!.total ?? "");
        }
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else{
        yield ErrorReportContactState(response.msg ?? '');
      }
    } catch (e) {
      yield ErrorReportContactState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static ReportContactBloc of(BuildContext context) =>
      BlocProvider.of<ReportContactBloc>(context);
}
