import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../api_resfull/user_repository.dart';
import '../car_report/car_report_bloc.dart';
import '../quy_so_report/quy_so_report_bloc.dart';
import '../report_employee/report_employee_bloc.dart';
import '../report_general/report_general_bloc.dart';
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
        time: event.time,
        location: event.location,
      );
    }
  }

  Stream<OptionState> _getReportGeneral(
    int type, {
    String? kyDf,
    int? time,
    String? location,
  }) async* {
    if (type == 2)
      ReportProductBloc.of(Get.context!).add(
        InitReportProductEvent(
          location: location,
          time: time,
        ),
      );
    else if (type == 3)
      ReportEmployeeBloc.of(Get.context!).add(
        InitReportEmployeeEvent(
            time: time, diemBan: int.tryParse(location ?? '')),
      );
    else if (type == 1)
      ReportGeneralBloc.of(Get.context!).add(
        SelectReportGeneralEvent(
          location,
          time,
        ),
      );
    else if (type == 4)
      CarReportBloc.of(Get.context!).add(
        GetDashboardCar(
          time: time,
          diemBan: location,
        ),
      );
    else if (type == 5)
      QuySoReportBloc.of(Get.context!).add(
        GetDashboardQuySo(
          kyTaiChinh: kyDf,
          location: location,
        ),
      );
  }

  static OptionBloc of(BuildContext context) =>
      BlocProvider.of<OptionBloc>(context);
}
