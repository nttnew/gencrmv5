import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../api_resfull/user_repository.dart';
import '../../../l10n/key_text.dart';
import '../../../src/app_const.dart';
import '../../../src/base.dart';
import '../../../widgets/loading_api.dart';
import '../car_report/car_report_bloc.dart';
import '../quy_so_report/quy_so_report_bloc.dart';
import '../report_employee/report_employee_bloc.dart';
import '../report_product/report_product_bloc.dart';

part 'option_event.dart';
part 'option_state.dart';

class OptionBloc extends Bloc<OptionEvent, OptionState> {
  final UserRepository userRepository;

  OptionBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitOptionState());

  @override
  Stream<OptionState> mapEventToState(OptionEvent event) async* {
    if (event is InitOptionEvent) {
      yield* _getReportGeneral(
        event.type,
        kyDf: event.kyDf,
      );
    }
  }

  Stream<OptionState> _getReportGeneral(int type, {String? kyDf}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getReportOption2();
      if (isSuccess(response.code)) {
        yield SuccessOptionState(
          response.data!.thoi_gian!,
          response.data!.diem_ban!,
          response.data!.thoi_gian_mac_dinh!,
        );
        if (type == 1)
          ReportProductBloc.of(Get.context!).add(
            InitReportProductEvent(
              location: '',
              time: response.data!.thoi_gian_mac_dinh!,
            ),
          );
        else if (type == 2)
          ReportEmployeeBloc.of(Get.context!).add(
            InitReportEmployeeEvent(
              time: response.data!.thoi_gian_mac_dinh!,
            ),
          );
        else if (type == 4)
          CarReportBloc.of(Get.context!).add(
            GetDashboardCar(
              time: response.data!.thoi_gian_mac_dinh.toString(),
            ),
          );
        else if (type == 5)
          QuySoReportBloc.of(Get.context!).add(
            GetDashboardQuySo(
              kyTaiChinh: kyDf,
            ),
          );
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        yield ErrorOptionState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorOptionState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  static OptionBloc of(BuildContext context) =>
      BlocProvider.of<OptionBloc>(context);
}
