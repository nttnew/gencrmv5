import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../api_resfull/user_repository.dart';
import '../../../src/base.dart';
import '../../../src/color.dart';
import '../../../src/messages.dart';
import '../../../src/models/model_generator/clue.dart';
import '../../../src/models/model_generator/report_product.dart';
import '../../../src/navigator.dart';
import '../../../widgets/loading_api.dart';
import '../../../widgets/widget_dialog.dart';

part 'report_product_event.dart';
part 'report_product_state.dart';

class ReportProductBloc extends Bloc<ReportProductEvent, ReportProductState>{
  final UserRepository userRepository;

  ReportProductBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitReportProductState());

  @override
  Stream<ReportProductState> mapEventToState(ReportProductEvent event) async* {
    if (event is InitReportProductEvent) {
      yield* _getReportGeneral(event.time!,event.location!,event.cl,event.timeFrom,event.timeTo);
    }
  }

  Stream<ReportProductState> _getReportGeneral(int time,String location,int? cl,String? timeFrom,String? timeTo) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingReportProductState();
      final response = await userRepository.reportProduct(time, location, cl, timeFrom, timeTo);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessReportProductState(response.data!.list);
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
        yield ErrorReportProductState(response.msg ?? '');
    } catch (e) {
      yield ErrorReportProductState(MESSAGES.CONNECT_ERROR);
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


  static ReportProductBloc of(BuildContext context) => BlocProvider.of<ReportProductBloc>(context);
}

class ReportSelectProductBloc extends Bloc<ReportProductEvent, ReportProductState>{
  final UserRepository userRepository;

  ReportSelectProductBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitReportSelectProductState());

  @override
  Stream<ReportProductState> mapEventToState(ReportProductEvent event) async* {
    if (event is SelectReportProductEvent){
      yield* _getReportGeneralSelect(event.time!,event.location!,event.cl,event.timeFrom,event.timeTo);
    }
  }

  Stream<ReportProductState> _getReportGeneralSelect(int time,String location,int? cl,String? timeFrom,String? timeTo) async* {
    try {
      final response = await userRepository.reportProduct(time, location, cl,timeFrom,timeTo);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessReportSelectState(response.data!.list);
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
        yield ErrorReportSelectProductState(response.msg ?? '');
    } catch (e) {
      yield ErrorReportSelectProductState(MESSAGES.CONNECT_ERROR);
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
  }


  static ReportSelectProductBloc of(BuildContext context) => BlocProvider.of<ReportSelectProductBloc>(context);
}