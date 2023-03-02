import 'dart:io';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:get/get.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/color.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/contract_customer.dart';
import '../../src/models/model_generator/customer.dart';
import '../../src/navigator.dart';
import '../../widgets/widget_dialog.dart';

part 'contact_by_customer_event.dart';
part 'contact_by_customer_state.dart';

class ContactByCustomerBloc extends Bloc<ContactByCustomerEvent, ContactByCustomerState>{
  final UserRepository userRepository;

  ContactByCustomerBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitGetContactByCustomer());

  @override
  Stream<ContactByCustomerState> mapEventToState(ContactByCustomerEvent event) async* {
    if (event is InitGetContactByCustomerrEvent) {
      yield* _getContactByCustomer(customer_id: event.id);
    }
    if (event is InitGetCustomerContractEvent) {
      yield* _getCustomerContract(page: event.page,search: event.search,success: event.success);
    }
  }

  List<CustomerData>? listCus;

  Stream<ContactByCustomerState> _getContactByCustomer({required String customer_id}) async* {
    // LoadingApi().pushLoading();
    try {
      yield LoadingContactByCustomerState();
      final response = await userRepository.getContactByCustomer(customer_id);
      // final response1 = await userRepository.getPhoneCus(customer_id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield UpdateGetContacBytCustomerState(response.data!);
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
        yield ErrorGetContactByCustomerState(response.msg ?? '');
    } catch (e) {
      yield ErrorGetContactByCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    // LoadingApi().popLoading();
  }

  Stream<ContactByCustomerState> _getCustomerContract({required String page,required String search,required Function success}) async* {
    // LoadingApi().pushLoading();
    try {
      yield LoadingContactByCustomerState();
      final response = await userRepository.getCustomerContract(page,search);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        success(response);
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
        yield ErrorGetContactByCustomerState(response.msg ?? '');
    } catch (e) {
      // LoadingApi().popLoading();
      // Get.dialog(WidgetDialog(
      //   title: MESSAGES.NOTIFICATION,
      //   content: "Phiên đăng nhập hết hạn, hãy đăng nhập lại!",
      //   textButton1: "OK",
      //   backgroundButton1: COLORS.PRIMARY_COLOR,
      //   onTap1: () {
      //     AppNavigator.navigateLogout();
      //   },
      // ));
      yield ErrorGetContactByCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    // LoadingApi().popLoading();
  }


  static ContactByCustomerBloc of(BuildContext context) => BlocProvider.of<ContactByCustomerBloc>(context);
}