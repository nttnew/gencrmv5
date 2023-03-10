import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/models/model_generator/detail_contract.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:get/get.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/color.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/contract.dart';
import '../../src/models/model_generator/customer.dart';
import '../../src/models/model_generator/job_chance.dart';
import '../../src/navigator.dart';
import '../../widgets/widget_dialog.dart';

part 'phone_event.dart';
part 'phone_state.dart';

class PhoneBloc extends Bloc<PhoneEvent, PhoneState>{
  final UserRepository userRepository;

  PhoneBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitPhoneState());

  @override
  Stream<PhoneState> mapEventToState(PhoneEvent event) async* {
    if (event is InitPhoneEvent) {
      yield* _getPhone(event.id);
    }
    if (event is InitAgencyPhoneEvent) {
      yield* _getPhoneAgency(event.id);
    }
  }

  String phone="";

  Stream<PhoneState> _getPhone(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingPhoneState();
      final response = await userRepository.getPhoneCus(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        // if(response.data!=""&&response.data!=null){
        //   phone=response.data!;
          yield SuccessPhoneState(response.data!);
        // }
        // else{
        //   yield SuccessPhoneState(phone);
        // }
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
        yield ErrorPhoneState(response.msg ?? '');
    } catch (e) {
      yield ErrorPhoneState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<PhoneState> _getPhoneAgency(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingPhoneState();
      final response = await userRepository.getPhoneAgency(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        if(response.data!=""&&response.data!=null){
          phone=response.data!;
          yield SuccessPhoneState(response.data!);
        }
        else{
          yield SuccessPhoneState(phone);
        }
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
        yield ErrorPhoneState(response.msg ?? '');
    } catch (e) {
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
      yield ErrorPhoneState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static PhoneBloc of(BuildContext context) => BlocProvider.of<PhoneBloc>(context);
}