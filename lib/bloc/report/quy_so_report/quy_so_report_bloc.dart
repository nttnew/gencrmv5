import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../../api_resfull/user_repository.dart';
import '../../../l10n/key_text.dart';
import '../../../src/base.dart';
import '../../../src/models/model_generator/response_bao_cao_so_quy.dart';

part 'quy_so_report_event.dart';
part 'quy_so_report_state.dart';

class QuySoReportBloc extends Bloc<QuySoReportEvent, QuySoReportState> {
  final UserRepository userRepository;

  QuySoReportBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListQuySoReport());

  @override
  Stream<QuySoReportState> mapEventToState(QuySoReportEvent event) async* {
    if (event is GetDashboardQuySo) {
      yield* _getQuySoReport(
        event.nam ?? '',
        event.kyTaiChinh ?? '',
        event.location ?? '',
      );
    }
  }

  Stream<QuySoReportState> _getQuySoReport(
    String nam,
    String kyTaiChinh,
    String location,
  ) async* {
    Loading().showLoading();
    try {
      final response = await userRepository.getBaoCaoSoQuy(
        nam,
        kyTaiChinh,
        location,
        BASE_URL.PAGE_DEFAULT.toString(),
      );
      if (isSuccess(response.code)) {
        yield SuccessQuySoReportState(response.data);
      } else
        yield ErrorGetListQuySoReportState(response.msg ?? '');
    } catch (e) {
      Loading().popLoading();
      yield ErrorGetListQuySoReportState(getT(KeyT.an_error_occurred));
    }
    Loading().popLoading();
  }

  static QuySoReportBloc of(BuildContext context) =>
      BlocProvider.of<QuySoReportBloc>(context);
}
