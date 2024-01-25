import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../api_resfull/user_repository.dart';
import '../../../l10n/key_text.dart';
import '../../../src/app_const.dart';
import '../../../src/base.dart';
import '../../../src/models/model_generator/report_product.dart';
import '../../../widgets/loading_api.dart';

part 'report_product_event.dart';
part 'report_product_state.dart';

class ReportProductBloc extends Bloc<ReportProductEvent, ReportProductState> {
  final UserRepository userRepository;

  ReportProductBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitReportProductState());

  @override
  Stream<ReportProductState> mapEventToState(ReportProductEvent event) async* {
    if (event is InitReportProductEvent) {
      yield* _getReportGeneral(
          event.time!, event.location!, event.cl, event.timeFrom, event.timeTo);
    }
  }

  Stream<ReportProductState> _getReportGeneral(
    int time,
    String location,
    int? cl,
    String? timeFrom,
    String? timeTo,
  ) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingReportProductState();
      final response = await userRepository.reportProduct(
        time,
        location,
        cl,
        timeFrom,
        timeTo,
      );
      if (isSuccess(response.code)) {
        yield SuccessReportProductState(response.data!.list);
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        yield ErrorReportProductState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorReportProductState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  static ReportProductBloc of(BuildContext context) =>
      BlocProvider.of<ReportProductBloc>(context);
}
