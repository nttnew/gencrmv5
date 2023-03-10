import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../api_resfull/user_repository.dart';
import '../../../src/base.dart';
import '../../../src/color.dart';
import '../../../src/messages.dart';
import '../../../src/models/model_generator/report_general.dart';
import '../../../src/navigator.dart';
import '../../../widgets/loading_api.dart';
import '../../../widgets/widget_dialog.dart';

part 'report_general_event.dart';
part 'report_general_state.dart';

class ReportGeneralBloc extends Bloc<ReportGeneralEvent, ReportGeneralState>{
  final UserRepository userRepository;

  ReportGeneralBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitReportGeneralState());

  @override
  Stream<ReportGeneralState> mapEventToState(ReportGeneralEvent event) async* {
    if (event is SelectReportGeneralEvent) {
      yield* _getReportContact(event.time, event.location, event.page);
    }
  }

  Stream<ReportGeneralState> _getReportContact(int? time, String? location, int? page) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingReportGeneralState();
      final response = await userRepository.reportGeneral(time, location, page);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessReportGeneralState(response.data);
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
        yield ErrorReportGeneralState(response.msg ?? '');
    } catch (e) {
      yield ErrorReportGeneralState(MESSAGES.CONNECT_ERROR);
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


  static ReportGeneralBloc of(BuildContext context) => BlocProvider.of<ReportGeneralBloc>(context);
}