import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../api_resfull/user_repository.dart';
import '../../../src/base.dart';
import '../../../src/color.dart';
import '../../../src/messages.dart';
import '../../../src/models/model_generator/clue.dart';
import '../../../src/navigator.dart';
import '../../../widgets/loading_api.dart';
import '../../../widgets/widget_dialog.dart';
import '../report_employee/report_employee_bloc.dart';
import '../report_general/report_general_bloc.dart';
import '../report_product/report_product_bloc.dart';

part 'option_event.dart';
part 'option_state.dart';

class OptionBloc extends Bloc<OptionEvent, OptionState>{
  final UserRepository userRepository;

  OptionBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitOptionState());

  @override
  Stream<OptionState> mapEventToState(OptionEvent event) async* {
    if (event is InitOptionEvent) {
      yield* _getReportGeneral(event.type);
    }
  }

  Stream<OptionState> _getReportGeneral(int type) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getReportOption2();
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessOptionState(response.data!.thoi_gian!,response.data!.diem_ban!,response.data!.thoi_gian_mac_dinh!);
        if(type==1)
          ReportProductBloc.of(Get.context!).add(InitReportProductEvent(location: "",time: response.data!.thoi_gian_mac_dinh!));
        else
          ReportEmployeeBloc.of(Get.context!).add(InitReportEmployeeEvent(time: response.data!.thoi_gian_mac_dinh!));
      }
      else if(response.code==999){
        Get.dialog(WidgetDialog(
          title: MESSAGES.NOTIFICATION,
          content: "Phiên đăng nhập hết hạn, hãy đăng nhập lại!",
          textButton1: "OK",
          backgroundButton1: COLORS.PRIMARY_COLOR,
          onTap1: () {
            AppNavigator.navigateLogout();
          },
        ));
      }
      else
        yield ErrorOptionState(response.msg ?? '');
    } catch (e) {
      yield ErrorOptionState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      Get.dialog(WidgetDialog(
        title: MESSAGES.NOTIFICATION,
        content: "Phiên đăng nhập hết hạn, hãy đăng nhập lại!",
        textButton1: "OK",
        backgroundButton1: COLORS.PRIMARY_COLOR,
        onTap1: () {
          AppNavigator.navigateLogout();
        },
      ));
      throw e;
    }
    LoadingApi().popLoading();
  }


  static OptionBloc of(BuildContext context) => BlocProvider.of<OptionBloc>(context);
}